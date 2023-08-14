--Standard Modules
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi


--Custom Modules
-- local user = require("ui.popups.user_profile")
local color = require("ui.popups.color")

--Username
local username = wibox.widget {
  {
    -- text = user.name,
    markup = '<span color="' ..
        color.blueish_white .. '" font="JetBrainsMono Nerd Font Bold 14">' .. 'Notification Center' .. '</span>',
    font = "JetBrainsMono Nerd Font Bold 14",
    widget = wibox.widget.textbox,
    fg = color.white
  },
  widget = wibox.container.margin,
  top = dpi(5),
  bottom = dpi(5),
  right = dpi(5),
  left = dpi(10),
}

--UserImage
-- local image = wibox.widget {
--   {
--     image = os.getenv("HOME") .. "/.config/awesome/popups/control_center/assets/user.png",
--     widget = wibox.widget.imagebox,
--     resize = true,
--     shape = function(cr, width, height)
--       gears.shape.rounded_rect(cr, width, height, 20)
--     end,
--
--   },
--   widget = wibox.container.margin,
--   top = dpi(3),
--   bottom = dpi(3),
--   right = dpi(10),
--   left = dpi(7),
--   forced_height = dpi(40)
-- }

--Main Widget
local header = wibox.widget {
  {
    {
      -- image,
      username,
      layout = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.margin,
    top = dpi(3),
    bottom = dpi(3),
    right = dpi(3),
    left = dpi(3),
  },
  widget = wibox.container.background,
  bg = color.background_lighter,
  -- forced_height = 60,
  forced_width = dpi(300),
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,

}

return header
