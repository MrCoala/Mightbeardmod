local assert = GLOBAL.assert
local require = GLOBAL.require
local json = GLOBAL.json

-- Get the IO library for files
io = require "io"
os = require "os"


local protectedList = {
	"firesuppressor",
	"icebox",
	"dragonflychest",
	"treasurechest",
	"cookpot",
	"meatrack"
}

function isProtected(prefab)
	local match = 0
	for _, ele in ipairs(protectedList) do
		if ele == prefab then
			match = match + 1
			break
		end
	end
	return match
end

local function printTable(tb)	
	for k,v in pairs(tb) do
		if type(v) == "table" then 
			print("table: "..tostring(k))
		else 
			print(tostring(k)..","..tostring(v))
		end
	end	
end

local function writeLog(text)
	local world_age = GLOBAL.TheWorld.components.worldstate.data.cycles
	text = "[ALERT AT DAY: " .. world_age .. "] - " .. text
	print( text )
	local file = io.open("mightybeard.txt", "r")
	if file ~= nil then
		text = file:read("*a")
		file:close()
	end
	text = text .. "\n"
	
	file = io.open("mightybeard.txt", "w")
	file:write(text)
	file:close()
end

local function say(user, say_string, time)
	print(user.name .. ": " .. say_string)
	user:DoTaskInTime(0, function()
		user.components.talker:Say(say_string, time)
	end)
end


local old_ACTION_HAMMER = GLOBAL.ACTIONS.HAMMER.fn
GLOBAL.ACTIONS.HAMMER.fn = function(act)
	
	if act.target.prefab and isProtected(act.target.prefab) then
		local log = "-> " .. tostring(act.doer.name) .. " hammered the " .. tostring(act.target.prefab)
		writeLog( log )
	end
	
	return old_ACTION_HAMMER(act)
	
end

