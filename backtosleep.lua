--using Kitanoi draw function / menu snippet from discord #lua-help
--Rinn#4747
--v0.0.13

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
							"mbgridania",
							"mbuldah",
							"fcgridania",
							"fculdah",
							"mbishgard",
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
			["New Gridania"] = 133,
			["Mizzenmast"] = 177,
			["Limsa Lominsa Upper Deck"] = 128,
			["Limsa Lominsa Lower Deck"] = 129,
			["The Hourglass"] = 178,
			["Steps of Nald"] = 130,
			["Steps of Thal"] = 131,
			["Cloudnine"] = 429,
			["Foundation"] = 418,
			["The Pillars"] = 419,
			["Bokairo Inn"] = 629,
			["Kugane"] = 628,
			["The Pendants"] = 843,
			["Crystarium"] = 819,
}

backtosleep.pos.aetheryteID = {
			["Gridania"] = {id = 2, tpradius = 7},
			["Limsa"] = {id = 8, tpradius = 8},
			["Ul'dah"] = {id = 9, tpradius = 4},
			["Ishgard"] = {id = 70, tpradius = 8},
			["Kugane"] = {id = 111, tpradius = 8},
			["Crystarium"] = {id = 133, tpradius = 9},
}

backtosleep.pos.loc = {
			["Limsa Aetheryte"] = {x = -84.03, y= 20.77, z= 0.02, radius = 20 },
			["Limsa FC Chest Area"] = {x=-201.49,y=15.98,z=50.6, radius = 25},
			["Limsa FC Chest Stop"] = {x=-199.58,y=16.00,z=57.51, radius = 8},
			["Gridania Aetheryte"] =  { x = 32.979545593262, y = 2.2000007629395, z = 29.989479064941, radius = 11},
			["Gridania FC Chest Area"] = { x = 118.16472625732, y = 10.615682601929, z = -99.592720031738, radius = 25},
			["Gridania FC Chest Stop"] =  { x = 134.22993469238, y = 13.4781665802, z = -89.669204711914, radius = 4},
			["Gridania MB Area"] =  { x = 129.64942932129, y = 11.566942214966, z = -101.5057220459, radius = 36},
			["Gridania MB Stop"] =  { x = 160.85282897949, y = 15.5, z = -92.423233032227, radius = 3},
			["Limsa MB Area"] = {x=-217.75,y=16.00,z=47.32, radius = 10},
			["Limsa MB Stop"] = {x=-224.28,y=16.00,z=46.66, radius = 4},
			["Ul'dah Aetheryte"] = {x=-144.41030883789, y = -3.1548881530762, z = -169.6149597168, radius = 10},
			["Ul'dah Inn Area"] = {x=39.32,y=8.00,z=-98.18, radius= 40},
			["Ul'dah FC Chest Area"] = { x = 131.24674987793, y = 4, z = -35.229454040527, radius = 9},
			["Ul'dah FC Chest Stop"] =  { x = 129.47009277344, y = 4, z = -39.51485824585, radius = 3},
			["Ul'dah MB Area"] =  { x = 137.97302246094, y = 4.0495562553406, z = -33.074047088623, radius = 12},
			["Ul'dah MB Stop"] =  { x = 146.75076293945, y = 4, z = -34.977733612061, radius = 3},
			["Ishgard Aetheryte"] = {x=-63.98,y=11.15,z=43.99, radius = 15},
			["Ishgard Inn Area"] = {x=66.40,y=23.98,z=18.08, radius = 40},
			["Ishgard MB Area"] = { x = -144.51309204102, y = -12.534912109375, z = -28.21305847168, radius = 20},
			["Ishgard MB Stop"] = { x = -154.26528930664, y = -12.534914970398, z = -38.316753387451, radius = 3},
			["Kugane Aetheryte"] = {x=47.5,y=8.44,z=-37.31, radius = 15},
			["Kugane Inn Area"] = {x=-84.73,y=18.05,z=-181.11, radius = 25},
			["Kugane Leves Area"] = {x=34.8,y=3,z=-60.91, radius = 40},
			["Kugane Leves Stop"] = {x=21.03,y=0.00,z=-76.93, radius = 4},
			["Kugane MB Area"] = {x=12.28,y=4.00,z=60.91, radius = 25},
			["Kugane MB Stop"] = {x=2.47,y=4.00,z=51.23, radius = 4},
			["Crystarium Aetheryte"] = {x=-65.02,y=4.53,z=0.02, radius = 15},
			["Crystarium Inn Area"] = {x=52.74,y=1.71,z=232.94, radius = 25},
			["Crystarium Leves Area"] = {x=-61.98,y=20.00,z=-138.94, radius = 45},
			["Crystarium Leves Stop"] = {x=-72.35,y=20.00,z=-111.34, radius = 4},

}

backtosleep.pos.innkeeper = {
			["Gridania"] = {x=25.56 , y=-8 , z=97.94 , contentID =1000102 },
			["Limsa"] = {x=12.83 , y=40 , z=11.66 , contentID =1000974 },
			["Ul'dah"] = {x=29.06 , y=7.00 , z=-80.31 , contentID =1001976 },
			["Ishgard"] = {x=84.83 , y=15.09 , z=33.61 , contentID =1011193 },
			["Kugane"] = {x=-85.85 , y=19.00 , z=-198.99 , contentID =1018981 },
			["Crystarium"] = {x=62.71 , y=1.72 , z=247.85 , contentID =1027231 },
}


local function iAmOnMap(string)
	if Player.localmapid == backtosleep.pos.maps[string] then
		return true
	else
		return false
	end
end

local function iAmOnLocRange(string)
	local lx = backtosleep.pos.loc[string].x
	local ly = backtosleep.pos.loc[string].y
	local lz = backtosleep.pos.loc[string].z
	local lr = backtosleep.pos.loc[string].radius

	if math.distance3d(Player.pos,{x= lx,y= ly ,z= lz}) <= lr then
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
					guitogglebutton("mbgridania","Marketboard")
				GUI:SameLine()
					guitogglebutton("fcgridania","FC Chest")
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
					guitogglebutton("mbuldah","Marketboard")
				GUI:SameLine()
					guitogglebutton("fculdah","FC Chest")
				GUI:SameLine()
				GUI:NewLine()
					guitogglebutton("cloudnine","Ishgard")
				GUI:SameLine()
					guitogglebutton("mbishgard","MarketBoard")
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
			Player:Teleport(backtosleep.pos.aetheryteID[string].id)
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

local function randomMoveTo(location,min,max)
	local posx = backtosleep.pos.loc[location].x
	local posy = backtosleep.pos.loc[location].y
	local posz = backtosleep.pos.loc[location].z
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


-- local function cityBigAetheryteTravel(posx,posy,posz,deviation,aetheryteContentID,querystring)
	-- if not (math.distance3d(Player.pos,{x= posx,y= posy, z= posz})<= deviation) then
		-- canMoveTo(posx,posy,posz)
	-- else
		-- stopIfMoving()
		-- bigAetheryteInteract(aetheryteContentID,querystring)
	-- end

-- end


local function cityBigAetheryteTravel(aetherytelocation,aetheryteid,aethernetquery)
--posx,posy,posz,deviation,aetheryteContentID,querystring
local posx = backtosleep.pos.loc[aetherytelocation].x
local posy = backtosleep.pos.loc[aetherytelocation].y
local posz = backtosleep.pos.loc[aetherytelocation].z
local deviation = backtosleep.pos.aetheryteID[aetheryteid].tpradius
local aetheryteContentID = backtosleep.pos.aetheryteID[aetheryteid].id

	if not (math.distance3d(Player.pos,{x= posx,y= posy, z= posz})<= deviation) then
		canMoveTo(posx,posy,posz)
	else
		stopIfMoving()
		bigAetheryteInteract(aetheryteContentID,aethernetquery)
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


function innGuyTravel(string)
	local posx = backtosleep.pos.innkeeper[string].x
	local posy = backtosleep.pos.innkeeper[string].y
	local posz = backtosleep.pos.innkeeper[string].z
	local content = backtosleep.pos.innkeeper[string].contentID
	if not (math.distance3d(Player.pos,{x=posx,y=posy,z=posz})<=1) then
		canMoveTo(posx,posy,posz)
	else
		innGuyInteract(content)
	end
end


function backtosleep.OnUpdateHandler( Event, ticks )	
--ROOST
	if backtosleep.runningroost then
		if iAmOnMap("The Roost")then
			stopRunning()
		elseif not iAmOnMap("Old Gridania") then
			teleportTo("Gridania")		
		elseif iAmOnMap("Old Gridania") then
			innGuyTravel("Gridania")
		end
	end
--MIZZENMAST	
	if backtosleep.runningmizzen then
		if iAmOnMap("Mizzenmast") then
			stopRunning()
		elseif not iAmOnMap("Limsa Lominsa Upper Deck") and not iAmOnMap("Limsa Lominsa Lower Deck") then
			teleportTo("Limsa")
		elseif iAmOnMap("Limsa Lominsa Lower Deck") then
			cityBigAetheryteTravel("Limsa Aetheryte","Limsa","The Aftcastle.")
		elseif iAmOnMap("Limsa Lominsa Upper Deck") then
			innGuyTravel("Limsa")
		end		
	end
--HOURGLASS	
	if backtosleep.runninghourglass then
		if iAmOnMap("The Hourglass") then
			stopRunning()
		elseif not iAmOnMap("Steps of Nald") then
			teleportTo("Ul'dah")
		elseif iAmOnMap("Steps of Nald") then
			if  iAmOnLocRange("Ul'dah Aetheryte") then
				cityBigAetheryteTravel("Ul'dah Aetheryte","Ul'dah","Adventurers' Guild.")
			elseif iAmOnLocRange("Ul'dah Inn Area") then
				innGuyTravel("Ul'dah")				
			else
				teleportTo("Ul'dah")
			end
		end		
	end
--CloudNine
	if backtosleep.runningcloudnine then
		if iAmOnMap("Cloudnine") then
			stopRunning()
		elseif not iAmOnMap("Foundation") then
			teleportTo("Ishgard")
		elseif iAmOnMap("Foundation") then
			if iAmOnLocRange("Ishgard Aetheryte") then
				cityBigAetheryteTravel("Ishgard Aetheryte","Ishgard","The Forgotten Knight.")
			elseif iAmOnLocRange("Ishgard Inn Area") then
				innGuyTravel("Ishgard")												
			else
				teleportTo("Ishgard")
			end
		end		
	end
--BokairoInn
	if backtosleep.runningbokairoinn then
		if iAmOnMap("Bokairo Inn") then
			stopRunning()
		elseif not iAmOnMap("Kugane") then
			teleportTo("Kugane")
		elseif iAmOnMap("Kugane") then
			if iAmOnLocRange("Kugane Aetheryte") then
				cityBigAetheryteTravel("Kugane Aetheryte","Kugane","Bokairo Inn.")
			elseif iAmOnLocRange("Kugane Inn Area") then
				innGuyTravel("Kugane")												
			else
				teleportTo("Kugane")
			end
		end		
	end
--ThePendants	
	if backtosleep.runningthependants then
		if iAmOnMap("The Pendants") then
			stopRunning()
		elseif not iAmOnMap("Crystarium") then
			teleportTo("Crystarium")
		elseif iAmOnMap("Crystarium") then
			if iAmOnLocRange("Crystarium Aetheryte") then
				cityBigAetheryteTravel("Crystarium Aetheryte","Crystarium","The Pendants.")
			elseif iAmOnLocRange("Crystarium Inn Area") then
				innGuyTravel("Crystarium")												
			else
				teleportTo("Crystarium")
			end
		end		
	end
--FC Chest Limsa
	if backtosleep.runningfclimsa then
		if iAmOnMap("Limsa Lominsa Lower Deck") and iAmOnLocRange("Limsa FC Chest Stop") then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		elseif not iAmOnMap("Limsa Lominsa Lower Deck") then
			teleportTo("Limsa")
		elseif iAmOnMap("Limsa Lominsa Lower Deck") then
			--if math.distance3d(Player.pos,{x=-84.03,y=20.77,z=0.02})<=20 then
			if iAmOnLocRange("Limsa Aetheryte") then
				cityBigAetheryteTravel("Limsa Aetheryte","Limsa","Hawkers' Alley.")
			elseif iAmOnLocRange("Limsa FC Chest Area") then
				randomMoveTo("Limsa FC Chest Stop",0,6)				
			else
				teleportTo("Limsa")
			end
		end		
	end
--Central Aetheryte Limsa
	if backtosleep.runningcentrallimsa then
		if iAmOnLocRange("Limsa Aetheryte") then
			cityBigAetheryteTeleport(-84.03,20.77,0.02,6)
		else
			teleportTo("Limsa")
		end
				
	end
--MB Limsa
	if backtosleep.runningmblimsa then
		--map and range where it ends
		if iAmOnMap("Limsa Lominsa Lower Deck") and iAmOnLocRange("Limsa MB Stop") then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not iAmOnMap("Limsa Lominsa Lower Deck") then
			teleportTo("Limsa")
		--if on map but not objective...
		elseif iAmOnMap("Limsa Lominsa Lower Deck") then
			--if around aetheryte interact and aetheryte to hawkers' Alley
			if iAmOnLocRange("Limsa Aetheryte") then
				cityBigAetheryteTravel("Limsa Aetheryte","Limsa","Hawkers' Alley.")
			--if somewhere midway between aetheryte Hawkers' Alley and objective 		
			elseif iAmOnLocRange("Limsa MB Area") then
				--random move to max radius < range where it ends (same pos as where it ends)
				randomMoveTo("Limsa MB Stop",0,3)				
			else
				teleportTo("Limsa")
			end
		end		
	end
--Leve Kugane
	if backtosleep.runninglevekugane then
		--map and range where it ends
		if iAmOnMap("Kugane") and iAmOnLocRange("Kugane Leves Stop") then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not iAmOnMap("Kugane") then
			teleportTo("Kugane")
		--if on map but not objective...
		elseif iAmOnMap("Kugane") then
			--if somewhere midway between aetheryte and objective 		
			if iAmOnLocRange("Kugane Leves Area") then
				--random move to max radius < range where it ends (same pos as where it ends)
				randomMoveTo("Kugane Leves Stop",0,3)				
			else
				teleportTo("Kugane")
			end
		end		
	end
--MB Kugane
	if backtosleep.runningmbkugane then
		--map and range where it ends
		if iAmOnMap("Kugane") and iAmOnLocRange("Kugane MB Stop") then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not iAmOnMap("Kugane") then
			teleportTo("Kugane")
		--if on map but not objective...
		elseif iAmOnMap("Kugane") then
			--if around aetheryte interact and aetheryte to hawkers' Alley
			if iAmOnLocRange("Kugane Aetheryte") then
				cityBigAetheryteTravel("Kugane Aetheryte","Kugane","Kogane Dori Markets.")
			--if somewhere midway between aetheryte and objective 		
			elseif iAmOnLocRange("Kugane MB Area") then
				--random move to max radius < range where it ends (same pos as where it ends)
				if TimeSince(backtosleepmovenow) > 10000 then
					randomMoveTo("Kugane MB Stop",0,3)				
				end
			else
				if iAmOnLocRange("Kugane Leves Area") then
					cityBigAetheryteTravel("Kugane Aetheryte","Kugane","Kogane Dori Markets.")
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
		if iAmOnMap("Crystarium") and iAmOnLocRange("Crystarium Leves Stop") then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not iAmOnMap("Crystarium") then
			teleportTo("Crystarium")
		--if on map but not objective...
		elseif iAmOnMap("Crystarium") then
			--if around aetheryte interact and aetheryte to hawkers' Alley
			if iAmOnLocRange("Crystarium Aetheryte") then
				cityBigAetheryteTravel("Crystarium Aetheryte","Crystarium","The Crystalline Mean.")
			--if somewhere midway between aetheryte and objective 		
			elseif iAmOnLocRange("Crystarium Leves Area") then
				--random move to max radius < range where it ends (same pos as where it ends)
				randomMoveTo("Crystarium Leves Stop",0,3)				
			else
				teleportTo("Crystarium")
			end
		end		
	end
--MB Gridania
	if backtosleep.runningmbgridania then
		--map and range where it ends
		if iAmOnMap("New Gridania") and iAmOnLocRange("Gridania MB Stop") then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not iAmOnMap("Old Gridania") and not iAmOnMap("New Gridania")  then
			teleportTo("Gridania")
		--if on map but not objective...
		elseif iAmOnMap("Old Gridania") then
			--if around aetheryte interact and aetheryte to hawkers' Alley
			if iAmOnLocRange("Gridania Aetheryte") then
				cityBigAetheryteTravel("Gridania Aetheryte","Gridania","Leatherworkers' Guild.") 						
			else
				teleportTo("Gridania")
			end
		elseif iAmOnMap("New Gridania") and iAmOnLocRange("Gridania MB Area") then
			randomMoveTo("Gridania MB Stop",0,2)
		else
			teleportTo("Gridania")
		end		
	end
--MB Ul'dah	
	if backtosleep.runningmbuldah then
		--map and range where it ends
		if iAmOnMap("Steps of Thal") and iAmOnLocRange("Ul'dah MB Stop") then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not iAmOnMap("Steps of Thal") and not iAmOnMap("Steps of Nald")  then
			teleportTo("Ul'dah")
		--if on map but not objective...
		elseif iAmOnMap("Steps of Nald") then
			--if around aetheryte interact and aetheryte to hawkers' Alley
			if iAmOnLocRange("Ul'dah Aetheryte") then
				cityBigAetheryteTravel("Ul'dah Aetheryte","Ul'dah","Sapphire Avenue Exchange.") 						
			else
				teleportTo("Ul'dah")
			end
		elseif iAmOnMap("Steps of Thal") and iAmOnLocRange("Ul'dah MB Area") then
			randomMoveTo("Ul'dah MB Stop",0,2)
		else
			teleportTo("Ul'dah")
		end		
	end
--FC Ul'dah	
	if backtosleep.runningfculdah then
		--map and range where it ends
		if iAmOnMap("Steps of Thal") and iAmOnLocRange("Ul'dah FC Chest Stop") then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not iAmOnMap("Steps of Thal") and not iAmOnMap("Steps of Nald")  then
			teleportTo("Ul'dah")
		--if on map but not objective...
		elseif iAmOnMap("Steps of Nald") then
			--if around aetheryte interact and aetheryte to hawkers' Alley
			if iAmOnLocRange("Ul'dah Aetheryte") then
				cityBigAetheryteTravel("Ul'dah Aetheryte","Ul'dah","Sapphire Avenue Exchange.") 						
			else
				teleportTo("Ul'dah")
			end
		elseif iAmOnMap("Steps of Thal") and iAmOnLocRange("Ul'dah FC Chest Area") then
			randomMoveTo("Ul'dah FC Chest Stop",0,2)
		else
			teleportTo("Ul'dah")
		end		
	end
--FC Gridania
	if backtosleep.runningfcgridania then
		--map and range where it ends
		if iAmOnMap("New Gridania") and iAmOnLocRange("Gridania FC Chest Stop") then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not iAmOnMap("Old Gridania") and not iAmOnMap("New Gridania")  then
			teleportTo("Gridania")
		--if on map but not objective...
		elseif iAmOnMap("Old Gridania") then
			--if around aetheryte interact and aetheryte to hawkers' Alley
			if iAmOnLocRange("Gridania Aetheryte") then
				cityBigAetheryteTravel("Gridania Aetheryte","Gridania","Leatherworkers' Guild.") 						
			else
				teleportTo("Gridania")
			end
		elseif iAmOnMap("New Gridania") and iAmOnLocRange("Gridania FC Chest Area") then
			randomMoveTo("Gridania FC Chest Stop",0,2)
		else
			teleportTo("Gridania")
		end		
	end
--MB Ishgard
	if backtosleep.runningmbishgard then
		--map and range where it ends
		if iAmOnMap("The Pillars") and iAmOnLocRange("Ishgard MB Stop") then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not iAmOnMap("Foundation") and not iAmOnMap("The Pillars")  then
			teleportTo("Ishgard")
		--if on map but not objective...
		elseif iAmOnMap("Foundation") then
			--if around aetheryte interact and aetheryte to hawkers' Alley
			if iAmOnLocRange("Ishgard Aetheryte") then
				cityBigAetheryteTravel("Ishgard Aetheryte","Ishgard","The Jeweled Crozier.") 						
			else
				teleportTo("Ishgard")
			end
		elseif iAmOnMap("The Pillars") and iAmOnLocRange("Ishgard MB Area") then
			randomMoveTo("Ishgard MB Stop",0,2)
		else
			teleportTo("Ishgard")
		end		
	end	
end

RegisterEventHandler("Gameloop.Update",backtosleep.OnUpdateHandler)
RegisterEventHandler("Module.Initalize",backtosleep.ModuleInit) 
RegisterEventHandler("Gameloop.Draw", backtosleep.Draw, "backtosleep Draw")
