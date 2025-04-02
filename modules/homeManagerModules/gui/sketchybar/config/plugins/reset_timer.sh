#!/usr/bin/env bash

pid=$(ps -A | grep -v 'grep' | grep -v 'sh' | grep ~/.config/sketchybar/plugins/timer.py | sed 's/^[[:blank:]]*//g' | cut -d ' ' -f 1)
ps -A | grep -v 'grep' | grep -v 'sh' | grep ~/.config/sketchybar/plugins/timer.py | sed 's/^[[:blank:]]*//g'

if [[ -n $pid ]]; then
	kill ${pid}
fi

sketchybar --set timer label=""
