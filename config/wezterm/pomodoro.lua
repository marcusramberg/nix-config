local self = {}
local wezterm = require("wezterm")
-- config
local work_min = 20
local break_min = 5

-- locals
local pomodoro = 0
local resetWork = false
local resetBreak = false
local minute = 60

wezterm.on("update-right-status", function(window, _)
	local text = ""
	local now = math.floor(wezterm.strftime("%s") / minute)
	local since = now - pomodoro
	if since < work_min + break_min then
		if since >= work_min then
			if resetWork == false then
				resetWork = true
				window:toast_notification("pomodoro over!", "Time for a 5 minute break", nil, 4000)
			end
			text = "😴 " .. math.abs(work_min + break_min - since) .. ":00"
		else
			if resetBreak == false then
				resetBreak = true
				window:toast_notification("break over!", "Time for a another pomodoro?", nil, 4000)
			end
			text = "🍅 " .. math.abs(work_min - since) .. ":00"
		end
	end
	-- Make it italic
	window:set_right_status(wezterm.format({ { Attribute = { Italic = true } }, { Text = text } }))
end)

function self.action_callback(_, _)
	wezterm.log_info("Pomodoro started")
	pomodoro = math.floor(wezterm.strftime("%s") / minute)
	resetBreak = false
	resetWork = true
end

return self
