-------------------------------------------
-------------------------------------------
local awful = require("awful")
local beautiful = require("beautiful")
local ui_daemon = require("daemons.system.ui")
local helpers = require("helpers")

awful.screen.connect_for_each_screen(function(s)
    for i = 1, 8, 1 do
        awful.tag.add(i, {
            screen = s,
            layout = awful.layout.layouts[1],
            centered_layout_master_fill_policy = "master_width_factor",
            selected = i == 1 and true or false,
            -- icon = beautiful.get_svg_icon{beautiful.taglist_icons[i]},
            icon = nil,
            gap = ui_daemon:get_useless_gap(),
        })
    end
end)
