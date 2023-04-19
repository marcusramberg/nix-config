local wezterm = require("wezterm")

local config = {
	adjust_window_size_when_changing_font_size = false,
	audible_bell = "Disabled",
	check_for_updates = false,
	color_scheme = "nord",
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
	font = wezterm.font("JetBrainsMono Nerd Font"),
	font_rules = {
		{
			italic = true,
			font = wezterm.font("Iosevka Nerd Font", { italic = true }),
		},
	},
	hyperlink_rules = {
		-- Linkify things that look like URLs and the host has a TLD name.
		{
			regex = "\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b",
			format = "$0",
		},
		{
			regex = [[\bfile://\S*\b]],
			format = "$0",
		},
		{
			regex = [[\b(LAKE|APP)-(\d+)\b]],
			format = "https://getremarkable.atlassian.net/browse/$1-$2",
		},
		{
			regex = [[[^/]?([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)[^/]?]],
			format = "https://www.github.com/$1/$3",
		},
		{
			regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
			format = "$0",
		},
	},
	hide_tab_bar_if_only_one_tab = true,
	inactive_pane_hsb = {
		saturation = 0.7,
		brightness = 0.7,
	},
	leader = { key = "Space", mods = "CTRL" },
	keys = require("keys"),
	mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = "OpenLinkAtMouseCursor",
		},
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = wezterm.action({ CopyTo = "Clipboard" }),
		},
	},
	pane_focus_follows_mouse = true,
	ssh_domains = {
		{
			name = "mbook",
			remote_address = "mbook",
			username = "marcus",
		},
		{
			name = "mhub",
			remote_address = "mhub",
			username = "marcus",
		},
		{
			name = "butterbee",
			remote_address = "nixos",
			username = "marcus",
		},
	},
	tab_max_width = 20,
	unix_domains = {
		{
			name = "unix",
		},
	},
	use_dead_keys = false,
	use_fancy_tab_bar = false,
	window_background_opacity = 0.95,
	window_decorations = "RESIZE",
}

-- Reduce fontsize to fix dpi issue on mArch
if wezterm.hostname() == "butterbee" then
	config.font_size = 12.0
elseif wezterm.hostname() == "mbook" or wezterm.hostname() == "mtop" then
	config.font_size = 16.0
end

return config
