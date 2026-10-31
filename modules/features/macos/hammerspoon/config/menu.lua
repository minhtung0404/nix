local util_menu = hs.menubar.new()
local log = hs.logger.new("menu", "info")

local icon = [[
1 . . . . . . . . . . . 3
. # # . . . . . . . # # .
. # # # # . . . # # # # .
. . # # # # 2 # # # # . .
. . # # # # # # # # # . .
. . . # # # # # # # . . .
. . . 8 # # # # # 4 . . .
. . . # # # # # # # . . .
. . # # # # # # # # # . .
. . # # # # 6 # # # # . .
. # # # # . . . # # # # .
. # # . . . . . . . # # .
7 . . . . . . . . . . . 5
]]

if util_menu then
  util_menu:setIcon("ASCII:" .. icon)
end

local menu = {}

local reload_menu = function()
  if util_menu then
    util_menu:setMenu(menu)
  end
end

hs.caffeinate.toggle("displayIdle")

menu = {
  {
    title = "🥱",
    fn = function(_, _)
      log.d(hs.inspect(menu[1]))
      local enabled = hs.caffeinate.toggle("displayIdle")

      if enabled then
        menu[1].title = "🥱"
      else
        menu[1].title = "😴"
      end

      reload_menu()
    end,
  },
  {
    title = "-",
  },
  {
    title = "Reload Config",
    fn = function(_, menu_item)
      log.d(menu_item)
      hs.reload()
    end,
  },
  {
    title = "Open Console",
    fn = function(_, menu_item)
      log.d(menu_item)
      hs.openConsole(true)
    end,
  },
}

reload_menu()

return {
  util_menu = util_menu,
}
