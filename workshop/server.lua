local event = require("event")
local component = require("component")
local sides = require("sides")

local args = {...}
local numUsers = args[1]

if numUsers == nil then
	print("Please pass number of numUsers as argument. Program terminated.")
	goto quit
else
	print("Starting server program for " .. numUsers .. " numUsers..")
end

local running = true
local msgRed = {}
local msgBlue = {}

component.modem.open(123)

function handleMessages(msgTable, rAddr, msg)
	for addr, color in pairs(msgTable) do
		if addr != rAddr and msg != color then
			table.insert(msgTable, {[rAddr] = color})
		end
	end
end

function handleEvent(eventID, lAddr, rAddr, port, d, msg)
	if msg == "rood" then
		handleMessages(msgRed, rAddr, msg)

		-- move to red
		if #msgRed == numUsers then
			component.redstone.setOutput(sides.back, 15)
		end
	elseif msg == "blauw" then
		handleMessages(msgBlue, rAddr, msg)

		-- move to blue
		if #msgBlue == numUsers then
			component.redstone.setOutput(sides.back, 0)
		end
	end
end

while running do 
	handleEvent(event.pull("modem"))
end

::quit::
