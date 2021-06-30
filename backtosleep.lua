--using Kitanoi draw function / menu snippet from discord #lua-help
--Rinn#4747
--v0.0.9

backtosleep= { }
backtosleep.runningroost = false
backtosleep.runningmizzen = false
backtosleep.runninghourglass = false
backtosleep.runningcloudnine = false
backtosleep.runningbokairoinn = false
backtosleep.runningthependants = false
backtosleep.runningfclimsa = false
backtosleep.runningcentrallimsa = false
backtosleep.runningmblimsa = false
backtosleep.runningmbkugane = false
backtosleep.runninglevekugane = false
backtosleep.runninglevecrystarium = false
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

function backtosleep.ModuleInit()
	backtosleep.CheckMenu()
end


function backtosleep.stopRunning()
	backtosleep.runningroost = false
	backtosleep.runningmizzen = false
	backtosleep.runninghourglass = false
	backtosleep.runningcloudnine = false
	backtosleep.runningbokairoinn = false
	backtosleep.runningthependants = false
	backtosleep.runningfclimsa = false
	backtosleep.runningcentrallimsa = false
	backtosleep.runningmblimsa = false
	backtosleep.runningmbkugane = false
	backtosleep.runninglevekugane = false
	backtosleep.runninglevecrystarium = false
	backtosleep.running = false
	backtosleep.stopIfMoving()
end


function backtosleep.ToggleRun(string)
	if backtosleep["running"..string] then
		backtosleep.stopRunning()
	else
		backtosleep.stopRunning()
		backtosleep["running"..string] = true
		backtosleep.running = true
	end
end

--Toggle Function 
function backtosleep.ToggleRunRoost()
	backtosleep.ToggleRun("roost")
end

function backtosleep.ToggleRunMizzen()
	backtosleep.ToggleRun("mizzen")
end

function backtosleep.ToggleRunHourglass()
	backtosleep.ToggleRun("hourglass")
end

function backtosleep.ToggleRunCloudNine()
	backtosleep.ToggleRun("cloudnine")
end

function backtosleep.ToggleRunBokairoInn()
	backtosleep.ToggleRun("bokairoinn")
end

function backtosleep.ToggleRunThePendants()
	backtosleep.ToggleRun("thependants")
end

function backtosleep.ToggleRunfclimsa()
	backtosleep.ToggleRun("fclimsa")
end

function backtosleep.ToggleRuncentrallimsa()
	backtosleep.ToggleRun("centrallimsa")
end

function backtosleep.ToggleRunmblimsa()
	backtosleep.ToggleRun("mblimsa")
end

function backtosleep.ToggleRunmbkugane()
	backtosleep.ToggleRun("mbkugane")
end

function backtosleep.ToggleRunlevekugane()
	backtosleep.ToggleRun("levekugane")
end

function backtosleep.ToggleRunlevecrystarium()
	backtosleep.ToggleRun("levecrystarium")
end





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
				local toggleroostsleep = GUI:Button("Gridania",100,20)
                if GUI:IsItemClicked(toggleroostsleep) then 
					backtosleep.ToggleRunRoost()
                end
				GUI:SameLine()
				GUI:NewLine()
				local togglemizzensleep = GUI:Button("Limsa",100,20)
                if GUI:IsItemClicked(togglemizzensleep) then 
					backtosleep.ToggleRunMizzen()
                end
				GUI:SameLine()
				local togglefclimsasleep = GUI:Button("FC Chest",100,20)
                if GUI:IsItemClicked(togglefclimsasleep) then 
					backtosleep.ToggleRunfclimsa()
                end
				GUI:SameLine()
				local togglecentrallimsasleep = GUI:Button("WorldHop",100,20)
                if GUI:IsItemClicked(togglecentrallimsasleep) then 
					backtosleep.ToggleRuncentrallimsa()
                end
				GUI:SameLine()
				local togglemblimsasleep = GUI:Button("Marketboard",100,20)
                if GUI:IsItemClicked(togglemblimsasleep) then 
					backtosleep.ToggleRunmblimsa()
                end					
				GUI:SameLine()				
				GUI:NewLine()
				local togglehourglasssleep = GUI:Button("Ul'dah",100,20)
                if GUI:IsItemClicked(togglehourglasssleep) then 
					backtosleep.ToggleRunHourglass()
                end
				GUI:SameLine()
				GUI:NewLine()
				local togglecloudninesleep = GUI:Button("Ishgard",100,20)
                if GUI:IsItemClicked(togglecloudninesleep) then 
					backtosleep.ToggleRunCloudNine()
                end
				GUI:SameLine()
				GUI:NewLine()
				local togglebokairoinn = GUI:Button("Kugane",100,20)
                if GUI:IsItemClicked(togglebokairoinn) then 
					backtosleep.ToggleRunBokairoInn()
                end
				GUI:SameLine()
				local togglelevekugane = GUI:Button("Leves",100,20)
                if GUI:IsItemClicked(togglelevekugane) then 
					backtosleep.ToggleRunlevekugane()
                end
				GUI:SameLine()
				local togglembkugane = GUI:Button("Marketboard",100,20)
                if GUI:IsItemClicked(togglembkugane) then 
					backtosleep.ToggleRunmbkugane()
                end
				GUI:SameLine()
				GUI:NewLine()
				local togglethependants = GUI:Button("Crystarium",100,20)
                if GUI:IsItemClicked(togglethependants) then 
					backtosleep.ToggleRunThePendants()
                end
				GUI:SameLine()
				local togglelevecrystarium = GUI:Button("Leves",100,20)
                if GUI:IsItemClicked(togglelevecrystarium) then 
					backtosleep.ToggleRunlevecrystarium()
                end
				GUI:NewLine()
				local stoprunning = GUI:Button("Stop",400,50)
                if GUI:IsItemClicked(stoprunning) then 
					backtosleep.stopRunning()
                end
            end
            GUI:End()
        end
    end
end


function backtosleep.teleportTo(aetheryteID)
	if TimeSince(backtosleepteleportnow) > 6000 then
		if not  MIsCasting() then
			Player:Teleport(aetheryteID)
		end
		backtosleepteleportnow = Now()
		backtosleepmovenow = Now()
	end
end


function backtosleep.bigAetheryteInteract(contentid,querystring)
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

					


function backtosleep.innGuyInteract(contentid)
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

function backtosleep.stopIfMoving()
	if Player:IsMoving() then
		Player:Stop()
	end
end

function backtosleep.canMoveTo(posx,posy,posz)
	if TimeSince(backtosleepmovenow) > 8000 then
		if not MIsCasting() or not MIsLoading() then
			Player:MoveTo(posx,posy,posz)
		end
	end
end

function backtosleep.randomMoveTo(posx,posy,posz,min,max)
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
			backtosleep.canMoveTo(backtosleeprandompoint.x,backtosleeprandompoint.y,backtosleeprandompoint.z)
		end
	end
end



function backtosleep.cityBigAetheryteTravel(posx,posy,posz,deviation,aetheryteContentID,querystring)
	if not (math.distance3d(Player.pos,{x= posx,y= posy, z= posz})<= deviation) then
		backtosleep.canMoveTo(posx,posy,posz)
	else
		backtosleep.stopIfMoving()
		backtosleep.bigAetheryteInteract(aetheryteContentID,querystring)
	end

end

function backtosleep.cityBigAetheryteTeleport(posx,posy,posz,deviation)
	if not (math.distance3d(Player.pos,{x= posx,y= posy, z= posz})<= deviation) then
		backtosleep.canMoveTo(posx,posy,posz)
	else
		backtosleep.stopIfMoving()
		backtosleep.stopRunning()
	end

end


function backtosleep.innGuyTravel(posx,posy,posz,contentID)
	if not (math.distance3d(Player.pos,{x=posx,y=posy,z=posz})<=1) then
		backtosleep.canMoveTo(posx,posy,posz)
	else
		backtosleep.innGuyInteract(contentID)
	end
end


function backtosleep.OnUpdateHandler( Event, ticks )	
--ROOST
	if backtosleep.runningroost then
		if Player.localmapid == 179 then
			backtosleep.stopRunning()
		elseif not (Player.localmapid == 132) then
			backtosleep.teleportTo(2)		
		elseif (Player.localmapid == 132) then
			backtosleep.innGuyTravel(25.56,-8.00,97.94,1000102)
		end
	end
--MIZZENMAST	
	if backtosleep.runningmizzen then
		if Player.localmapid == 177 then
			backtosleep.stopRunning()
		elseif not (Player.localmapid == 128) and not (Player.localmapid == 129) then
			backtosleep.teleportTo(8)
		elseif (Player.localmapid == 129) then
			backtosleep.cityBigAetheryteTravel(-84.03,20.77,0.02,8,8,"The Aftcastle.")
		elseif (Player.localmapid == 128) then
			backtosleep.innGuyTravel(12.83,40,11.66,1000974)
		end		
	end
--HOURGLASS	
	if backtosleep.runninghourglass then
		if Player.localmapid == 178 then
			backtosleep.stopRunning()
		elseif not (Player.localmapid == 130) then
			backtosleep.teleportTo(9)
		elseif (Player.localmapid == 130) then
			if math.distance3d(Player.pos,{x=-147.05,y=-3.15,z=-165.64})<=10 then
				backtosleep.cityBigAetheryteTravel(-147.05,-3.15,-165.64,3,9,"Adventurers' Guild.")
			elseif math.distance3d(Player.pos,{x=39.32,y=8.00,z=-98.18})<=40 then
				backtosleep.innGuyTravel(29.06,7.00,-80.31,1001976)				
			else
				backtosleep.teleportTo(9)
			end
		end		
	end
--CloudNine
	if backtosleep.runningcloudnine then
		if Player.localmapid == 429 then
			backtosleep.stopRunning()
		elseif not (Player.localmapid == 418) then
			backtosleep.teleportTo(70)
		elseif (Player.localmapid == 418) then
			if math.distance3d(Player.pos,{x=-63.98,y=11.15,z=43.99})<=15 then
				backtosleep.cityBigAetheryteTravel(-63.98,11.15,43.99,8,70,"The Forgotten Knight.")
			elseif math.distance3d(Player.pos,{x=66.40,y=23.98,z=18.08})<=40 then
				backtosleep.innGuyTravel(84.83,15.09,33.61,1011193)												
			else
				backtosleep.teleportTo(70)
			end
		end		
	end
--BokairoInn
	if backtosleep.runningbokairoinn then
		if Player.localmapid == 629 then
			backtosleep.stopRunning()
		elseif not (Player.localmapid == 628) then
			backtosleep.teleportTo(111)
		elseif (Player.localmapid == 628) then
			if math.distance3d(Player.pos,{x=47.5,y=8.44,z=-37.31})<=15 then
				backtosleep.cityBigAetheryteTravel(47.5,8.44,-37.31,8,111,"Bokairo Inn.")
			elseif math.distance3d(Player.pos,{x=-84.73,y=18.05,z=-181.11})<=25 then
				backtosleep.innGuyTravel(-85.85,19.00,-198.99,1018981)												
			else
				backtosleep.teleportTo(111)
			end
		end		
	end
--ThePendants	
	if backtosleep.runningthependants then
		if Player.localmapid == 843 then
			backtosleep.stopRunning()
		elseif not (Player.localmapid == 819) then
			backtosleep.teleportTo(133)
		elseif (Player.localmapid == 819) then
			if math.distance3d(Player.pos,{x=-65.02,y=4.53,z=0.02})<=15 then
				backtosleep.cityBigAetheryteTravel(-65.02,4.53,0.02,9,133,"The Pendants.")
			elseif math.distance3d(Player.pos,{x=52.74,y=1.71,z=232.94})<=25 then
				backtosleep.innGuyTravel(62.71,1.72,247.85,1027231)												
			else
				backtosleep.teleportTo(133)
			end
		end		
	end
--FC Chest Limsa
	if backtosleep.runningfclimsa then
		if Player.localmapid == 129 and math.distance3d(Player.pos,{x=-199.58,y=16.00,z=57.51})<=8 then
			if not Player:IsMoving() then
				backtosleep.stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		elseif not (Player.localmapid == 129) then
			backtosleep.teleportTo(8)
		elseif (Player.localmapid == 129) then
			if math.distance3d(Player.pos,{x=-84.03,y=20.77,z=0.02})<=20 then
				backtosleep.cityBigAetheryteTravel(-84.03,20.77,0.02,8,8,"Hawkers' Alley.")
			elseif math.distance3d(Player.pos,{x=-201.49,y=15.98,z=50.6})<=25 then
				backtosleep.randomMoveTo(-199.58,16.00,57.51,0,6)				
			else
				backtosleep.teleportTo(8)
			end
		end		
	end
--Central Aetheryte Limsa
	if backtosleep.runningcentrallimsa then
		if math.distance3d(Player.pos,{x=-84.03,y=20.77,z=0.02})<=20 then
			backtosleep.cityBigAetheryteTeleport(-84.03,20.77,0.02,6)
		else
			backtosleep.teleportTo(8)
		end
				
	end
--MB Limsa
	if backtosleep.runningmblimsa then
		--map and range where it ends
		if Player.localmapid == 129 and math.distance3d(Player.pos,{x=-224.28,y=16.00,z=46.66})<=4 then
			if not Player:IsMoving() then
				backtosleep.stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not (Player.localmapid == 129) then
			backtosleep.teleportTo(8)
		--if on map but not objective...
		elseif (Player.localmapid == 129) then
			--if around aetheryte interact and aetheryte to hawkers' Alley
			if math.distance3d(Player.pos,{x=-84.03,y=20.77,z=0.02})<=20 then
				backtosleep.cityBigAetheryteTravel(-84.03,20.77,0.02,8,8,"Hawkers' Alley.")
			--if somewhere midway between aetheryte Hawkers' Alley and objective 		
			elseif math.distance3d(Player.pos,{x=-217.75,y=16.00,z=47.32})<=10 then
				--random move to max radius < range where it ends (same pos as where it ends)
				backtosleep.randomMoveTo(-224.28,16.00,46.66,0,3)				
			else
				backtosleep.teleportTo(8)
			end
		end		
	end
--Leve Kugane
	if backtosleep.runninglevekugane then
		--map and range where it ends
		if Player.localmapid == 628 and math.distance3d(Player.pos,{x=21.03,y=0.00,z=-76.93})<=4 then
			if not Player:IsMoving() then
				backtosleep.stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not (Player.localmapid == 628) then
			backtosleep.teleportTo(111)
		--if on map but not objective...
		elseif (Player.localmapid == 628) then
			--if somewhere midway between aetheryte and objective 		
			if math.distance3d(Player.pos,{x=34.8,y=3,z=-60.91})<=40 then
				--random move to max radius < range where it ends (same pos as where it ends)
				backtosleep.randomMoveTo(21.03,0.00,-76.93,0,3)				
			else
				backtosleep.teleportTo(111)
			end
		end		
	end
--MB Kugane
	if backtosleep.runningmbkugane then
		--map and range where it ends
		if Player.localmapid == 628 and math.distance3d(Player.pos,{x=2.47,y=4.00,z=51.23})<=4 then
			if not Player:IsMoving() then
				backtosleep.stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not (Player.localmapid == 628) then
			backtosleep.teleportTo(111)
		--if on map but not objective...
		elseif (Player.localmapid == 628) then
			--if around aetheryte interact and aetheryte to hawkers' Alley
			if math.distance3d(Player.pos,{x=47.5,y=8.44,z=-37.31})<=15 then
				backtosleep.cityBigAetheryteTravel(47.5,8.44,-37.31,8,111,"Kogane Dori Markets.")
			--if somewhere midway between aetheryte and objective 		
			elseif math.distance3d(Player.pos,{x=12.28,y=4.00,z=60.91})<=25 then
				--random move to max radius < range where it ends (same pos as where it ends)
				if TimeSince(backtosleepmovenow) > 10000 then
					backtosleep.randomMoveTo(2.47,4.00,51.23,0,3)				
				end
			else
				if math.distance3d(Player.pos,{x=34.8,y=3,z=-60.91})<=40 then
					backtosleep.cityBigAetheryteTravel(47.5,8.44,-37.31,8,111,"Kogane Dori Markets.")
					backtosleepmovenow = Now()
				else
					backtosleep.teleportTo(111)
				end
			end
		end		
	end
--Leve Crystarium
	if backtosleep.runninglevecrystarium then
		--map and range where it ends
		if Player.localmapid == 819 and math.distance3d(Player.pos,{x=-72.35,y=20.00,z=-111.34})<=4 then
			if not Player:IsMoving() then
				backtosleep.stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		--if not on map tp to it
		elseif not (Player.localmapid == 819) then
			backtosleep.teleportTo(133)
		--if on map but not objective...
		elseif (Player.localmapid == 819) then
			--if around aetheryte interact and aetheryte to hawkers' Alley
			if math.distance3d(Player.pos,{x=-65.02,y=4.53,z=0.02})<=15 then
				backtosleep.cityBigAetheryteTravel(-65.02,4.53,0.02,9,133,"The Crystalline Mean.")
			--if somewhere midway between aetheryte and objective 		
			elseif math.distance3d(Player.pos,{x=-61.98,y=20.00,z=-138.94})<=45 then
				--random move to max radius < range where it ends (same pos as where it ends)
				backtosleep.randomMoveTo(-72.35,20.00,-111.34,0,3)				
			else
				backtosleep.teleportTo(133)
			end
		end		
	end

end

RegisterEventHandler("Gameloop.Update",backtosleep.OnUpdateHandler)
RegisterEventHandler("Module.Initalize",backtosleep.ModuleInit) 
RegisterEventHandler("Gameloop.Draw", backtosleep.Draw, "backtosleep Draw")
