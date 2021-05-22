

local useents = {
	["prop_door_rotating"] = "You open/close the door.",
	["func_door"] = "You open/close the gate.",
	["func_door_rotating"] = "You open/close the door.",
	["class C_BaseEntity"] = "You execute this thing's main purpose.",
	["prop_vehicle_crane"] = "You get in the crane.",
	["prop_vehicle_prisoner_pod"] = "You sit on the chair.",
	["prop_vehicle_airboat"] = "You get in the airboat.",
	["prop_vehicle_jeep"] = "You get in the car.",
	["lua_npc_wander"] = "A wanderer NPC. Not much for a conversation.",
	["lua_npc"] = "Someone important. Don't hit them.",
	["win10_teleporter"] = "You open the Teleporter's menu.",
	
}

local players = {
	["NULL"] = "This is a bot. They're not much for conversation.",
}

local function UseShit(ply, bind, boolthing)
	local trace = LocalPlayer():GetEyeTrace()
	if bind == "+use" and trace.Fraction < 0.0024 then
		print(trace.Entity)
		if useents[trace.Entity:GetClass()] and not LocalPlayer():InVehicle() then
			local msg = string.format("(%s)",useents[trace.Entity:GetClass()])
			ut.say(msg,nil,nil,true,0.1)
		end
		if trace.Entity:GetClass() == "player" then
			print(trace.Entity:SteamID())
			if players[trace.Entity:SteamID()] then
				local msg = string.format("(%s)",players[trace.Entity:SteamID()])
				ut.say(msg,nil,nil,true,0.1)
			else
				ut.say("Someone you don't know...",nil,nil,true,0.1)
			end
		end
	end
end

hook.Add("PlayerBindPress","UnderTextUse",UseShit)