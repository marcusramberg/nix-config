-- Callback function for USB device events
local usbWatcher = hs.usb.watcher.new(function(data)
	print("usbDeviceCallback: " .. hs.inspect(data))
	if data["productName"] == "Wireless Controller" and data["vendorName"] == "Sony Computer Entertainment" then
		local event = data["eventType"]
		if event == "added" then
			hs.application.launchOrFocus("RemotePlay")
			hs.itunes.pause()
		elseif event == "removed" then
			local app = hs.appfinder.appFromName("PS4 Remote Play")
			app:kill()
		end
	end
end)

usbWatcher:start()
