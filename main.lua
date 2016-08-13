local bonbonbearThermometer = require "plugin.bonbonbearThermometer"
local json = require "json"
local widget = require "widget"

--Table of found peripherals
local foundPeripherals = {}

--Set up text for displaying temperature
local temperatureText = display.newText( "Name: N/A| Temp: N/A C", display.contentWidth/2, display.contentHeight/8*6, native.systemFont, 15 )
local qrCodeText = display.newText( "QR Code: N/A", display.contentWidth/2, display.contentHeight/8*7, native.systemFont, 10 )


--Listener for handling callbacks
local function Listener(event)
	print(json.prettify(event))
	if event.type == "foundDevice" then
		if (table.indexOf( foundPeripherals, event.response ) == nil) then
			foundPeripherals[#foundPeripherals + 1] = event.response
		end
	elseif event.type == "obtainPeripheralData" then
		local temp = math.round(event.response.temperature * 100) * 0.01
		temperatureText.text = "Name: "..event.response.name .."| Temp: ".. temp .." C"
	elseif event.type == "obtainQRCode" then
		qrCodeText.text = "QR Code: "..event.response
	end
end

--Initialize the plugin
bonbonbearThermometer.init(Listener)


--connects to the first peripheral in the list of found peripherals
local function connectFirstPeripheral()
	print("Found peripherals: ".. json.prettify(foundPeripherals))
	if #foundPeripherals == 0 then
		print("No peripherals found so far")
	else
		bonbonbearThermometer.stopScanning()
		bonbonbearThermometer.connect(foundPeripherals[1].address)
	end
end


--gets the QR Code of a peripheral. Only availible on iOS
local function getQRCodeOfFirstPeripheral()
	if foundPeripherals == nil then
		print("No peripherals found so far")
	else
		bonbonbearThermometer.getTheQRCodeOfPeripheral(foundPeripherals[1].address)
	end
end


--Starts scanning for peripherals
local startScanningBtn = widget.newButton{ x = display.contentWidth/2, y = display.contentHeight/8, width = 200, height = 60, label = "startScanning", onRelease = function() bonbonbearThermometer.startScanning() end}

--Stops scanning
local stopScanningBtn = widget.newButton{ x = display.contentWidth/2, y = display.contentHeight/8*2, width = 200, height = 60, label = "stopScanning", onRelease = function() bonbonbearThermometer.stopScanning() end}

--Connect to a peripheral and start receiving temperature
local connectBtn = widget.newButton{ x = display.contentWidth/2, y = display.contentHeight/8*3, width = 200, height = 60, label = "connect", onRelease = function() connectFirstPeripheral() end}

--stop receiving temperature
local stopGetTemperatureBtn = widget.newButton{ x = display.contentWidth/2, y = display.contentHeight/8*4, width = 200, height = 60, label = "stopGetTemperature", onRelease = function() bonbonbearThermometer.stopGetTemperature() end}

--Get QR code (ios only)
local getTheQRCodeOfPeripheralBtn = widget.newButton{ x = display.contentWidth/2, y = display.contentHeight/8*5, width = 200, height = 60, label = "getTheQRCodeOfPeripheral", onRelease = function() getQRCodeOfFirstPeripheral() end}
