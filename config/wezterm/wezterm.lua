local wezterm = require("wezterm")

local config = wezterm.config_builder()

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, _config, hover, max_width)
	local background = "#2E3440"
	local foreground = "#D8DEE9"

	local symbolic = " "

	if tab.is_active then
		background = "#434C5E"
		foreground = "#B48EAD"
		symbolic = " "
	elseif hover then
		background = "#363646"
		foreground = "#A3BE8C"
	end

	local edge_background = background
	local edge_foreground = "#5E81AC"
	local separator = " ⊣ "

	-- ensure that the titles fit in the available space,
	-- and that we have room for the edges.
	local title = tab_title(tab)
	if #title > max_width then
		title = "…" .. string.sub(title, #title - max_width + 5)
	end

	return {
		-- Separator
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		-- Active / Inactive
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = symbolic .. " " .. title },
		-- Separator
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = separator },
	}
end)

config.adjust_window_size_when_changing_font_size = false
config.audible_bell = "Disabled"
config.check_for_updates = false
config.color_scheme = "nord"
config.colors = {
	tab_bar = {
		background = "#16161e",
		active_tab = {
			bg_color = "#5E81AC",
			fg_color = "#ECEFF4",
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
}
config.default_gui_startup_args = { "connect", "unix" }
config.freetype_load_flags = "NO_HINTING"
config.font = wezterm.font("JetBrainsMono NF")
config.font_rules = {
	{
		italic = true,
		font = wezterm.font("Iosevka Nerd Font", { italic = true }),
	},
}
config.hide_tab_bar_if_only_one_tab = true
config.inactive_pane_hsb = { saturation = 0.7, brightness = 0.7 }
config.leader = { key = "Space", mods = "CTRL" }
config.keys = require("keys")
config.mouse_bindings = {
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
}
config.pane_focus_follows_mouse = true
config.ssh_domains = {
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
}
config.tab_max_width = 30
config.unix_domains = {
	{
		name = "unix",
	},
}
config.use_dead_keys = false
config.use_fancy_tab_bar = false
config.window_background_opacity = 0.98
config.window_decorations = "RESIZE"

config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- make username/project paths clickable. this implies paths like the following are for github.
-- ( "nvim-treesitter/nvim-treesitter" | wbthomason/packer.nvim | wez/wezterm | "wez/wezterm.git" )
-- as long as a full url hyperlink regex exists above this it should not match a full url to
-- github or gitlab / bitbucket (i.e. https://gitlab.com/user/project.git is still a whole clickable url)
table.insert(config.hyperlink_rules, {
	regex = [[["'\s]([\w\d]{1}[-\w\d]+)(/){1}([-\w\d\.]+)["'\s]] .. "]",
	format = "https://www.github.com/$1/$3",
})

-- Reduce fontsize to fix dpi issue on mArch
if wezterm.hostname() == "butterbee" then
	config.font_size = 14.0
elseif wezterm.hostname() == "mbook" or wezterm.hostname() == "mtop" then
	config.font_size = 16.0
end

return config
