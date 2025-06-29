pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("collision")()
-- require("collision") {
--     --        Normal    Xephyr       Vim      G510
--     up    = { "k" },
--     down  = { "j" },
--     left  = { "h" },
--     right = { "l" },
-- }

require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

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

-- {{{ Variables
beautiful.init(os.getenv("HOME") .. "/.config/awesome/theme.lua")

terminal = "wezterm"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"

local scriptspath = "exec ~/.config/awesome/scripts/"
local startscript = scriptspath .. "startup.sh"
local bookmakrsscript = scriptspath .. "dmenu-bookmarks.bash"
local logoutscript = scriptspath .. "logout.bash"

awful.layout.layouts = {
	awful.layout.suit.tile.left,
	awful.layout.suit.floating,
}

-- }}}


-- {{{ Widgets

mykeyboardlayout = awful.widget.keyboardlayout()
mykeyboardlayout2 = string.format(" [%s] ", mykeyboardlayout)

separator = wibox.widget {
	markup = "│",
	halign = "center",
	valign = "center",
	widget = wibox.widget.textbox
}

my_textclock = wibox.widget.textclock(" %a %b %d, %H:%M ")

local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t) t:view_only() end),
	awful.button({ modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
	awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal(
				"request::activate",
				"tasklist",
				{ raise = true }
			)
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

awful.screen.connect_for_each_screen(function(s)
	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist {
		screen  = s,
		filter  = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
		layout  = {
			spacing = 2,
			layout  = wibox.layout.fixed.horizontal
		},
	}
	-- s.mytaglist:set_base_size(20)

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist {
		screen  = s,
		filter  = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons
	}

	s.mylaoutbox = awful.widget.layoutbox(s)
	s.mylaoutbox.forced_width = 20

	s.fistwg = {
		-- color  = "#dddddd",
		orientation  = "vertical",
		forced_width = 13,
		shape        = gears.shape.powerline,
		widget       = wibox.widget.separator,
	}

	-- s.mylaoutbox.layout = wibox.container.margin(_, 0, 0, 0)
	s.middlewigdet = wibox.widget.systray()

	-- Create the wibox
	s.mywibox = awful.wibar({ position = "top", screen = s, height = 23 })

	-- Add widgets to the wibox
	s.mywibox:setup {
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			spacing = 10,
			layout = wibox.layout.fixed.horizontal,
			s.fistwg,
			s.mytaglist,
		},
		-- s.middlewigdet,
		s.mytasklist, -- Middle widget
		{             -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			mykeyboardlayout,
			wibox.widget.systray(),
			my_textclock,
			s.mylaoutbox
		},
	}
end)
-- }}}

root.buttons(gears.table.join(
-- awful.button({}, 3, function() mymainmenu:toggle() end),
	awful.button({}, 4, awful.tag.viewnext),
	awful.button({}, 5, awful.tag.viewprev)
))

-- {{{ Key bindings
globalkeys = gears.table.join(
	awful.key({ modkey, "Control" }, "s", hotkeys_popup.show_help,
			  { description = "show help", group = "awesome" }),
	awful.key({ modkey }, "s",
			  function()
				  local screen = awful.screen.focused()
				  local tag = screen.tags[9]
				  if tag then
					  tag:view_only()
				  end
			  end,
			  { description = "view tag 9", group = "tag" }),


	awful.key({ modkey, "Shift" }, "s",
			  function()
				  if client.focus then
					  local tag = client.focus.screen.tags[9]
					  if tag then
						  client.focus:move_to_tag(tag)
					  end
				  end
			  end,
			  { description = "move focused client to tag 9", group = "tag" }),
	awful.key({ modkey, }, "Escape", awful.tag.history.restore,
			  { description = "go back", group = "tag" }),
	awful.key({ modkey, }, "k", function()
				  awful.client.focus.byidx(1)
			  end,
			  { description = "focus next by index", group = "client" }
	),
	awful.key({ modkey, }, "j", function()
				  awful.client.focus.byidx(-1)
			  end,
			  { description = "focus previous by index", group = "client" }
	),

	-- Layout manipulation
	awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
			  { description = "swap with next client by index", group = "client" }),
	awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
			  { description = "swap with previous client by index", group = "client" }),
	awful.key({ modkey }, "j", function() awful.screen.focus_relative(1) end,
			  { description = "focus the next screen", group = "screen" }),
	awful.key({ modkey }, "k", function() awful.screen.focus_relative(-1) end,
			  { description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
			  { description = "jump to urgent client", group = "client" }),
	awful.key({ modkey, }, "Tab",
			  function()
				  awful.client.focus.history.previous()
				  if client.focus then
					  client.focus:raise()
				  end
			  end,
			  { description = "go back", group = "client" }),

	-- Standard program
	awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
			  { description = "open a terminal", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "\\", awesome.quit,
			  { description = "quit awesome", group = "awesome" }),
	awful.key({ modkey, "Shift" }, "`", function() awful.spawn.with_shell(logoutscript) end,
			  { description = "reboot", group = "awesome" }),
	awful.key({ modkey, }, "h", function() awful.tag.incmwfact(0.05) end,
			  { description = "increase master width factor", group = "layout" }),
	awful.key({ modkey, }, "l", function() awful.tag.incmwfact(-0.05) end,
			  { description = "decrease master width factor", group = "layout" }),
	awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
			  { description = "increase the number of master clients", group = "layout" }),
	awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
			  { description = "decrease the number of master clients", group = "layout" }),
	awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
			  { description = "increase the number of columns", group = "layout" }),
	awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
			  { description = "decrease the number of columns", group = "layout" }),
	awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
			  { description = "select next", group = "layout" }),
	awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
			  { description = "select previous", group = "layout" }),

	awful.key({ modkey, "Control" }, "n",
			  function()
				  local c = awful.client.restore()
				  -- Focus restored client
				  if c then
					  c:emit_signal(
						  "request::activate", "key.unminimize", { raise = true }
					  )
				  end
			  end,
			  { description = "restore minimized", group = "client" }),

	-- Prompt
	awful.key({ modkey }, "p", function() awful.spawn("bemenu-run") end,
			  { description = "launch dmenu", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "o", function() awful.spawn("keepmenu") end,
			  { description = "launch keepmenu", group = "launcher" }),
	awful.key({ modkey }, "a", function() awful.spawn("clipcat-menu") end,
			  { description = "launch clipmenu", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "d", function() awful.spawn("flameshot gui") end,
			  { description = "make screenshot", group = "launcher" }),
	awful.key({ modkey }, "e", function() awful.spawn(terminal .. ' -e fish -c "yy; fish"') end,
			  { description = "launch yazi", group = "launcher" }),
	awful.key({ modkey }, ";", function() awful.spawn(terminal .. " -e btop") end,
			  { description = "launch yazi", group = "launcher" }),
	awful.key({ modkey, "Shift" }, ";", function() awful.spawn(terminal .. " -e timer") end,
			  { description = "launch yazi", group = "launcher" }),
	awful.key({ modkey, "Shift" }, "e", function() awful.spawn.with_shell(bookmakrsscript) end,
			  { description = "launch bookmakrsscript", group = "launcher" })
)

clientkeys = gears.table.join(
	awful.key({ modkey, }, "f",
			  function(c)
				  c.fullscreen = not c.fullscreen
				  c:raise()
			  end,
			  { description = "toggle fullscreen", group = "client" }),
	awful.key({ modkey, }, "q", function(c) c:kill() end,
			  { description = "close", group = "client" }),
	awful.key({ modkey }, "v", awful.client.floating.toggle,
			  { description = "toggle floating", group = "client" }),
	awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
			  { description = "move to master", group = "client" }),
	awful.key({ modkey }, "o", function(c) c:move_to_screen() end,
			  { description = "move to screen", group = "client" }),
	awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
			  { description = "toggle keep on top", group = "client" }),
	awful.key({ modkey, }, "n",
			  function(c)
				  -- The client currently has the input focus, so it cannot be
				  -- minimized, since minimized clients can't have the focus.
				  c.minimized = true
			  end,
			  { description = "minimize", group = "client" }),
	awful.key({ modkey, }, "m",
			  function(c)
				  c.maximized = not c.maximized
				  c:raise()
			  end,
			  { description = "(un)maximize", group = "client" }),
	awful.key({ modkey, "Control" }, "m",
			  function(c)
				  c.maximized_vertical = not c.maximized_vertical
				  c:raise()
			  end,
			  { description = "(un)maximize vertically", group = "client" }),
	awful.key({ modkey, "Shift" }, "m",
			  function(c)
				  c.maximized_horizontal = not c.maximized_horizontal
				  c:raise()
			  end,
			  { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(globalkeys,
		-- View tag only.
								  awful.key({ modkey }, "#" .. i + 9,
											function()
												local screen = awful.screen.focused()
												local tag = screen.tags[i]
												if tag then
													tag:view_only()
												end
											end,
											{ description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
								  awful.key({ modkey, "Control" }, "#" .. i + 9,
											function()
												local screen = awful.screen.focused()
												local tag = screen.tags[i]
												if tag then
													awful.tag.viewtoggle(tag)
												end
											end,
											{ description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
								  awful.key({ modkey, "Shift" }, "#" .. i + 9,
											function()
												if client.focus then
													local tag = client.focus.screen.tags[i]
													if tag then
														client.focus:move_to_tag(tag)
													end
												end
											end,
											{ description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
								  awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
											function()
												if client.focus then
													local tag = client.focus.screen.tags[i]
													if tag then
														client.focus:toggle_tag(tag)
													end
												end
											end,
											{ description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
		-- All clients will match this rule.
		{
			rule = {},
			properties = {
				border_width = beautiful.border_width,
				border_color = beautiful.border_normal,
				focus = awful.client.focus.filter,
				raise = true,
				keys = clientkeys,
				buttons = clientbuttons,
				screen = awful.screen.preferred,
				placement = awful.placement.no_overlap + awful.placement.no_offscreen,
				maximized_vertical = false,
				maximized_horizontal = false,
				floating = false,
				maximized = false
			}
		},

		-- {
		--     rule = { class = "steam", name = "Friends List" },
		--     properties = {
		--         floating = true,
		--         placement = awful.placement.centered,
		--     }
		-- },
		-- {
		--     rule = { class = "steam", name = "Steam Settings" },
		--     properties = {
		--         floating = true,
		--         placement = awful.placement.centered,
		--     }
		-- },
		{
			rule_any = { name = { "Steam Settings", "Friends List" }, class = { "steam" } },
			properties = {
				floating = true,
				placement = awful.placement.centered,
			}
		},
		{
			rule_any = { name = { "Save Image" }, class = { "floorp" } },
			properties = {
				floating = true,
				placement = awful.placement.centered,
			}
		},
		{
			rule_any = { name = { "Welcome to GIMP 3.0.4" }, class = { "gimp" } },
			properties = {
				floating = true,
				placement = awful.placement.centered,
			}
		},
		{
			rule_any = { name = { "Save File" }, class = { "xdg-desktop-portal-gtk" } },
			properties = {
				floating = true,
				placement = awful.placement.centered,
			}
		},
		{
			rule_any = { class = { "vesktop" } },
			properties = {
				screen = 3,
				tag = "1"
			}
		},
		{
			rule_any = { class = { "floorp" } },
			properties = {
				screen = 2,
				tag = "9",
				floating = false,
				maximized = false
			}
		},
		{
			rule_any = { class = { "firefox" } },
			properties = {
				screen = 1,
				tag = "1"
			}
		},
		{
			rule_any = { class = { "discord" } },
			properties = {
				screen = 3,
				tag = "1"
			}
		},
		{
			rule_any = { class = { "nekobox" } },
			properties = {
				screen = 2,
				tag = "8"
			}
		},
		{
			rule_any = { class = { "ayugram-desktop", "AyuGramDesktop" } },
			properties = {
				screen = 3,
				tag = "2"
			}
		}
	},
	-- }}}

	awful.spawn.with_shell(startscript)
awful.spawn.with_shell([[
    setxkbmap -layout 'us,ru' -option 'grp:alt_shift_toggle';
    xsct 4000;
    xset r rate 155 35; setxkbmap -option caps:escape;
;]])
