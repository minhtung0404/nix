#!/usr/bin/env python3
"""Export dated Obsidian tasks (Tasks-plugin syntax) to CalDAV calendars, one way.

The vault is the only source of truth: every run makes each calendar on the
server hold exactly the events found in the vault (PUT new/changed, DELETE gone).

Task syntax (Tasks plugin + Dataview inline fields):

    - [ ] Dentist 📅 2026-11-20 [time:: 14:00-15:00] [remind:: 30m, 1d] [where:: Évry]
    - [ ] Gym ⏳ 2026-11-17 [time:: 18:00] 🔁 every week on Monday, Thursday
    - [ ] Submit report 📅 2026-11-22 #🎓/PhD

  date      ⏳ scheduled, else 📅 due (tasks with neither are ignored)
  time      HH:MM or HH:MM-HH:MM (no time = all-day event)
  remind    durations before the start (10m, 1h, 1h30m, 2d, 0), or "none";
            on all-day events they count back from `allday_reminder_time`
  where     location
  cal       force a calendar by id, e.g. [cal:: ta]
  🔁        Tasks recurrence ("every 2 weeks", "every weekday", ...); "when done" is not exported as a series
  [ ] / [/] exported; [x] done and [-] cancelled are not

Usage: obsidian-calendar.py CONFIG.json [--dry-run] [-v]
"""

import argparse
import base64
import hashlib
import json
import os
import re
import sys
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from datetime import date, datetime, timedelta, timezone

# ---------------------------------------------------------------- parsing

TASK_RE = re.compile(r"^\s*(?:[-*+]|\d+[.)])\s+\[(.)\]\s+(.*)$")
INLINE_FIELD_RE = re.compile(r"[\[(]([A-Za-z][\w-]*)::\s*([^\])]*)[\])]")
DATE_RE = r"(\d{4}-\d{2}-\d{2})"
EMOJI_DATE = {
    "due": re.compile("(?:📅|📆|🗓️?)\\s*" + DATE_RE),
    "scheduled": re.compile("(?:⏳|⌛)\\s*" + DATE_RE),
    "start": re.compile("🛫\\s*" + DATE_RE),
}
# every Tasks-plugin signifier, used to strip metadata from the summary
SIGNIFIERS = "📅📆🗓⏳⌛🛫✅❌➕🔁🆔⛔🏁⏫🔼🔽⏬🔺"
RECUR_RE = re.compile("🔁\\s*([^" + SIGNIFIERS + r"\[(#]*)")
ID_RE = re.compile(r"🆔\s*([\w-]+)")
STRIP_RE = re.compile(
    "(?:[" + SIGNIFIERS + "]️?)\\s*(?:" + DATE_RE + "|[\\w,-]+)?"
)
TAG_RE = re.compile(r"(?<![\w&])#([^\s#,;:!?\"'`()\[\]{}]+)")
WIKILINK_RE = re.compile(r"\[\[([^\]|]+)(?:\|([^\]]+))?\]\]")
MDLINK_RE = re.compile(r"\[([^\]]+)\]\(([^)]+)\)")
FENCE_RE = re.compile(r"^\s*(```|~~~)")

DUR_RE = re.compile(r"^(?:(\d+)\s*w)?\s*(?:(\d+)\s*d)?\s*(?:(\d+)\s*h)?\s*(?:(\d+)\s*m(?:in)?)?$", re.I)

WEEKDAYS = {
    "monday": "MO", "tuesday": "TU", "wednesday": "WE", "thursday": "TH",
    "friday": "FR", "saturday": "SA", "sunday": "SU",
}


def parse_duration(text):
    """'1h30m' -> timedelta; '0' -> 0; None if invalid."""
    text = text.strip().lower().replace(" ", "")
    if text in ("0", "0m", "now", "attime", "at"):
        return timedelta(0)
    m = DUR_RE.match(text)
    if not text or not m or not any(m.groups()):
        return None
    w, d, h, mi = (int(g) if g else 0 for g in m.groups())
    return timedelta(weeks=w, days=d, hours=h, minutes=mi)


def parse_hhmm(text):
    m = re.fullmatch(r"(\d{1,2})[:h](\d{2})", text.strip())
    if not m or int(m[1]) > 23 or int(m[2]) > 59:
        return None
    return int(m[1]), int(m[2])


def recurrence_to_rrule(text):
    """Translate a Tasks-plugin recurrence into an RRULE, or None."""
    t = text.strip().lower().rstrip(".")
    if not t or t.endswith("when done"):
        return None
    m = re.fullmatch(r"every\s+(?:(\d+)\s+)?(day|week|month|year)s?(?:\s+on\s+(.+))?", t)
    if t == "every weekday":
        return "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR"
    if not m:
        return None
    n = int(m[1]) if m[1] else 1
    unit, on = m[2], m[3]
    rule = {"day": "DAILY", "week": "WEEKLY", "month": "MONTHLY", "year": "YEARLY"}[unit]
    parts = ["FREQ=" + rule] + ([f"INTERVAL={n}"] if n > 1 else [])
    if on:
        if unit == "week":
            days = [WEEKDAYS.get(d.strip().rstrip("s")) or WEEKDAYS.get(d.strip())
                    for d in re.split(r",|\band\b", on) if d.strip()]
            if not days or None in days:
                return None
            parts.append("BYDAY=" + ",".join(days))
        elif unit == "month":
            mm = re.fullmatch(r"the\s+(\d{1,2})(?:st|nd|rd|th)?", on.strip())
            if mm:
                parts.append("BYMONTHDAY=" + mm[1])
            elif re.fullmatch(r"the\s+last(?:\s+day)?", on.strip()):
                parts.append("BYMONTHDAY=-1")
            else:
                return None
        else:
            return None
    return ";".join(parts)


@dataclass
class Event:
    uid: str
    calendar: str
    summary: str
    day: date
    start: tuple = None          # (h, m) or None for all-day
    end: tuple = None
    reminders: list = field(default_factory=list)   # list[timedelta] before start
    location: str = ""
    rrule: str = None
    source: str = ""             # vault-relative path
    line: int = 0


def clean_summary(text):
    text = INLINE_FIELD_RE.sub("", text)
    text = RECUR_RE.sub("", text)
    text = STRIP_RE.sub("", text)
    text = TAG_RE.sub("", text)
    text = WIKILINK_RE.sub(lambda m: m[2] or m[1].split("#")[0].split("/")[-1], text)
    text = MDLINK_RE.sub(r"\1", text)
    text = text.replace("**", "").replace("__", "").replace("==", "")
    return re.sub(r"\s{2,}", " ", text).strip(" -–—")


def frontmatter_tags(lines):
    """Tags from the YAML frontmatter (`tags: [a, b]` or a `- a` list)."""
    if not lines or lines[0].strip() != "---":
        return [], 0
    tags, in_tags = [], False
    for i, line in enumerate(lines[1:], 1):
        if line.strip() in ("---", "..."):
            return [t.lstrip("#") for t in tags if t], i + 1
        m = re.match(r"^(tags?)\s*:\s*(.*)$", line)
        if m:
            in_tags = True
            val = m[2].strip().strip("[]")
            tags += [t.strip().strip("'\"") for t in val.split(",") if t.strip()]
            continue
        if in_tags and re.match(r"^\s*-\s+", line):
            tags.append(line.split("-", 1)[1].strip().strip("'\""))
        elif not line.startswith((" ", "\t")):
            in_tags = False
    return [], 0


def tag_matches(tags, wanted):
    """`#Life` matches #Life and #Life/laundry (case-insensitive)."""
    for w in wanted:
        w = w.lstrip("#").lower()
        for t in tags:
            t = t.lower()
            if t == w or t.startswith(w + "/"):
                return True
    return False


def pick_calendar(cfg, rel_path, task_tags, note_tags, forced):
    cals = cfg["calendars"]
    ids = {c["id"] for c in cals}
    if forced and forced.lower() in ids:
        return forced.lower()
    for c in cals:  # task tags first: the most specific signal
        if tag_matches(task_tags, c.get("tags", [])):
            return c["id"]
    for c in cals:
        if tag_matches(note_tags, c.get("tags", [])):
            return c["id"]
    for c in cals:
        if any(rel_path == f.rstrip("/") or rel_path.startswith(f.rstrip("/") + "/")
               for f in c.get("folders", [])):
            return c["id"]
    return cfg["default_calendar"]


def parse_reminders(raw, allday, cfg, warn):
    if raw is None:
        raw_list = cfg["default_reminders_allday" if allday else "default_reminders_timed"]
    elif raw.strip().lower() in ("none", "no", "off", "-"):
        return []
    else:
        raw_list = [r for r in re.split(r"[,;]", raw) if r.strip()]
    out = []
    for r in raw_list:
        d = parse_duration(r)
        if d is None:
            warn(f"bad remind value {r!r}")
        elif d not in out:
            out.append(d)
    return out


def scan_vault(cfg, log):
    vault = cfg["vault"]
    excludes = [e.rstrip("/") for e in cfg.get("exclude", [])]
    cutoff = date.today() - timedelta(days=cfg.get("past_days", 60))
    events, seen_uids, md_files = [], {}, 0

    for root, dirs, files in os.walk(vault):
        rel_root = os.path.relpath(root, vault)
        rel_root = "" if rel_root == "." else rel_root
        dirs[:] = sorted(d for d in dirs if not d.startswith(".")
                         and os.path.join(rel_root, d) not in excludes)
        for name in sorted(files):
            if not name.endswith(".md") or name.startswith("."):
                continue
            rel = os.path.join(rel_root, name)
            if rel in excludes:
                continue
            md_files += 1
            try:
                with open(os.path.join(root, name), encoding="utf-8") as f:
                    lines = f.read().splitlines()
            except (OSError, UnicodeDecodeError) as e:
                log(f"skip {rel}: {e}")
                continue
            note_tags, body_start = frontmatter_tags(lines)
            in_fence = False
            for lineno, line in enumerate(lines, 1):
                if lineno <= body_start:
                    continue
                if FENCE_RE.match(line):
                    in_fence = not in_fence
                    continue
                if in_fence:
                    continue
                m = TASK_RE.match(line)
                if not m or m[1] not in cfg.get("statuses", [" ", "/"]):
                    continue
                ev = parse_task(cfg, rel, lineno, m[2], note_tags, cutoff, log)
                if not ev:
                    continue
                # identical tasks in one note get distinct, stable uids
                n = seen_uids.get(ev.uid, 0)
                seen_uids[ev.uid] = n + 1
                if n:
                    ev.uid = f"{ev.uid}-{n}"
                events.append(ev)
    return events, md_files


def parse_task(cfg, rel, lineno, text, note_tags, cutoff, log):
    def warn(msg):
        log(f"{rel}:{lineno}: {msg}")

    dates = {k: r.search(text) for k, r in EMOJI_DATE.items()}
    d = dates["scheduled"] or dates["due"]
    if not d:
        return None
    try:
        day = date.fromisoformat(d[1])
    except ValueError:
        warn(f"bad date {d[1]}")
        return None

    fields = {k.lower(): v.strip() for k, v in INLINE_FIELD_RE.findall(text)}
    rec = RECUR_RE.search(text)
    rrule = None
    if rec and rec[1].strip():
        rrule = recurrence_to_rrule(rec[1])
        if rrule is None and not rec[1].strip().lower().endswith("when done"):
            warn(f"recurrence not understood, exported once: {rec[1].strip()!r}")
    if day < cutoff and not rrule:
        return None

    start = end = None
    if fields.get("time"):
        parts = re.split(r"\s*[-–]\s*", fields["time"])
        start = parse_hhmm(parts[0])
        end = parse_hhmm(parts[1]) if len(parts) > 1 else None
        if start is None or (len(parts) > 1 and end is None):
            warn(f"bad time {fields['time']!r}, exported as all-day")
            start = end = None

    summary = clean_summary(text)
    if not summary:
        return None
    task_tags = TAG_RE.findall(text)
    cal = pick_calendar(cfg, rel, task_tags, note_tags, fields.get("cal"))

    tid = ID_RE.search(text)
    uid_src = tid[1] if tid else f"{rel}\0{summary}"
    uid = hashlib.sha1(uid_src.encode()).hexdigest()[:20]

    return Event(
        uid=uid, calendar=cal, summary=summary, day=day, start=start, end=end,
        reminders=parse_reminders(fields.get("remind"), start is None, cfg, warn),
        location=fields.get("where", fields.get("location", "")),
        rrule=rrule, source=rel, line=lineno,
    )


# ---------------------------------------------------------------- iCalendar

# Europe/Paris and the other zones on the EU CET/CEST rule
CET_ZONES = {"Europe/Paris", "Europe/Berlin", "Europe/Brussels", "Europe/Amsterdam",
             "Europe/Madrid", "Europe/Rome", "Europe/Vienna", "Europe/Zurich",
             "Europe/Luxembourg", "Europe/Prague", "Europe/Stockholm", "Europe/Oslo",
             "Europe/Copenhagen", "Europe/Warsaw", "Europe/Budapest"}


def vtimezone(tz):
    return [
        "BEGIN:VTIMEZONE", f"TZID:{tz}",
        "BEGIN:DAYLIGHT", "TZOFFSETFROM:+0100", "TZOFFSETTO:+0200", "TZNAME:CEST",
        "DTSTART:19700329T020000", "RRULE:FREQ=YEARLY;BYMONTH=3;BYDAY=-1SU", "END:DAYLIGHT",
        "BEGIN:STANDARD", "TZOFFSETFROM:+0200", "TZOFFSETTO:+0100", "TZNAME:CET",
        "DTSTART:19701025T030000", "RRULE:FREQ=YEARLY;BYMONTH=10;BYDAY=-1SU", "END:STANDARD",
        "END:VTIMEZONE",
    ]


def esc(text):
    return (text.replace("\\", "\\\\").replace(";", "\\;").replace(",", "\\,")
            .replace("\n", "\\n"))


def fold(line):
    """RFC 5545 line folding at 75 octets, never inside a UTF-8 sequence."""
    raw = line.encode()
    if len(raw) <= 75:
        return line
    out, cur = [], b""
    for ch in line:
        b = ch.encode()
        if len(cur) + len(b) > (75 if not out else 74):
            out.append(cur.decode())
            cur = b""
        cur += b
    out.append(cur.decode())
    return "\r\n ".join(out)


def trigger(delta):
    """TRIGGER value for an alarm `delta` before the start (negative = after)."""
    secs = int(delta.total_seconds())
    sign = "-" if secs > 0 else ""
    secs = abs(secs)
    d, rem = divmod(secs, 86400)
    h, rem = divmod(rem, 3600)
    m = rem // 60
    s = sign + "P" + (f"{d}D" if d else "")
    if h or m or not d:
        s += "T" + (f"{h}H" if h else "") + (f"{m}M" if m or not h else "")
    return s


def event_body(ev, cfg):
    """Every property except DTSTAMP, so unchanged events hash the same."""
    tz = cfg.get("timezone", "")
    lines = [f"UID:{ev.uid}@obsidian", f"SUMMARY:{esc(ev.summary)}"]
    if ev.start is None:
        lines += [f"DTSTART;VALUE=DATE:{ev.day:%Y%m%d}",
                  f"DTEND;VALUE=DATE:{ev.day + timedelta(days=1):%Y%m%d}",
                  "TRANSP:TRANSPARENT"]
    else:
        start = datetime.combine(ev.day, datetime.min.time()).replace(hour=ev.start[0], minute=ev.start[1])
        if ev.end:
            end = start.replace(hour=ev.end[0], minute=ev.end[1])
            if end <= start:
                end += timedelta(days=1)
        else:
            end = start + timedelta(minutes=cfg.get("default_duration_minutes", 60))
        param = f";TZID={tz}" if tz in CET_ZONES else ""
        lines += [f"DTSTART{param}:{start:%Y%m%dT%H%M%S}", f"DTEND{param}:{end:%Y%m%dT%H%M%S}"]
    if ev.rrule:
        lines.append(f"RRULE:{ev.rrule}")
    if ev.location:
        lines.append(f"LOCATION:{esc(ev.location)}")
    allday_at = parse_hhmm(cfg.get("allday_reminder_time", "09:00")) or (9, 0)
    for r in ev.reminders:
        if ev.start is None:  # all-day: count back from e.g. 09:00 on the day
            r = r - timedelta(hours=allday_at[0], minutes=allday_at[1])
        lines += ["BEGIN:VALARM", "ACTION:DISPLAY", f"DESCRIPTION:{esc(ev.summary)}",
                  f"TRIGGER:{trigger(r)}", "END:VALARM"]
    return lines


def to_ics(ev, body, cfg):
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    tz = cfg.get("timezone", "")
    lines = ["BEGIN:VCALENDAR", "VERSION:2.0", "PRODID:-//obsidian-calendar//EN", "CALSCALE:GREGORIAN"]
    if ev.start is not None and tz in CET_ZONES:
        lines += vtimezone(tz)
    # VALARM blocks sit inside the VEVENT, after its own properties
    lines += ["BEGIN:VEVENT", f"DTSTAMP:{stamp}", f"LAST-MODIFIED:{stamp}"] + body + ["END:VEVENT", "END:VCALENDAR"]
    return "\r\n".join(fold(l) for l in lines) + "\r\n"


# ---------------------------------------------------------------- CalDAV

NS = {"D": "DAV:", "C": "urn:ietf:params:xml:ns:caldav", "A": "http://apple.com/ns/ical/"}


class DAV:
    def __init__(self, base, user, password, dry_run, log):
        self.base = base.rstrip("/") + "/"
        self.auth = "Basic " + base64.b64encode(f"{user}:{password}".encode()).decode()
        self.dry_run, self.log = dry_run, log

    def req(self, method, path, body=None, headers=None, ok=(200, 201, 204, 207)):
        url = urllib.parse.urljoin(self.base, path)
        h = {"Authorization": self.auth, **(headers or {})}
        data = body.encode() if isinstance(body, str) else body
        r = urllib.request.Request(url, data=data, method=method, headers=h)
        try:
            with urllib.request.urlopen(r, timeout=30) as resp:
                return resp.status, resp.read()
        except urllib.error.HTTPError as e:
            if e.code in ok:
                return e.code, e.read()
            raise RuntimeError(f"{method} {url}: HTTP {e.code} {e.read()[:300]!r}") from None

    def propfind(self, path, depth, props):
        body = ('<?xml version="1.0" encoding="utf-8"?><D:propfind xmlns:D="DAV:" '
                'xmlns:C="urn:ietf:params:xml:ns:caldav" xmlns:A="http://apple.com/ns/ical/">'
                f'<D:prop>{props}</D:prop></D:propfind>')
        status, data = self.req("PROPFIND", path, body,
                                {"Depth": str(depth), "Content-Type": "application/xml"},
                                ok=(207, 404))
        return None if status == 404 else ET.fromstring(data)

    def ensure_principal(self, path):
        """The read-only owner never logs in with write rights, so create its home."""
        if self.propfind(path, 0, "<D:resourcetype/>") is None:
            self.log(f"create principal collection {path}")
            if not self.dry_run:
                self.req("MKCOL", path)

    def ensure_calendar(self, path, name, color):
        tree = self.propfind(path, 0, "<D:displayname/><A:calendar-color/><D:resourcetype/>")
        props = (f"<D:displayname>{xml_escape(name)}</D:displayname>"
                 f"<A:calendar-color>{xml_escape(color)}</A:calendar-color>")
        if tree is None:
            self.log(f"create calendar {path} ({name})")
            if not self.dry_run:
                self.req("MKCALENDAR", path,
                         '<?xml version="1.0" encoding="utf-8"?><C:mkcalendar xmlns:D="DAV:" '
                         'xmlns:C="urn:ietf:params:xml:ns:caldav" xmlns:A="http://apple.com/ns/ical/">'
                         f'<D:set><D:prop>{props}<C:supported-calendar-component-set>'
                         '<C:comp name="VEVENT"/></C:supported-calendar-component-set>'
                         '</D:prop></D:set></C:mkcalendar>',
                         {"Content-Type": "application/xml"})
            return
        cur_name = tree.findtext(".//D:displayname", "", NS)
        cur_color = tree.findtext(".//A:calendar-color", "", NS)
        if cur_name != name or cur_color.lower()[:7] != color.lower()[:7]:
            self.log(f"update calendar {path}: name={name} color={color}")
            if not self.dry_run:
                self.req("PROPPATCH", path,
                         '<?xml version="1.0" encoding="utf-8"?><D:propertyupdate xmlns:D="DAV:" '
                         f'xmlns:A="http://apple.com/ns/ical/"><D:set><D:prop>{props}</D:prop>'
                         '</D:set></D:propertyupdate>', {"Content-Type": "application/xml"})

    def list_items(self, path):
        """{resource name: etag} of the calendar at `path`."""
        tree = self.propfind(path, 1, "<D:getetag/>")
        items = {}
        if tree is None:
            return items
        for resp in tree.findall("D:response", NS):
            href = urllib.parse.unquote(resp.findtext("D:href", "", NS))
            name = href.rstrip("/").rsplit("/", 1)[-1]
            if href.rstrip("/").endswith(path.rstrip("/")) or not name.endswith(".ics"):
                continue
            items[name] = resp.findtext(".//D:getetag", "", NS)
        return items


def xml_escape(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


# ---------------------------------------------------------------- main

def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("config")
    ap.add_argument("--dry-run", action="store_true", help="parse and diff, change nothing")
    ap.add_argument("-v", "--verbose", action="store_true")
    ap.add_argument("--list", action="store_true", help="print the parsed events and exit")
    args = ap.parse_args()

    with open(args.config) as f:
        cfg = json.load(f)
    cfg["vault"] = os.path.expanduser(cfg["vault"])
    cfg.setdefault("default_calendar", cfg["calendars"][-1]["id"])
    cfg.setdefault("default_reminders_timed", ["10m"])
    cfg.setdefault("default_reminders_allday", ["0"])

    def log(msg):
        print(msg, flush=True)

    # an unmounted vault looks empty: never let that wipe the calendars
    if not os.path.isdir(cfg["vault"]):
        log(f"vault {cfg['vault']} not available; nothing done")
        return 0
    events, md_files = scan_vault(cfg, log)
    if md_files == 0:
        log(f"no notes found in {cfg['vault']} (not mounted?); nothing done")
        return 0

    if args.list:
        for ev in sorted(events, key=lambda e: (e.day, e.start or (0, 0))):
            when = f"{ev.day} " + (f"{ev.start[0]:02}:{ev.start[1]:02}" if ev.start else "all-day")
            extra = (f" 🔁{ev.rrule}" if ev.rrule else "") + \
                    (f" 🔔{','.join(trigger(r) for r in ev.reminders)}" if ev.reminders else "")
            print(f"[{ev.calendar:>8}] {when:<17} {ev.summary}{extra}   ({ev.source}:{ev.line})")
        print(f"{len(events)} event(s) from {md_files} note(s)")
        return 0

    with open(os.path.expanduser(cfg["password_file"])) as f:
        password = f.read().strip()
    dav = DAV(cfg["server"], cfg["username"], password, args.dry_run, log)

    state_path = os.path.join(os.environ.get("XDG_STATE_HOME", os.path.expanduser("~/.local/state")),
                              "obsidian-calendar", "state.json")
    try:
        with open(state_path) as f:
            state = json.load(f)   # "<cal>/<uid>.ics" -> [content hash, etag]
    except (OSError, ValueError):
        state = {}

    by_cal = {c["id"]: [] for c in cfg["calendars"]}
    for ev in events:
        by_cal[ev.calendar].append(ev)

    owner = cfg["owner"]
    new_state, changes = {}, 0
    dav.ensure_principal(f"{owner}/")
    for c in cfg["calendars"]:
        path = f"{owner}/{c['id']}/"
        dav.ensure_calendar(path, c["name"], c["color"])
        remote = dav.list_items(path)
        wanted = {}
        for ev in by_cal[c["id"]]:
            body = event_body(ev, cfg)
            wanted[f"{ev.uid}.ics"] = (ev, body, hashlib.sha1("\n".join(body).encode()).hexdigest())

        for name, (ev, body, digest) in wanted.items():
            key = f"{c['id']}/{name}"
            prev = state.get(key)
            if name in remote and prev and prev[0] == digest and prev[1] == remote[name]:
                new_state[key] = prev
                continue
            changes += 1
            if args.verbose or args.dry_run:
                log(f"{'update' if name in remote else 'add'} {c['id']}: {ev.day} {ev.summary}")
            if not args.dry_run:
                dav.req("PUT", path + name, to_ics(ev, body, cfg),
                        {"Content-Type": "text/calendar; charset=utf-8"})
                new_state[key] = [digest, None]   # etag filled in below
        for name in remote.keys() - wanted.keys():
            changes += 1
            if args.verbose or args.dry_run:
                log(f"delete {c['id']}: {name}")
            if not args.dry_run:
                dav.req("DELETE", path + name, ok=(200, 204, 404))

        # etags as the server reports them after the writes
        if not args.dry_run:
            fresh = dav.list_items(path)
            for name in wanted:
                key = f"{c['id']}/{name}"
                if key in new_state and new_state[key][1] is None:
                    new_state[key][1] = fresh.get(name, "")

    if not args.dry_run:
        os.makedirs(os.path.dirname(state_path), exist_ok=True)
        tmp = state_path + ".tmp"
        with open(tmp, "w") as f:
            json.dump(new_state, f)
        os.replace(tmp, state_path)
    log(f"{len(events)} event(s) in vault, {changes} change(s)" + (" (dry run)" if args.dry_run else ""))
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except urllib.error.URLError as e:  # e.g. Radicale not started yet: retry next run
        print(f"CalDAV server unreachable ({e.reason}); nothing done", flush=True)
        sys.exit(0)
