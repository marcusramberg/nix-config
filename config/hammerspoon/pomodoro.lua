local pom_work_period_sec = 1500 -- 25 * 60  = 1500
local pom_rest_period_sec = 300 -- 5 * 60 = 300
local pom_15min_period_sec = 600
local pom_work_count = 0
local pom_curr_active_type = "Work" -- {"work", "rest"}
local pom_activity_name = "\u{1F525}"
local pom_is_active = false
local pom_time_left = pom_work_period_sec
local pom_disable_count = 0
local pom_restart = 0
local pom_menu
local pom_timer

-- update display
local function pom_update_display()
	local time_min = math.floor((pom_time_left / 60))
	local time_sec = pom_time_left - (time_min * 60)
	local str = string.format("%s%02d:%02d", pom_activity_name, time_min, time_sec)
	local styled_str = hs.styledtext.new(str, {
		font = { name = "Helvetica Neue", size = 14 },
		paragraphStyle = { alignment = "left" },
		baselineOffset = 0,
	})
	pom_menu:setTitle(styled_str)
end

-- stop the clock
local function pom_disable()
	-- disabling pomodoro twice will reset the countdown
	local pom_was_active = pom_is_active
	pom_is_active = false

	if pom_disable_count == 0 then
		if pom_was_active then
			pom_timer:stop()
		end
	elseif pom_disable_count == 1 then
		pom_time_left = pom_work_period_sec
		pom_update_display()
		hs.notify.new({ title = "Pomodoro", informativeText = "Pomodoro paused." }):send()
	elseif pom_disable_count >= 2 then
		hs.notify.new({ title = "Pomodoro", informativeText = "Pomodoro canceled." }):send()
		if pom_menu == nil then
			pom_disable_count = 2
			return
		end
		pom_menu:delete()
		pom_menu = nil
		pom_timer:stop()
		pom_timer = nil
	end

	pom_disable_count = pom_disable_count + 1
end

-- update pomodoro timer
local function pom_update_time()
	if pom_is_active == false then
		return
	else
		pom_time_left = pom_time_left - 1

		if pom_time_left <= 0 then
			-- pom_disable()
			if pom_curr_active_type == "Work" then
				-- hs.alert.show("Work Complete!", 2)
				hs.notify
					.new(function()
						pom_time_left = 0
					end, {
						title = "Pomodoro",
						informativeText = "Pomodoro complete!",
						soundName = "default",
						actionButtonTitle = "Skip Rest",
					})
					:send()
				pom_work_count = pom_work_count + 1
				pom_curr_active_type = "Rest"
				pom_time_left = pom_rest_period_sec
				pom_activity_name = "\u{1F366}"
				pom_restart = 1
			-- pom_timer:start()
			else
				-- pom_disable()
				-- hs.alert.show("Done resting",2)
				hs.notify
					.new(function()
						pom_enable()
					end, {
						title = "Pomodoro",
						informativeText = "Rest complete!",
						soundName = "default",
						actionButtonTitle = "Start New",
					})
					:send()
				pom_curr_active_type = "Work"
				pom_time_left = pom_work_period_sec
				pom_activity_name = "\u{1F525}"
				pom_restart = 0
			end
			if pom_restart == 0 then
				pom_disable()
			end
		end
	end
end

-- update menu display
local function pom_update_menu()
	pom_update_time()
	pom_update_display()
end

local function pom_create_menu(pom_origin)
	if pom_menu == nil then
		pom_menu = hs.menubar.new()
	end
end

function pom_enable()
	pom_disable_count = 0
	if pom_is_active then
		return
	elseif pom_timer == nil then
		hs.notify.new({ title = "Pomodoro started", informativeText = "How much can you do in 25 minutes?." }):send()
		pom_create_menu()
		pom_timer = hs.timer.new(1, pom_update_menu)
	end
	pom_timer:start()
	pom_is_active = true
	local time_min = math.floor((pom_time_left / 60))
end

-- init pomodoro
-- pom_create_menu()
-- pom_update_menu()

hs.hotkey.bind({ "cmd", "alt", "shift" }, "0", function()
	pom_disable()
end)
hs.hotkey.bind({ "cmd", "alt", "shift" }, "9", function()
	pom_enable()
end)
hs.hotkey.bind({ "cmd", "alt", "shift" }, "8", function()
	pom_time_left = pom_15min_period_sec
	pom_enable()
end)
hs.hotkey.bind({ "cmd", "alt", "shift" }, "7", function()
	pom_time_left = pom_time_left - 60
end)

return { init = module_init }
