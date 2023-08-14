-------------------------------------------
-------------------------------------------
local awful = require("awful")
local bling = require("external.bling")
-- local machi = require("external.layout-machi")
local capi = {
    tag = tag
}

capi.tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts {
        awful.layout.suit.tile,
        -- awful.layout.suit.tile.right,
        -- awful.layout.suit.tile.left,
        -- awful.layout.suit.tile.bottom,
        -- awful.layout.suit.tile.top,
        -- awful.layout.suit.corner.nw,.
        -- awful.layout.suit.corner.ne,
        -- awful.layout.suit.corner.sw,
        -- awful.layout.suit.corner.se,
        -- awful.layout.suit.fair,
        -- awful.layout.suit.fair.horizontal,
        -- awful.layout.suit.magnifier,
        -- awful.layout.suit.max,
        -- awful.layout.suit.max.fullscreen,
        -- awful.layout.suit.spiral.dwindle,
        -- bling.layout.mstab,
        bling.layout.centered,
        bling.layout.vertical,
        bling.layout.horizontal,
        bling.layout.equalarea,
        bling.layout.deck,
        awful.layout.suit.floating,
        -- machi.default_layout
    }
end)

-- machi.editor.nested_layouts["4"] = bling.layout.deck
