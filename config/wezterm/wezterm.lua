local wezterm = require("wezterm")
local pomodoro = require("pomodoro")

local act = wezterm.action
local keys = {
	{ key = "0", mods = "LEADER", action = act.ActivateTab(-1) },
	{ key = "Space", mods = "LEADER", action = act.ActivateCommandPalette },
	{ key = "g", mods = "LEADER", action = act.Search({ Regex = "[a-f0-9]{6,}" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Prev") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Next") },
	{ key = "p", mods = "LEADER", action = wezterm.action_callback(pomodoro.action_callback) },
	{ key = "r", mods = "LEADER", action = act.RotatePanes("CounterClockwise") },
	{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "u", mods = "LEADER", action = act.CharSelect({}) },
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
}
for _, mod in ipairs({ "CTRL", "LEADER" }) do
	for i = 1, 9 do
		table.insert(keys, {
			key = tostring(i),
			mods = mod,
			action = wezterm.action({ ActivateTab = i - 1 }),
		})
	end
end
local config = {
	leader = { key = "Space", mods = "CTRL" },
	adjust_window_size_when_changing_font_size = false,
	audible_bell = "Disabled",
	check_for_updates = false,
	color_scheme = "nord",
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
	pane_focus_follows_mouse = true,
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
