local wezterm = require("wezterm")

local pomodoro = require("pomodoro")
local act = wezterm.action
local keys = {
	{ key = "0", mods = "LEADER", action = act.ActivateTab(-1) },
	{ key = "Space", mods = "LEADER", action = act.ActivateCommandPalette },
	{ key = "Return", mods = "LEADER", action = act.SpawnWindow },
	{ key = "/", mods = "LEADER", action = act.Search("CurrentSelectionOrEmptyString") },
	{ key = "g", mods = "LEADER", action = act.Search({ Regex = "[a-f0-9]{6,}" }) },
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Prev") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Next") },
	{ key = "P", mods = "LEADER", action = wezterm.action_callback(pomodoro.action_callback) },
	{ key = "p", mods = "LEADER", action = act.PasteFrom("Clipboard") },
	{ key = "r", mods = "LEADER", action = act.RotatePanes("CounterClockwise") },
	{ key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "u", mods = "LEADER", action = act.CharSelect({}) },
	{ key = "t", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "x", mods = "LEADER", action = act.ActivateCopyMode },
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

return keys
