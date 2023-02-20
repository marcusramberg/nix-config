local wezterm = require("wezterm")
local pomodoro = require("pomodoro")

local keys = {
	-- { key = "P", mods = "SUPER", action = wezterm.action.EmitEvent("start-pomodoro") },
	{
		key = "P",
		mods = "LEADER",
		action = wezterm.action_callback(pomodoro.action_callback),
	},
	{ key = "G", mods = "SUPER", action = wezterm.action({ Search = { Regex = "[a-f0-9]{6,}" } }) },
	{
		key = "V",
		mods = "SUPER|ALT|CTRL|SHIFT",
		action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }),
	},
	{
		key = "S",
		mods = "SUPER|ALT|CTRL|SHIFT",
		action = wezterm.action({ SplitHorizontal = {
			domain = "CurrentPaneDomain",
		} }),
	},
	{ key = "H", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Prev" }) },
	{ key = "J", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "K", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "L", mods = "CTRL|SHIFT", action = wezterm.action({ ActivatePaneDirection = "Next" }) },
	{ key = "0", mods = "CTRL", action = wezterm.action({ ActivateTab = -1 }) },
}
for i = 1, 9 do
	table.insert(keys, {
		key = tostring(i),
		mods = "CTRL",
		action = wezterm.action({ ActivateTab = i - 1 }),
	})
end
local config = {
	leader = { key = "space", mods = "CTRL" },
	adjust_window_size_when_changing_font_size = false,
	audible_bell = "Disabled",
	check_for_updates = false,
	color_scheme = "tokyonight-storm",
	tab_max_width = 20,
	colors = {
		tab_bar = {
			background = "#16161e",
			active_tab = {
				bg_color = "#292e42",
				fg_color = "#c0caf5",
				intensity = "Bold",
				underline = "None",
			},
			inactive_tab = {
				bg_color = "#16161e",
				fg_color = "#a9b1d6",
			},
			inactive_tab_hover = {
				bg_color = "#1a1b26",
				fg_color = "#ff9e64",
				underline = "Single",
			},
		},
	},
	default_gui_startup_args = { "connect", "unix" },
	font_rules = {
		{
			italic = true,
			font = wezterm.font("Iosevka Nerd Font", { italic = true }),
			-- font = wezterm.font("JetBrainsMono Nerd Font", {weight='ExtraLight', italic=true})
		},
	},
	font = wezterm.font("JetBrainsMono Nerd Font"),
	hide_tab_bar_if_only_one_tab = true,
	inactive_pane_hsb = {
		saturation = 0.7,
		brightness = 0.7,
	},
	keys = keys,
	pane_focus_follows_mouse = false,
	mouse_bindings = {
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = wezterm.action({ CopyTo = "Clipboard" }),
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = "OpenLinkAtMouseCursor",
		},
	},
	ssh_domains = {
		{
			name = "mbook",
			remote_address = "mbook",
			username = "marcus",
		},
		{
			name = "march",
			remote_address = "march",
			username = "marcus",
		},
	},
	unix_domains = {
		{
			name = "unix",
		},
	},
	use_fancy_tab_bar = false,
	window_background_opacity = 0.95,
	window_decorations = "RESIZE",
}

-- Reduce fontsize to fix dpi issue on mArch
if wezterm.hostname() == "butterbee" then
	config.font_size = 12.0
elseif wezterm.hostname() == "mbook" then
	config.font_size = 16.0
end

return config
