require("pomodoro")
require("usb")
require("utils")
require("wifi")
require("wm")
require("dots")

local ipc = require("hs.ipc")

-- Settings

hs.logger.defaultLogLevel = "debug"
hs.window.animationDuration = 0
hs.alert.defaultStyle.strokeColor = { white = 1, alpha = 0 }
hs.alert.defaultStyle.fillColor = { white = 0.05, alpha = 0.75 }
hs.alert.defaultStyle.radius = 10

-- Keybindings
local hyper = { "cmd", "alt", "ctrl", "shift" }
hs.hotkey.bind(hyper, "c", hs.toggleConsole)
hs.hotkey.bind(hyper, "r", function()
	hs.reload()
end)
hs.hotkey.bind(hyper, "n", function()
	hs.task.new("/usr/bin/open", nil, { os.getenv("HOME") }):start()
end)
hs.hotkey.bind(hyper, "t", function()
	hs.application.launchOrFocus("WezTerm")
end)
hs.hotkey.bind(hyper, "b", function()
	hs.application.launchOrFocus("Arc")
end)
hs.hotkey.bind(hyper, "s", function()
	hs.application.launchOrFocus("Slack")
end)

ipc.cliInstall()

-- Load SpoonInstall, so we can easily load our other Spoons
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true
spoon.SpoonInstall:andUse("EmmyLua")
spoon.SpoonInstall:andUse("Caffeine")

spoon.Caffeine:bindHotkeys({
	toggle = { { "control", "cmd" }, "z" },
})

spoon.Caffeine:start()
spoon.Caffeine:setState(true)

hs.notify
	.new({
		title = "Hammerspoon",
		informativeText = "Config loaded",
	})
	:send()
