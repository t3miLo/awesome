local awful = require("awful")
local bling = require("external.bling")
local ui_daemon = require("daemons.system.ui")
local helpers = require("helpers")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local playerctl_daemon = require("daemons.system.playerctl")

local capi = {
    awesome = awesome,
    client = client
}

local keys = {
    mod = "Mod4",
    ctrl = "Control",
    shift = "Shift",
    alt = "Mod1"
}

-- =============================================================================
--  Awesome
-- =============================================================================
awful.keyboard.append_global_keybindings({
    -- restart awesomewm
    awful.key {
        modifiers = { keys.mod, keys.ctrl},
        key = "r",
        group = "awesome",
        description = "reload",
        on_press = capi.awesome.restart
    },
    -- quit awesomewm
    awful.key {
        modifiers = { keys.mod, keys.shift },
        key = "q",
        group = "awesome",
        description = "quit",
        on_press = capi.awesome.quit
    },
    -- show help / keybinds
    awful.key {
        modifiers = { keys.mod, keys.ctrl },
        key = "s",
        group = "awesome",
        description = "Show Help",
        on_press = function(c)
            hotkeys_popup.show_help()
        end
    }

})

-- =============================================================================
--  Screen
-- =============================================================================
awful.keyboard.append_global_keybindings({
    -- Focus the next screen
    awful.key {
        modifiers = { keys.mod, keys.ctrl },
        key = "h",
        group = "screen",
        description = "focus the next screen",
        on_press = function(c)
            awful.screen.focus_relative(1)
        end
    },
    -- Focus the previous screen
    awful.key {
        modifiers = { keys.mod, keys.ctrl },
        key = "l",
        group = "screen",
        description = "focus the previous screen",
        on_press = function(c)
            awful.screen.focus_relative(-1)
        end
    }
})

-- =============================================================================
--  Client
-- =============================================================================
capi.client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        -- Focus a client
        awful.button {
            modifiers = {},
            button = 1,
            on_press = function(c)
                if c.can_focus ~= false then
                    c:activate {
                        context = "mouse_click"
                    }
                end
            end
        },
        -- Make a client floating and move it
        awful.button {
            modifiers = { keys.mod },
            button = 1,
            on_press = function(c)
                if c.can_move ~= false then
                    c.floating = true
                    c.maximized = false
                    c.fullscreen = false
                    c:activate {
                        context = "mouse_click",
                        action = "mouse_move"
                    }
                end
            end
        },
        -- Make a client floating and resize it
        awful.button {
            modifiers = { keys.mod },
            button = 3,
            on_press = function(c)
                if c.can_resize ~= false then
                    c.floating = true
                    c.maximized = false
                    c.fullscreen = false
                    c:activate {
                        context = "mouse_click",
                        action = "mouse_resize"
                    }
                end
            end
        }
    })
end)

capi.client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        -- Close client
        awful.key {
            modifiers = { keys.mod, keys.shift },
            key = "x",
            group = "client",
            description = "close",
            on_press = function(c)
                if c.can_kill ~= false then
                    c:kill()
                end
            end
        },
        -- Toggle floating
        awful.key {
            modifiers = { keys.mod },
            key = "space",
            group = "client",
            description = "toggle floating",
            on_press = function(c)
                if c.floating == true and c.can_tile == false then
                    return
                end
                awful.client.floating.toggle()
            end
        },
        -- Toggle fullscreen
        awful.key {
            modifiers = { keys.mod },
            key = "f",
            group = "client",
            description = "toggle fullscreen",
            on_press = function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end
        },
        -- Toggle maximize client
        awful.key {
            modifiers = { keys.mod },
            key = "m",
            group = "client",
            description = "toggle maximize client",
            on_press = function(c)
                c.maximized = not c.maximized
                c:raise()
            end
        },
        -- Toggle maximize client vertically
        awful.key {
            modifiers = { keys.mod, keys.ctrl },
            key = "m",
            group = "client",
            description = "toggle maximize client vertically",
            on_press = function(c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end
        },
        -- Toggle maximize client horizontally
        awful.key {
            modifiers = { keys.mod, keys.shift },
            key = "m",
            group = "client",
            description = "toggle maximize client horizontally",
            on_press = function(c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end
        },
        -- Minimize client
        awful.key {
            modifiers = { keys.mod },
            key = "n",
            group = "client",
            description = "minimize",
            on_press = function(c)
                c.minimized = true
            end
        },
        -- Restore minimized clients
        awful.key {
            modifiers = { keys.mod, keys.shift },
            key = "n",
            group = "client",
            description = "restore minimized",
            on_press = function()
                local c = awful.client.restore()
                if c then
                    c:activate {
                        raise = true,
                        context = "key.unminimize"
                    }
                end
            end
        },
        -- Make tiny float and keep on top
        awful.key {
            modifiers = { keys.mod, keys.shift },
            key = "b",
            group = "client",
            description = "make tiny float and keep on top",
            on_press = function(c)
                c.floating = not c.floating
                c.width = 400
                c.height = 200
                awful.placement.bottom_right(c)
                c.sticky = not c.sticky
            end
        },
        -- Move and resize to center
        awful.key {
            modifiers = { keys.mod, keys.shift },
            key = "c",
            group = "client",
            description = "move and resize to center",
            on_press = function(c)
                helpers.client.float_and_resize(c, awful.screen.focused().geometry.width * 0.9,
                    awful.screen.focused().geometry.height * 0.9)
            end
        },
        --
        -- Resize up
        awful.key {
            modifiers = { keys.mod, keys.ctrl },
            key = "Up",
            group = "client",
            description = "resize up",
            on_press = function(c)
                if c.can_resize ~= false then
                    helpers.client.resize(c, "up")
                end
            end
        },
        -- Resize down
        awful.key {
            modifiers = { keys.mod, keys.ctrl },
            key = "Down",
            group = "client",
            description = "resize down",
            on_press = function(c)
                if c.can_resize ~= false then
                    helpers.client.resize(c, "down")
                end
            end
        },
        -- Resize left
        awful.key {
            modifiers = { keys.mod, keys.ctrl },
            key = "Left",
            group = "client",
            description = "resize left",
            on_press = function(c)
                if c.can_resize ~= false then
                    helpers.client.resize(c, "left")
                end
            end
        },
        -- Resize right
        awful.key {
            modifiers = { keys.mod, keys.ctrl },
            key = "Right",
            group = "client",
            description = "resize right",
            on_press = function(c)
                if c.can_resize ~= false then
                    helpers.client.resize(c, "right")
                end
            end
        },

        -- Focus next
        awful.key {
            modifiers = { keys.mod },
            key = "j",
            group = "client",
            description = "focus next",
            on_press = function()
                awful.client.focus.byidx(1)
            end
        },
        -- Focus previous
        awful.key {
            modifiers = { keys.mod },
            key = "k",
            group = "client",
            description = "focus previous",
            on_press = function()
                awful.client.focus.byidx(-1)
            end
        },
        -- Swap with next
        awful.key {
            modifiers = { keys.mod, keys.shift },
            key = "k",
            group = "client",
            description = "swap with next",
            on_press = function()
                awful.client.swap.byidx(1)
            end
        },
        -- Swap with previous
        awful.key {
            modifiers = { keys.mod, keys.shift },
            key = "j",
            group = "client",
            description = "swap with previous",
            on_press = function()
                awful.client.swap.byidx(-1)
            end
        },
        -- Swap focused client with master
        awful.key {
            modifiers = { keys.mod, keys.shift },
            key = "Return",
            group = "client",
            description = "swap with master",
            on_press = function(c)
                c:swap(awful.client.getmaster())
            end
        },
        -- Go back in history
        awful.key {
            modifiers = { keys.mod },
            key = "Tab",
            group = "client",
            description = "go back in history",
            on_press = function(c)
                awful.client.focus.history.previous()
                c:raise()
            end
        },
        -- Jump to urgent
        awful.key {
            modifiers = { keys.mod, keys.shift },
            key = "u",
            group = "client",
            description = "jump to urgent",
            on_press = awful.client.urgent.jumpto
        },
        -- Bling-tabbed - pick client to add to tab group
        awful.key {
            modifiers = { keys.alt },
            key = "a",
            group = "client",
            description = "pick client to add to tab group",
            on_press = function(c)
                bling.module.tabbed.pick()
            end
        },
        -- Bling-tabbed - iterate through tabbing group
        awful.key {
            modifiers = { keys.alt },
            key = "s",
            group = "client",
            description = "iterate through tabbing group",
            on_press = function(c)
                bling.module.tabbed.iter()
            end
        },
        -- Bling-tabbed - remove focused client from tabbing group
        awful.key {
            modifiers = { keys.alt },
            key = "d",
            group = "client",
            description = "remove focused client from tabbing group",
            on_press = function(c)
                bling.module.tabbed.pop()
            end
        },
        -- Move Client to next screen
        awful.key {
            modifiers = { keys.mod },
            key = "o",
            group = "client",
            description = "Moves client to next window",
            on_press = function(c)
                c:move_to_screen()
            end
        }
    })
end)


-- =============================================================================
--  Layout
-- =============================================================================
awful.keyboard.append_global_keybindings({
    -- Add padding
    awful.key {
        modifiers = { keys.mod, keys.shift },
        key = "=",
        group = "layout",
        description = "increase padding",
        on_press = function()
            local current_client_gap = ui_daemon:get_client_gap()
            ui_daemon:set_client_gap(current_client_gap + 5)
        end
    },
    -- Subtract padding
    awful.key {
        modifiers = { keys.mod, keys.shift },
        key = "-",
        group = "layout",
        description = "decrease padding",
        on_press = function()
            local current_client_gap = ui_daemon:get_client_gap()
            ui_daemon:set_client_gap(current_client_gap - 5)
        end
    },

    -- Increase useless gaps
    awful.key {
        modifiers = { keys.mod },
        key = "=",
        group = "layout",
        description = "increase useless gaps",
        on_press = function()
            local current_useless_gap = ui_daemon:get_useless_gap()
            ui_daemon:set_useless_gap(current_useless_gap + 5)
        end
    },
    -- Decrease useless gaps
    awful.key {
        modifiers = { keys.mod },
        key = "-",
        group = "layout",
        description = "decrease useless gaps",
        on_press = function()
            local current_useless_gap = ui_daemon:get_useless_gap()
            ui_daemon:set_useless_gap(current_useless_gap - 5)
        end
    },

    -- Increase master width
    awful.key {
        modifiers = { keys.mod },
        key = "h",
        group = "layout",
        description = "increase master width",
        on_press = function()
            awful.tag.incmwfact(0.05)
        end
    },
    -- Decrease master width
    awful.key {
        modifiers = { keys.mod },
        key = "l",
        group = "layout",
        description = "decrease master width",
        on_press = function()
            awful.tag.incmwfact(-0.05)
        end
    },

    -- Decrase number of master clients
    awful.key {
        modifiers = { keys.mod, keys.shift },
        key = "h",
        group = "layout",
        description = "decrease number of master clients",
        on_press = function()
            awful.tag.incnmaster(-1, nil, true)
        end
    },
    -- Increase number of master clients
    awful.key {
        modifiers = { keys.mod, keys.shift },
        key = "l",
        group = "layout",
        description = "increase number of master clients",
        on_press = function()
            awful.tag.incnmaster(1, nil, true)
        end
    },

    -- Increase number of columns
    awful.key {
        modifiers = { keys.mod, keys.ctrl },
        key = "h",
        group = "layout",
        description = "increase number of columns",
        modifiers = { keys.mod, keys.ctrl },
        key = "l",
        group = "layout",
        description = "decrease number of columns",
        on_press = function()
            awful.tag.incncol(-1, nil, true)
        end
    }
})

-- =============================================================================
--  Tag
-- =============================================================================
awful.keyboard.append_global_keybindings({
    -- View desktop
    awful.key {
        modifiers = { keys.mod },
        key = "s",
        group = "tag",
        description = "view none",
        on_press = function()
            awful.tag.viewnone()
        end
    },
    -- View a tag
    awful.key {
        modifiers = { keys.mod },
        keygroup = "numrow",
        description = "view tag",
        group = "tag",
        on_press = function(index)
            -- needed for the last tag
            if index == 0 then
                index = 10
            end
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag == screen.selected_tag then
                awful.tag.history.restore(screen)
            else
                tag:view_only()
            end
            -- helpers.misc.tag_back_and_forth(index)
        end
    },
    -- Toggle tag
    awful.key {
        modifiers = { keys.mod, keys.ctrl },
        keygroup = "numrow",
        description = "toggle tag",
        group = "tag",
        on_press = function(index)
            -- needed for the last tag
            if index == 0 then
                index = 10
            end
            local tag = awful.screen.focused().tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end
    },
    -- Move focused client to tag
    awful.key {
        modifiers = { keys.mod, keys.shift },
        keygroup = "numrow",
        description = "move focused client to tag",
        group = "tag",
        on_press = function(index)
            -- needed for the last tag
            if index == 0 then
                index = 10
            end
            local focused_client = capi.client.focus
            if focused_client then
                local tag = awful.screen.focused().tags[index]
                if tag then
                    focused_client:move_to_tag(tag)
                end
            end
        end
    },
    -- Move focused client and switch to tag
    awful.key {
        modifiers = { keys.mod, keys.ctrl },
        keygroup = "numrow",
        description = "move focused client and switch to tag",
        group = "tag",
        on_press = function(index)
            -- needed for the last tag
            if index == 0 then
                index = 10
            end
            local focused_client = capi.client.focus
            if focused_client then
                local tag = awful.screen.focused().tags[index]
                if tag then
                    focused_client:move_to_tag(tag)
                    tag:view_only()
                end
            end
        end
    }
})

-- =============================================================================
--  UI
-- =============================================================================

awful.keyboard.append_global_keybindings({
    -- Toggle app launcher
    awful.key {
        modifiers = { keys.mod },
        key = "p",
        group = "ui",
        description = "toggle app launcher",
        on_press = function()
            awful.util.spawn("rofi -show drun")
            -- app_launcher:show()
        end
    }
})



-- =============================================================================
--  Media
-- =============================================================================
awful.keyboard.append_global_keybindings({
    -- Toogle media
    awful.key {
        modifiers = {},
        key = "XF86AudioPlay",
        group = "media",
        description = "toggle media",
        on_press = function()
            playerctl_daemon:play_pause()
        end
    },
    -- Previous media
    awful.key {
        modifiers = {},
        key = "XF86AudioPrev",
        group = "media",
        description = "previous media",
        on_press = function()
            playerctl_daemon:previous()
        end
    },
    -- Next media
    awful.key {
        modifiers = {},
        key = "XF86AudioNext",
        group = "media",
        description = "next media",
        on_press = function()
            playerctl_daemon:next()
        end
    },

    -- Raise volume
    awful.key {
        modifiers = {},
        key = "XF86AudioRaiseVolume",
        group = "media",
        description = "increase volume",
        on_press = function()
            audio_daemon:get_default_sink():volume_up(5)
        end
    },
    -- Lower volume
    awful.key {
        modifiers = {},
        key = "XF86AudioLowerVolume",
        group = "media",
        description = "decrease volume",
        on_press = function()
            audio_daemon:get_default_sink():volume_down(5)
        end
    },
    -- Mute volume
    awful.key {
        modifiers = {},
        key = "XF86AudioMute",
        group = "media",
        description = "mute volume",
        on_press = function()
            audio_daemon:get_default_sink():toggle_mute()
        end
    },

    -- Increase brightness
    awful.key {
        modifiers = {},
        key = "XF86MonBrightnessUp",
        group = "media",
        description = "increase brightness",
        on_press = function()
            brightness_daemon:increase_brightness(5)
        end
    },
    -- Decrease brightness
    awful.key {
        modifiers = {},
        key = "XF86MonBrightnessDown",
        group = "media",
        description = "decrease brightness",
        on_press = function()
            brightness_daemon:decrease_brightness(5)
        end
    },

    -- Toggle Screenshot app
    awful.key {
        modifiers = {},
        key = "Print",
        group = "media",
        description = "toggle screenshot app",
        on_press = function()
            screenshot_app:show()
        end
    },
    -- Take a screenshot
    awful.key {
        modifiers = { keys.mod },
        key = "Print",
        group = "media",
        description = "take a screenshot",
        on_press = function()
            screenshot_daemon:screenshot()
        end
    },

    -- Pick a coilor
    awful.key {
        modifiers = { keys.alt },
        key = "Print",
        group = "media",
        description = "color picker",
        on_press = function()
            screenshot_daemon:pick_color()
        end
    },

    -- Start recording
    awful.key {
        modifiers = { keys.mod },
        key = "F5",
        group = "media",
        description = "start recording",
        on_press = function()
            record_daemon:start_video()
        end
    },
    -- Stop recording
    awful.key {
        modifiers = { keys.mod },
        key = "F6",
        group = "media",
        description = "stop recording",
        on_press = function()
            record_daemon:stop_video()
        end
    },

    -- sync openrgb colors with theme
    awful.key {
        modifiers = { keys.mod, keys.ctrl },
        key = "w",
        group = "media",
        description = "sync openrgb colors with theme",
        on_press = function()
            openrgb_daemon:update_colors()
        end
    },

    -- turn off all openrgb leds
    awful.key {
        modifiers = { keys.mod, keys.alt },
        key = "w",
        group = "media",
        description = "turn off all openrgb leds",
        on_press = function()
            openrgb_daemon:turn_off()
        end
    }
})
