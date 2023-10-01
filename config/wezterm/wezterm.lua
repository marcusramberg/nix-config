local wezterm = require("wezterm")

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

wezterm.on("format-tab-title", function(tab, _tabs, _panes, _config, _hover, max_width)
	local title = tab_title(tab)
	if #title > max_width then
		title = "…" .. string.sub(title, #title - max_width + 2)
	end
	return { { Text = " " .. title .. " " } }
end)

local config = {
	adjust_window_size_when_changing_font_size = false,
	audible_bell = "Disabled",
	check_for_updates = false,
	color_scheme = "nord",
	colors = {
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
	},
	default_gui_startup_args = { "connect", "unix" },
	font = wezterm.font("JetBrainsMono Nerd Font"),
	font_rules = {
		{
			italic = true,
			font = wezterm.font("Iosevka Nerd Font", { italic = true }),
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
	tab_max_width = 30,
	unix_domains = {
		{
			name = "unix",
		},
	},
	use_dead_keys = false,
	use_fancy_tab_bar = false,
	window_background_opacity = 0.98,
	window_decorations = "RESIZE",
}

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
	config.font_size = 12.0
elseif wezterm.hostname() == "mbook" or wezterm.hostname() == "mtop" then
	config.font_size = 16.0
end

return config
