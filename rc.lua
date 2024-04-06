-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init('/home/albert/.config/awesome/themes/theme.lua')

beautiful.useless_gap = 5

require("config")
require("ui.topbar.topbar")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end
-- }}}

-- This is used later as the default terminal and editor to run.
terminal = "kitty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.



local menu_terminal = { "open terminal", terminal }


-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
-- mykeyboardlayout = awful.widget.keyboardlayout()


-- Create a wibox for each screen and add it
-- local taglist_buttons = gears.table.join(
    -- awful.button({}, 1, function(t) t:view_only() end),
    -- awful.button({ modkey }, 1, function(t)
        -- if client.focus then
            -- client.focus:move_to_tag(t)
        -- end
    -- end),
    -- awful.button({}, 3, awful.tag.viewtoggle),
    -- awful.button({ modkey }, 3, function(t)
        -- if client.focus then
            -- client.focus:toggle_tag(t)
        -- end
    -- end),
    -- awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    -- awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
-- )

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)


-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- awful.spawn.with_shell("picom -b --config ~/.config/picom/picom.conf --experimental-backends --transparent-clipping")
-- awful.spawn.with_shell(
-- "picom -b --config ~/.config/kawesome/config/picom.conf --experimental-backends --transparent-clipping")
awful.spawn.with_shell("playerctld daemon")
awful.spawn.with_shell("nm-applet")
awful.spawn.with_shell("~/.config/awesome/wallpaper.sh")
awful.spawn.with_shell("blueman-applet")
-- awful.spawn.with_shell("shutter --min_at_startup")

