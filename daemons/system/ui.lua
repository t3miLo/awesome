-------------------------------------------
-------------------------------------------
local awful = require("awful")
local gobject = require("gears.object")
local gtable = require("gears.table")
local beautiful = require("beautiful")
local helpers = require("helpers")
-- local filesystem = require("external.filesystem")
local ipairs = ipairs
local os = os
local capi = {
    root = root,
    screen = screen
}

local ui = {}
local instance = nil

-- Useless gaps
function ui:set_useless_gap(useless_gap, save)
    if useless_gap < 0 then
        useless_gap = 0
    end

    for _, tag in ipairs(capi.root.tags()) do
        tag.gap = useless_gap
    end

    for screen in capi.screen do
        awful.layout.arrange(screen)
    end

    self._private.useless_gap = useless_gap
    self:emit_signal("useless_gap", useless_gap)
    if save ~= false then
        helpers.settings["layout.useless_gap"] = useless_gap
    end
end

function ui:get_useless_gap()
    if self._private.useless_gap == nil then
        self._private.useless_gap = helpers.settings["layout.useless_gap"]
    end

    return self._private.useless_gap
end

-- Client gaps
function ui:set_client_gap(client_gap, save)
    if client_gap < 0 then
        client_gap = 0
    end

    for screen in capi.screen do
        screen.padding = {
            left = client_gap,
            right = client_gap,
            top = client_gap,
            bottom = client_gap
        }
        awful.layout.arrange(screen)
    end

    self._private.client_gap = client_gap
    self:emit_signal("client_gap", client_gap)
    if save ~= false then
        helpers.settings["layout.client_gap"] = client_gap
    end
end

function ui:get_client_gap()
    if self._private.client_gap == nil then
        self._private.client_gap = helpers.settings["layout.client_gap"]
    end

    return self._private.client_gap
end

local function new()
    local ret = gobject {}
    gtable.crush(ret, ui, true)

    ret._private = {}

    ret:set_useless_gap(ret:get_useless_gap(), false)
    ret:set_client_gap(ret:get_client_gap(), false)
    -- ret:set_animations(ret:get_animations(), false)
    -- ret:set_animations_framerate(ret:get_animations_framerate(), false)


    return ret
end

if not instance then
    instance = new()
end
return instance
