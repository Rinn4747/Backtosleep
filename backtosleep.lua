--using Kitanoi draw function / menu snippet from discord #lua-help
--Rinn#4747
--v0.0.11

backtosleep= { }
backtosleep.toggletable = {
							"roost",
							"mizzen",
							"hourglass",
							"cloudnine",
							"bokairoinn",
							"thependants",
							"fclimsa",
							"centrallimsa",
							"mblimsa",
							"mbkugane",
							"levekugane",
							"levecrystarium",
}


for _,toggle in pairs(backtosleep.toggletable) do
	backtosleep["running"..toggle] = false
end

backtosleep.running = false
backtosleep.lastticks = 0
backtosleep.GUI = {}
backtosleep.GUI.open = true
backtosleep.GUI.visible = true
backtosleep.GUI.hue = 125
backtosleep.now = 0
backtosleep.interact = 0
backtosleep.move = 0
backtosleep.mapid = 0
backtosleep.randompoint = {}
local backtosleepteleportnow = backtosleep.now
local backtosleepinteractnow = backtosleep.interact
local backtosleepmovenow = backtosleep.move
local backtosleepmapid = backtosleep.mapid
local backtosleeprandompoint = backtosleep.randompoint




backtosleep.pos = {}
backtosleep.pos.maps = {
			["The Roost"] = 179,
			["Old Gridania"] = 132,
			["Mizzenmast"] = 177,
			["Limsa Lominsa Upper Deck"] = 128,
			["Limsa Lominsa Lower Deck"] = 129,
			["The Hourglass"] = 178,
			["Steps of Nald"] = 130,
			["Cloudnine"] = 429,
			["Foundation"] = 418,
			["Bokairo Inn"] = 629,
			["Kugane"] = 628,
			["The Pendants"] = 843,
			["Crystarium"] = 819,
}

backtosleep.pos.aetheryteID = {
			["Gridania"] = 2,
			["Limsa"] = 8,
			["Ul'dah"] = 9,
			["Ishgard"] = 70,
			["Kugane"] = 111,
			["Crystarium"] = 133,
}

local function iamonmap(string)
	if Player.localmapid == backtosleep.pos.maps[string] then
		return true
	else
		return false
	end
end





function backtosleep.ModuleInit()
	backtosleep.CheckMenu()
end

local function stopIfMoving()
	if Player:IsMoving() then
		Player:Stop()
	end
end


local function stopRunning()
	for _,toggle in pairs(backtosleep.toggletable) do
		backtosleep["running"..toggle] = false
	end
	backtosleep.running = false
	stopIfMoving()
end

-----------------------Toggle Function
local function ToggleRun(string)
	if backtosleep["running"..string] then
		stopRunning()
	else
		stopRunning()
		backtosleep["running"..string] = true
		backtosleep.running = true
	end
end
---------------------------------------





function backtosleep.CheckMenu()
    local Status = false
    local Menu = ml_gui.ui_mgr.menu.components
    if table.valid(Menu) then
        for i,e in pairs(Menu) do
            if (e.members ~= nil) then
                for k,v in pairs(e.members) do
                    if (v.name ~= nil and v.name == "backtosleep") then
                        Status = true
                    end
                end
            end
        end
    end
    if (not Status) then
        ml_gui.ui_mgr:AddMember({ id = "FFXIVMINION##backtosleep", name = "backtosleep", texture = menuiconpath, test = "backtosleep"},"FFXIVMINION##MENU_HEADER")
        ml_gui.ui_mgr:AddSubMember({ id = "FFXIVMINION##backtosleep", name = "backtosleep", onClick = function() backtosleep.GUI.open = not backtosleep.GUI.open end, tooltip = "backtosleep", texture = iconpath},"FFXIVMINION##MENU_HEADER","FFXIVMINION##backtosleep")
    elseif (Status) then
        ml_gui.ui_mgr:AddSubMember({ id = "FFXIVMINION##backtosleep", name = "backtosleep", onClick = function() backtosleep.GUI.open = not backtosleep.GUI.open end, tooltip = "backtosleep", texture = iconpath},"FFXIVMINION##MENU_HEADER","FFXIVMINION##backtosleep")
    end
end

local function guitogglebutton(strbuttonfunction,strbuttoncaption)
	local buttonfunction = GUI:Button(strbuttoncaption,100,20)
	if GUI:IsItemClicked(buttonfunction) then 
		ToggleRun(strbuttonfunction)
	end
end



function backtosleep.Draw( event, ticks )
    local gamestate = GetGameState()
    if ( gamestate == FFXIV.GAMESTATE.INGAME ) then
        if ( backtosleep.GUI.open ) then
			GUI:SetNextWindowSize(400,75,GUI.SetCond_FirstUseEver) 			
            backtosleep.GUI.visible, backtosleep.GUI.open = GUI:Begin("backtosleep", backtosleep.GUI.open)
            if ( backtosleep.GUI.visible ) then
                backtosleep.Enable,changed = GUI:Checkbox("Enable##Enable", backtosleep.Enable)
				GUI:InputTextEditor([[##State]], "Currently running : "..tostring(backtosleep.running),400,50,(GUI.InputTextFlags_ReadOnly))
				GUI:SameLine()
				GUI:NewLine()
					guitogglebutton("roost","Gridania")
				GUI:SameLine()
				GUI:NewLine()
					guitogglebutton("mizzen","Limsa")
				GUI:SameLine()
					guitogglebutton("fclimsa","FC Chest")
				GUI:SameLine()
					guitogglebutton("centrallimsa","WorldHop")
				GUI:SameLine()
					guitogglebutton("mblimsa","MarketBoard")
				GUI:SameLine()				
				GUI:NewLine()
					guitogglebutton("hourglass","Ul'dah")
				GUI:SameLine()
				GUI:NewLine()
					guitogglebutton("cloudnine","Ishgard")
				GUI:SameLine()
				GUI:NewLine()
					guitogglebutton("bokairoinn","Kugane")
				GUI:SameLine()
					guitogglebutton("levekugane","Leves")
				GUI:SameLine()
					guitogglebutton("mbkugane","Marketboard")
				GUI:SameLine()
				GUI:NewLine()
					guitogglebutton("thependants","Crystarium")
				GUI:SameLine()
					guitogglebutton("levecrystarium","Leves")				
				GUI:NewLine()
					local stoprunning = GUI:Button("Stop",400,50)
					if GUI:IsItemClicked(stoprunning) then 
						stopRunning()
					end
				
            end
            GUI:End()
        end
    end
end




local function teleportTo(string)
	if TimeSince(backtosleepteleportnow) > 6000 then
		if not  MIsCasting() then
			Player:Teleport(backtosleep.pos.aetheryteID[string])
		end
		backtosleepteleportnow = Now()
		backtosleepmovenow = Now()
	end
end


local function bigAetheryteInteract(contentid,querystring)
	if MEntityList("contentid="..tostring(contentid)..",maxdistance=25") then
		if Player:GetTarget() == nil then
			if TimeSince(backtosleepinteractnow) > 1000 then
				Player:SetTarget(tonumber(tostring(next(MEntityList("contentid="..tostring(contentid)..",nearest")))))
				backtosleepinteractnow = Now()
			end
		end
		if not IsControlOpen("SelectString") and not (Player:GetTarget() == nil) then
			if TimeSince(backtosleepinteractnow) > 1000 then
				Player:Interact(Player:GetTarget().id)
				backtosleepinteractnow = Now()
			end
		end
		
			
		if IsControlOpen("SelectString") and GetControl("SelectString"):GetData()[0] == "Aethernet." then
			if TimeSince(backtosleepinteractnow) > 1000 then
				UseControlAction("SelectString", "SelectIndex", 0)
				backtosleepinteractnow = Now()
			end
		end
		if GetControl("SelectString") ~= nil then
			if GetControl("SelectString"):GetData() ~= nil then
				if IsControlOpen("SelectString") and GetControl("SelectString"):GetData()[#GetControl("SelectString"):GetData()] == "Quit." then
					if TimeSince(backtosleepinteractnow) > 1000 then
						local currentaetherytequery = GetControl("SelectString"):GetData()
						local currentindex = table.find(currentaetherytequery, querystring )
						UseControlAction("SelectString", "SelectIndex", currentindex)
						backtosleepinteractnow = Now() 
					end
				end
			end
		end
		
	end
end

					


local function innGuyInteract(contentid)
	if MEntityList("contentid="..tostring(contentid)..",maxdistance=25") then
		if not IsControlOpen("SelectString") then
			if TimeSince(backtosleepinteractnow) > 1000 then
				Player:SetTarget(tonumber(tostring(next(MEntityList("contentid="..tostring(contentid)..",nearest")))))
				Player:Interact(Player:GetTarget().id)
				backtosleepinteractnow = Now()
			end
		else
			if TimeSince(backtosleepinteractnow) > 2000 then
				if IsControlOpen("SelectString") and Player:GetTarget().contentid == contentid then
					UseControlAction("SelectString", "SelectIndex", 0)
					backtosleepinteractnow = Now() - 2000
				end
			end
		end
	end	
end



local function canMoveTo(posx,posy,posz)
	if TimeSince(backtosleepmovenow) > 8000 then
		if not MIsCasting() or not MIsLoading() then
			Player:MoveTo(posx,posy,posz)
		end
	end
end

local function randomMoveTo(posx,posy,posz,min,max)
	if not (backtosleepmapid == Player.localmapid) then
		backtosleeprandompoint = nil
		backtosleepmapid = Player.localmapid
	else
		if backtosleeprandompoint == nil then
			d("posx = "..tostring(posx).."          posy = "..tostring(posy).."             posz = "..tostring(posz).."          min = "..tostring(min).." max = "..tostring(max))
			backtosleeprandompoint = NavigationManager:GetRandomPointOnCircle(posx,posy,posz,min,max)
			if not (backtosleeprandompoint == nil) then
				d("randx: "..tostring(backtosleeprandompoint.x).." randy: "..tostring(backtosleeprandompoint.y).." randz: "..tostring(backtosleeprandompoint.z))
			end
		else
			canMoveTo(backtosleeprandompoint.x,backtosleeprandompoint.y,backtosleeprandompoint.z)
		end
	end
end



local function cityBigAetheryteTravel(posx,posy,posz,deviation,aetheryteContentID,querystring)
	if not (math.distance3d(Player.pos,{x= posx,y= posy, z= posz})<= deviation) then
		canMoveTo(posx,posy,posz)
	else
		stopIfMoving()
		bigAetheryteInteract(aetheryteContentID,querystring)
	end

end

local function cityBigAetheryteTeleport(posx,posy,posz,deviation)
	if not (math.distance3d(Player.pos,{x= posx,y= posy, z= posz})<= deviation) then
		canMoveTo(posx,posy,posz)
	else
		stopIfMoving()
		stopRunning()
	end

end


function innGuyTravel(posx,posy,posz,contentID)
	if not (math.distance3d(Player.pos,{x=posx,y=posy,z=posz})<=1) then
		canMoveTo(posx,posy,posz)
	else
		innGuyInteract(contentID)
	end
end


function backtosleep.OnUpdateHandler( Event, ticks )	
--ROOST
	if backtosleep.runningroost then
		if iamonmap("The Roost")then
			stopRunning()
		elseif not iamonmap("Old Gridania") then
			teleportTo("Gridania")		
		elseif iamonmap("Old Gridania") then
			innGuyTravel(25.56,-8.00,97.94,1000102)
		end
	end
--MIZZENMAST	
	if backtosleep.runningmizzen then
		if iamonmap("Mizzenmast") then
			stopRunning()
		elseif not iamonmap("Limsa Lominsa Upper Deck") and not iamonmap("Limsa Lominsa Lower Deck") then
			teleportTo("Limsa")
		elseif iamonmap("Limsa Lominsa Lower Deck") then
			cityBigAetheryteTravel(-84.03,20.77,0.02,8,8,"The Aftcastle.")
		elseif iamonmap("Limsa Lominsa Upper Deck") then
			innGuyTravel(12.83,40,11.66,1000974)
		end		
	end
--HOURGLASS	
	if backtosleep.runninghourglass then
		if iamonmap("The Hourglass") then
			stopRunning()
		elseif not iamonmap("Steps of Nald") then
			teleportTo("Ul'dah")
		elseif iamonmap("Steps of Nald") then
			if  math.distance3d(Player.pos,{x=-144.41030883789, y = -3.1548881530762, z = -169.6149597168}) <= 10 then
				cityBigAetheryteTravel(-144.41030883789,-3.1548881530762,-169.6149597168,4,9,"Adventurers' Guild.")
			elseif math.distance3d(Player.pos,{x=39.32,y=8.00,z=-98.18})<=40 then
				innGuyTravel(29.06,7.00,-80.31,1001976)				
			else
				teleportTo("Ul'dah")
			end
		end		
	end
--CloudNine
	if backtosleep.runningcloudnine then
		if iamonmap("Cloudnine") then
			stopRunning()
		elseif not iamonmap("Foundation") then
			teleportTo("Ishgard")
		elseif iamonmap("Foundation") then
			if math.distance3d(Player.pos,{x=-63.98,y=11.15,z=43.99})<=15 then
				cityBigAetheryteTravel(-63.98,11.15,43.99,8,70,"The Forgotten Knight.")
			elseif math.distance3d(Player.pos,{x=66.40,y=23.98,z=18.08})<=40 then
				innGuyTravel(84.83,15.09,33.61,1011193)												
			else
				teleportTo("Ishgard")
			end
		end		
	end
--BokairoInn
	if backtosleep.runningbokairoinn then
		if iamonmap("Bokairo Inn") then
			stopRunning()
		elseif not iamonmap("Kugane") then
			teleportTo("Kugane")
		elseif iamonmap("Kugane") then
			if math.distance3d(Player.pos,{x=47.5,y=8.44,z=-37.31})<=15 then
				cityBigAetheryteTravel(47.5,8.44,-37.31,8,111,"Bokairo Inn.")
			elseif math.distance3d(Player.pos,{x=-84.73,y=18.05,z=-181.11})<=25 then
				innGuyTravel(-85.85,19.00,-198.99,1018981)												
			else
				teleportTo("Kugane")
			end
		end		
	end
--ThePendants	
	if backtosleep.runningthependants then
		if iamonmap("The Pendants") then
			stopRunning()
		elseif not iamonmap("Crystarium") then
			teleportTo("Crystarium")
		elseif iamonmap("Crystarium") then
			if math.distance3d(Player.pos,{x=-65.02,y=4.53,z=0.02})<=15 then
				cityBigAetheryteTravel(-65.02,4.53,0.02,9,133,"The Pendants.")
			elseif math.distance3d(Player.pos,{x=52.74,y=1.71,z=232.94})<=25 then
				innGuyTravel(62.71,1.72,247.85,1027231)												
			else
				teleportTo("Crystarium")
			end
		end		
	end
--FC Chest Limsa
	if backtosleep.runningfclimsa then
		if iamonmap("Limsa Lominsa Lower Deck") and math.distance3d(Player.pos,{x=-199.58,y=16.00,z=57.51})<=8 then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		elseif not iamonmap("Limsa Lominsa Lower Deck") then
			teleportTo("Limsa")
		elseif iamonmap("Limsa Lominsa Lower Deck") then
			if math.distance3d(Player.pos,{x=-84.03,y=20.77,z=0.02})<=20 then
				cityBigAetheryteTravel(-84.03,20.77,0.02,8,8,"Hawkers' Alley.")
			elseif math.distance3d(Player.pos,{x=-201.49,y=15.98,z=50.6})<=25 then
				randomMoveTo(-199.58,16.00,57.51,0,6)				
			else
				teleportTo("Limsa")
			end
		end		
	end
--Central Aetheryte Limsa
	if backtosleep.runningcentrallimsa then
		if math.distance3d(Player.pos,{x=-84.03,y=20.77,z=0.02})<=20 then
			cityBigAetheryteTeleport(-84.03,20.77,0.02,6)
		else
			teleportTo("Limsa")
		end
				
	end
--MB Limsa
	if backtosleep.runningmblimsa then
		--map and range where it ends
		if iamonmap("Limsa Lominsa Lower Deck") and math.distance3d(Player.pos,{x=-224.28,y=16.00,z=46.66})<=4 then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not iamonmap("Limsa Lominsa Lower Deck") then
			teleportTo("Limsa")
		--if on map but not objective...
		elseif iamonmap("Limsa Lominsa Lower Deck") then
			--if around aetheryte interact and aetheryte to hawkers' Alley
			if math.distance3d(Player.pos,{x=-84.03,y=20.77,z=0.02})<=20 then
				cityBigAetheryteTravel(-84.03,20.77,0.02,8,8,"Hawkers' Alley.")
			--if somewhere midway between aetheryte Hawkers' Alley and objective 		
			elseif math.distance3d(Player.pos,{x=-217.75,y=16.00,z=47.32})<=10 then
				--random move to max radius < range where it ends (same pos as where it ends)
				randomMoveTo(-224.28,16.00,46.66,0,3)				
			else
				teleportTo("Limsa")
			end
		end		
	end
--Leve Kugane
	if backtosleep.runninglevekugane then
		--map and range where it ends
		if iamonmap("Kugane") and math.distance3d(Player.pos,{x=21.03,y=0.00,z=-76.93})<=4 then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not iamonmap("Kugane") then
			teleportTo("Kugane")
		--if on map but not objective...
		elseif iamonmap("Kugane") then
			--if somewhere midway between aetheryte and objective 		
			if math.distance3d(Player.pos,{x=34.8,y=3,z=-60.91})<=40 then
				--random move to max radius < range where it ends (same pos as where it ends)
				randomMoveTo(21.03,0.00,-76.93,0,3)				
			else
				teleportTo("Kugane")
			end
		end		
	end
--MB Kugane
	if backtosleep.runningmbkugane then
		--map and range where it ends
		if iamonmap("Kugane") and math.distance3d(Player.pos,{x=2.47,y=4.00,z=51.23})<=4 then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not iamonmap("Kugane") then
			teleportTo("Kugane")
		--if on map but not objective...
		elseif iamonmap("Kugane") then
			--if around aetheryte interact and aetheryte to hawkers' Alley
			if math.distance3d(Player.pos,{x=47.5,y=8.44,z=-37.31})<=15 then
				cityBigAetheryteTravel(47.5,8.44,-37.31,8,111,"Kogane Dori Markets.")
			--if somewhere midway between aetheryte and objective 		
			elseif math.distance3d(Player.pos,{x=12.28,y=4.00,z=60.91})<=25 then
				--random move to max radius < range where it ends (same pos as where it ends)
				if TimeSince(backtosleepmovenow) > 10000 then
					randomMoveTo(2.47,4.00,51.23,0,3)				
				end
			else
				if math.distance3d(Player.pos,{x=34.8,y=3,z=-60.91})<=40 then
					cityBigAetheryteTravel(47.5,8.44,-37.31,8,111,"Kogane Dori Markets.")
					backtosleepmovenow = Now()
				else
					teleportTo("Kugane")
				end
			end
		end		
	end
--Leve Crystarium
	if backtosleep.runninglevecrystarium then
		--map and range where it ends
		if iamonmap("Crystarium") and math.distance3d(Player.pos,{x=-72.35,y=20.00,z=-111.34})<=4 then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not iamonmap("Crystarium") then
			teleportTo("Crystarium")
		--if on map but not objective...
		elseif iamonmap("Crystarium") then
			--if around aetheryte interact and aetheryte to hawkers' Alley
			if math.distance3d(Player.pos,{x=-65.02,y=4.53,z=0.02})<=15 then
				cityBigAetheryteTravel(-65.02,4.53,0.02,9,133,"The Crystalline Mean.")
			--if somewhere midway between aetheryte and objective 		
			elseif math.distance3d(Player.pos,{x=-61.98,y=20.00,z=-138.94})<=45 then
				--random move to max radius < range where it ends (same pos as where it ends)
				randomMoveTo(-72.35,20.00,-111.34,0,3)				
			else
				teleportTo("Crystarium")
			end
		end		
	end

end

RegisterEventHandler("Gameloop.Update",backtosleep.OnUpdateHandler)
RegisterEventHandler("Module.Initalize",backtosleep.ModuleInit) 
RegisterEventHandler("Gameloop.Draw", backtosleep.Draw, "backtosleep Draw")
