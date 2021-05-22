//coc
if not ut then
	LocalPlayer():ChatPrint("You don't have UnderText working.")
else
	ut.say("IT'S WORKING",nil,nil,true)
end

local function ActionStuff(ply,txt)
	local found = string.match(txt,"%* %(.+%)")
	if found then
		local usethis = string.match(found,"%(.+%)")
		ut.say(usethis,nil,nil,true)
	end
end

hook.Add("OnPlayerChat","UndertaleActions",ActionStuff)

local oldnick = nil
local function textshitfuck(ply,txt)
	local nick = UndecorateNick(ply:Nick())
	local voice = nil
	if nick == UndecorateNick(LocalPlayer():Nick()) then
		voice = "asgore"
	else
		voice = nil
	end
	if nick ~= oldnick then
		ut.say(nick..": "..txt,voice,nil,true,0.5)
		oldnick = nick
	else
		ut.say("\n "..txt,voice,nil,false,0.1)
	end
	//local message = string.format(": %s",txt)
end

//hook.Add("OnPlayerChat","UTTextChat",textshitfuck)


hook.Add("ChatTextChanged","DoVoice",function(txt)
	if txt ~= "" then
		LocalPlayer():EmitSound(ut.voices["ownerless"],75,100,1,CHAN_STATIC)
	end
end)