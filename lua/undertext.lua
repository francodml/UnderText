function draw.OutlinedBox( x, y, w, h, thickness, clr )
	surface.SetDrawColor( clr )
	for i=0, thickness - 1 do
		surface.DrawOutlinedRect( x + i, y + i, w - i * 2, h - i * 2 )
	end
end

if ut and ut.ui then
	ut.ui:Remove()
end

ut = {}

ut.queue = {}

ut.font = {
	font = "Determination Mono",
	size=35,
	antialias = false
}

ut.separators = "[%.%,%:%?%!]"

ut.papyrusfont = {
	font="Papyrus",
	size=50,
	weight=900,
	antialias = false
}

ut.sansfont = {
	font="Comic Sans MS",
	size=40,
	antialias = false
}

surface.CreateFont("utsans",ut.sansfont)

surface.CreateFont("utpapyrus",ut.papyrusfont)

surface.CreateFont("ut",ut.font)

ut.UTFrame = {}

function ut.UTFrame:Paint(w,h)
	draw.RoundedBox(0,0,0,w,h,Color(0,0,0))
	draw.OutlinedBox(0,0,w,h,5,Color(255,255,255))
end

vgui.Register("UTFrame",ut.UTFrame,"DPanel")

ut.ui = vgui.Create("UTFrame")
ut.ui:SetSize(500,200)
ut.ui:Center()
ut.ui:Dock(BOTTOM)
ut.ui:DockMargin(350,0,350,30)
//ut.ui:MakePopup()

ut.ui.txt = vgui.Create("DLabel",ut.ui)
ut.ui.txt:Dock(FILL)
ut.ui.txt:DockMargin(10,15,0,0)
ut.ui.txt:SetFont("ut")
ut.ui.txt:SetText("* ")
ut.ui.txt:SetAutoStretchVertical(true)
ut.ui.txt:SetWrap(true)
ut.ui.txt:SetTextColor(color_white)

ut.ui.face = vgui.Create("EditablePanel",ut.ui)
ut.ui.face:Dock(LEFT)
ut.ui.face:DockMargin(5,5,-70,0)
ut.ui.face:SetWidth(ut.ui:GetTall())
function ut.ui.face:Paint(w,h)
	surface.SetDrawColor(Color(255,255,255,255))
	surface.SetMaterial(ut.currentface)
	surface.DrawTexturedRect(20,10,w/2,h/2)
	//surface.DrawRect(0,0,w,h)
end

ut.ui.face:Hide()

ut.ui:Hide()

ut.voices = {
	["generic"] = "underfight/generictext2.wav",
	["ownerless"] = "underfight/generictext.wav",
	["flowey"] = "underfight/voices/flowey.wav",
	["floweyang"] = "underfight/voices/floweyangry.wav",
	["asgore"] = "underfight/voices/asgore.wav",
	["papyrus"] = "underfight/voices/papyrus.wav",
	["sans"] = "underfight/voices/sans.wav",
	["toriel"] = "underfight/voices/toriel.wav",
	["undyne"] = "underfight/voices/undyne.wav",
}

ut.faces = {
	["sans"] = Material("faces/sans/sansidle.png"),
	["toriel"] = {
		Material("faces/toriel_talk/torieltalk_0.png"),
		Material("faces/toriel_talk/torieltalk_1.png"),
	},
	["sansblink"] = Material("faces/sans/sansblink.png"),
	["sanswink"] = Material("faces/sans/sanswink.png"),
	["sansang"] = Material("faces/sans/sansnoeyes.png"),
	["sansleft"] = Material("faces/sans/sansleft.png"),
	["asgore"] = {
		Material("faces/asgore/asgoretalk_0.png"),
		Material("faces/asgore/asgoretalk_1.png"),
	},
	["papyrus"] = {
		Material("faces/papyrus/papyrustalk_0.png"),
		Material("faces/papyrus/papyrustalk_1.png"),
	},
	["flowey"] = Material("faces/flowey/flowey.png"),
	["floweyang"] = Material("faces/flowey/floweyang.png"),
	["flowey_angry"] = Material("faces/flowey/flowey_angry.png"),
	["undyne"] = {
		Material("faces/undyne/undynetalk_0.png"),
		Material("faces/undyne/undynetalk_1.png"),
	},
}

ut.fonts = {
	["papyrus"] = "utpapyrus",
	["sans"] = "utsans",
}

function ut.setface(who)
	if istable(ut.faces[who]) then
		//print("animation frames")
		ut.ui.face:Show()
		local current = 1
		ut.currentface = ut.faces[who][current]
		timer.Create("utfaceanim",0.2,0,function()
			if ut.inuse then
				if current == #ut.faces[who] then
					current = 1
				end
				ut.currentface = ut.faces[who][current]
				current = current + 1
			else
				ut.currentface = ut.faces[who][1]
			end
		end)
	else
		//print("still face")
		if timer.Exists("utfaceanim") then
			timer.Destroy("utfaceanim")
		end
		ut.currentface = ut.faces[who]
		ut.ui.face:Show()
	end
end

function ut.animtext(txt,voice,clear,delay,specialface,callback)
	//if ut.inuse then return end
	//INTERNAL FUNCTION, NOT RECOMMENDED FOR USE
	ut.inuse = true
	ut.ui:Show()
	local lbl = ut.ui.txt
	if clear == true then lbl:SetText("* ") end
	if ut.faces[voice] then
		ut.setface(voice)
	else
		ut.ui.face:Hide()
	end
	local text = string.Explode("",txt)
	if voice and ut.fonts[voice] then
		ut.ui.txt:SetFont(ut.fonts[voice])
	else
		ut.ui.txt:SetFont("ut")
	end
	
	for k,v in pairs(text) do
		/*if text[(k-1)] == "," then
			delay = k/5*/
		if not delay then
			dlay = k/15
		else
			dlay = k/delay
		end
		timer.Simple(dlay,function() 
			lbl:SetText(lbl:GetText()..v)
			//lbl:SizeToContents()
			if v != " " then
				if voice then
					if voice == "none" then

					else
						LocalPlayer():EmitSound(ut.voices[voice],75,100,1,CHAN_STATIC)
					end
				else
					LocalPlayer():EmitSound(ut.voices["ownerless"],75,100,1,CHAN_STATIC)
				end
			end
			if k == 1 and specialface then
				ut.setface(specialface)
			end
			if k == #text then
				if callback then
					callback()
					ut.inuse = false
					if timer.Exists("utfaceanim") then
						timer.Destroy("utface")
					end
				else
					ut.inuse = false
					//timer.Simple(3,function() ut.ui:Hide() end)
				end
				if #ut.queue == 0 then
					timer.Create("uthideui",3,1, function() ut.ui:Hide() end)
				end
			end
		end)
	end
end

function ut.animtext2(txt,voice,delay,clear)
	//INTERNAL FUNCTION
	ut.animtext(txt,voice,clear,nil,delay)
end

ut.queue = {}

/*function ut.say(txt,tvoice,dly,clr,nwait,specialface,callback)
	local data = {
		text = txt,
		voice = tvoice,
		delay = dly,
		clear = clr,
		cb = callback,
		sf = specialface,
	}
	if ut.queue[1] then
		data.wait = nwait or 3
	else
		data.wait = nwait
	end
	if timer.Exists("uthideui") then
		timer.Destroy("uthideui")
	end
	table.insert(ut.queue,data)
end*/

function ut.say(txt,tvoice,dly,clr,nwait,specialface,callback)
	//New function, may not work.
	local function AddToQueue(txt,tvoice,dly,clr,nwait,specialface,callback)
		local data = {
			text = txt,
			voice = tvoice,
			delay = dly,
			clear = clr,
			cb = callback,
			sf = specialface,
		}
		if ut.queue[1] then
			data.wait = nwait or 3
		else
			data.wait = nwait
		end

		//return data
		table.insert(ut.queue,data)
	end
	if timer.Exists("uthideui") then
		timer.Destroy("uthideui")
	end
	if string.find(txt,ut.separators) then
		if string.find(txt,".+"..ut.separators) then
			txt = txt.." "
		end
		local splittxt = string.Explode(ut.separators,txt,true)
		local length = 0
		local wait = 0
		for k,v in pairs(splittxt) do
			if k == 1 then
				local usechar = txt[v:len()+1]
				length = v:len()+1
				AddToQueue(v..usechar,tvoice,dly,clr,nwait,specialface,callback)
			else
				local usechar = txt[length+(v:len())+1]
				length = length + v:len()+1
				if usechar == "." then
					wait = 0.5
				elseif usechar == "," then
					wait = 0.2
				elseif usechar == ":" then
					wait = 0.2
				elseif usechar == "?" then
					wait = 0.5
				elseif usechar == "!" then
					wait = 0.5
				end
				AddToQueue(v..usechar,tvoice,dly,false,wait,specialface,callback)
			end
		end
	else
		AddToQueue(txt,tvoice,dly,clr,nwait,specialface,callback)
	end
end

//PrintTable(queue)

function ut.thinkfunc()
	if ut.queue[1] then
		if ut.inuse then return end
		local text = ut.queue[1].text
		local delay = ut.queue[1].delay
		local voice = ut.queue[1].voice
		local clear = ut.queue[1].clear
		local wait = ut.queue[1].wait
		local callback = ut.queue[1].cb
		local specialface = ut.queue[1].sf
		if wait and not ut.inuse then
			if timer.Exists("utwait") then return end
			timer.Create("utwait",wait,1,function()
				if ut.inuse then return end
				ut.animtext(text,voice,clear,delay,specialface,callback)
				table.remove(ut.queue,1)
			end)
		else
			ut.animtext(text,voice,clear,delay,specialface,callback)
			table.remove(ut.queue,1)
		end
		if ut.ui.txt:GetTall() > 200 then
			ut.ui.txt:SetText("*")
		end
	end


end

hook.Add("Think","UTThink",ut.thinkfunc)

function ut.hookfunc(ply,txt,arg1,arg2,arg3,arg4)
	ut.say(arg1,arg2,arg3,true,arg4)
end

//aowl.AddCommand("utext",ut.hookfunc)

function ut.clearqueue()
	table.Empty(ut.queue)
end

ut.say("Undertext is ready to use!")

//hook.Add("OnPlayerChat", "utext", function(ply,txt) if ply == LocalPlayer() then aowl.SayCommand(ply,txt) end end)

