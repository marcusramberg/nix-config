local hyper = { "cmd", "alt", "ctrl", "shift" }
local cmd = { "cmd" }
local ctrl = { "ctrl" }
local ctrl_shift = { "ctrl", "shift" }

local lastSpace = nil
local logger = hs.logger.new("wm", "info")

hs.application.enableSpotlightForNameSearches(true)
hs.window.switcher.ui.fontName = "Verdana"

hs.hotkey.bind(hyper, "o", function()
	hs.window.focusedWindow():moveToUnit(hs.layout.left50)
end)
hs.hotkey.bind(hyper, "p", function()
	hs.window.focusedWindow():moveToUnit(hs.layout.right50)
end)
hs.hotkey.bind(hyper, "k", function()
	hs.window.focusedWindow():moveToUnit(hs.layout.left70)
end)
hs.hotkey.bind(hyper, "l", function()
	hs.window.focusedWindow():moveToUnit(hs.layout.right30)
end)
hs.hotkey.bind(hyper, "m", function()
	hs.window.focusedWindow():moveToUnit(hs.layout.maximized)
end)

local table_invert = function(t)
	local s = {}
	for k, v in pairs(t) do
		s[v] = k
	end
	return s
end

local switchToSpace = function(sp)
	local main = hs.screen.mainScreen():getUUID()
	local layout = hs.spaces.allSpaces()[main]
	if layout[sp] == hs.spaces.focusedSpace() and lastSpace ~= nil then
		sp = lastSpace
	end
	local invert_layout = table_invert(layout)
	lastSpace = invert_layout[hs.spaces.activeSpaceOnScreen(main)]
	hs.spaces.gotoSpace(layout[sp])
end

hs.hotkey.bind(ctrl, "1", function()
	switchToSpace(1)
end)
hs.hotkey.bind(ctrl, "2", function()
	switchToSpace(2)
end)
hs.hotkey.bind(ctrl, "3", function()
	switchToSpace(3)
end)
hs.hotkey.bind(ctrl, "4", function()
	switchToSpace(4)
end)
hs.hotkey.bind(ctrl, "5", function()
	switchToSpace(5)
end)
hs.hotkey.bind(ctrl, "6", function()
	switchToSpace(6)
end)
hs.hotkey.bind(ctrl, "7", function()
	switchToSpace(7)
end)
hs.hotkey.bind(ctrl, "8", function()
	switchToSpace(8)
end)

local moveWindowToSpace = function(sp)
	local win = hs.window.focusedWindow() -- current window
	local uuid = hs.screen.mainScreen():getUUID() -- uuid for current screen
	local spaceID = hs.spaces.allSpaces()[uuid][sp] -- internal index for sp
	hs.spaces.moveWindowToSpace(win:id(), spaceID) -- move window to new space
	hs.spaces.gotoSpace(spaceID) -- follow window to new space
	hs.notify.new({ title = "Spaces", informativeText = "Window moved to Space #" .. sp }):send()
end

hs.hotkey.bind(ctrl_shift, "1", function()
	moveWindowToSpace(1)
end)
hs.hotkey.bind(ctrl_shift, "2", function()
	moveWindowToSpace(2)
end)
hs.hotkey.bind(ctrl_shift, "3", function()
	moveWindowToSpace(3)
end)
hs.hotkey.bind(ctrl_shift, "4", function()
	moveWindowToSpace(4)
end)
hs.hotkey.bind(ctrl_shift, "5", function()
	moveWindowToSpace(5)
end)
hs.hotkey.bind(ctrl_shift, "6", function()
	moveWindowToSpace(6)
end)
hs.hotkey.bind(ctrl_shift, "7", function()
	moveWindowToSpace(7)
end)
hs.hotkey.bind(ctrl_shift, "8", function()
	moveWindowToSpace(8)
end)

hs.hotkey.bind(cmd, "left", function()
	hs.window.focusedWindow():focusWindowWest()
end)
hs.hotkey.bind(cmd, "right", function()
	hs.window.focusedWindow():focusWindowEast()
end)
hs.hotkey.bind(cmd, "up", function()
	hs.window.focusedWindow():focusWindowNorth()
end)
hs.hotkey.bind(cmd, "down", function()
	hs.window.focusedWindow():focusWindowSouth()
end)

local switcher_space = hs.window.switcher.new(
	hs.window.filter.new({ override = { fullscreen = false } }):setCurrentSpace(true):setDefaultFilter({})
) -- include minimized/hidden windows, current Space only
-- bind to hotkeys; WARNING: at least one modifier key is required!
hs.hotkey.bind("alt", "tab", function()
	switcher_space:next()
end)
hs.hotkey.bind("alt-shift", "tab", function()
	switcher_space:previous()
end)

-- Spaces
--local allSpaces = hs.spaces.allSpaces()[hs.screen.mainScreen()]
--local spacesCount = #allSpaces

-- infinitely cycle through spaces using ctrl+left/right to trigger ctrl+[1..n]
local spacesEventtap = hs.eventtap
	.new({ hs.eventtap.event.types.keyDown }, function(o)
		local keyCode = o:getKeyCode()
		local modifiers = o:getFlags()

		-- logger.i(keyCode, hs.inspect(modifiers))

		-- check if correct key code
		if keyCode ~= 123 and keyCode ~= 124 then
			return
		end
		if not modifiers[ctrl] then
			return
		end

		-- check if no other modifiers where pressed
		local passed = hs.fnutils.every(modifiers, function(_, modifier)
			return hs.fnutils.contains(ctrl, modifier)
		end)

		if not passed then
			return
		end

		-- switch spaces
		local currentSpace = hs.spaces.focusedSpace()
		local nextSpace

		-- left arrow
		if keyCode == 123 then
			nextSpace = currentSpace ~= 1 and currentSpace - 1 -- or spacesCount
		-- right arrow
		elseif keyCode == 124 then
			nextSpace = currentSpace ~= spacesCount and currentSpace + 1 or 1
		end

		hs.eventtap.keyStroke({ ctrl }, string.format("%d", nextSpace))

		-- stop propagation
		return true
	end)
	:start()

hs.hotkey.bind(hyper, "y", function()
	-- Get the focused window, its window frame dimensions, its screen frame dimensions,
	-- and the next screen's frame dimensions.
	local focusedWindow = hs.window.focusedWindow()
	local focusedScreenFrame = focusedWindow:screen():frame()
	local nextScreenFrame = focusedWindow:screen():next():frame()
	local windowFrame = focusedWindow:frame()

	-- Calculate the coordinates of the window frame in the next screen and retain aspect ratio
	windowFrame.x = (
		(((windowFrame.x - focusedScreenFrame.x) / focusedScreenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x
	)
	windowFrame.y = (
		(((windowFrame.y - focusedScreenFrame.y) / focusedScreenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y
	)
	windowFrame.h = ((windowFrame.h / focusedScreenFrame.h) * nextScreenFrame.h)
	windowFrame.w = ((windowFrame.w / focusedScreenFrame.w) * nextScreenFrame.w)

	-- Set the focused window's new frame dimensions
	focusedWindow:setFrame(windowFrame)
end)
