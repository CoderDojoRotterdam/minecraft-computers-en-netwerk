local event = require("event")
local component = require("component")
local sides = require("sides")

local args = {...}
local numUsers = tonumber(args[1])

if numUsers == nil or numUsers == 0 then
	print("Please pass number of numUsers as argument. Program terminated.")
	goto quit
else
	print("Starting server program for " .. numUsers .. " numUsers..")
end

local running = true
local msgRed = {}
local numRedMsg = 0
local msgBlue = {}
local numBlueMsg = 0

component.modem.open(123)

function handleEvent(eventID, lAddr, rAddr, port, d, msg)
	if msg == "rood" then
		-- count messages of unique users
		if numRedMsg == 0 then
			msgRed[rAddr] = msg
			numRedMsg = numRedMsg + 1
		else
			for addr, message in pairs(msgRed) do
				if addr ~= rAddr and msg ~= message then
					msgRed[rAddr] = msg
					numRedMsg = numRedMsg + 1
				end
			end
		end

		-- move to red
		if numRedMsg == numUsers then
			print("Moving to red")
			component.redstone.setOutput(sides.back, 15)
		end
	elseif msg == "blauw" then
		-- count messages of unique users
		if numBlueMsg == 0 then
			msgBlue[rAddr] = msg
			numBlueMsg = numBlueMsg + 1
		else
			for addr, message in pairs(msgBlue) do
				if addr ~= rAddr and msg ~= message then
					msgBlue[rAddr] = msg
					numBlueMsg = numBlueMsg + 1
				end
			end
		end

		-- move to blue
		if numBlueMsg == numUsers then
			print("Moving to blue")
			component.redstone.setOutput(sides.back, 0)
		end
	end
end

while running do 
	handleEvent(event.pull("modem"))
end

::quit::
