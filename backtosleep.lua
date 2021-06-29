--using Kitanoi snippet from discord
--Rinn#4747

backtosleep= { }
backtosleep.runningroost = false
backtosleep.runningmizzen = false
backtosleep.runninghourglass = false
backtosleep.runningcloudnine = false
backtosleep.running = false
backtosleep.lastticks = 0
backtosleep.GUI = {}
backtosleep.GUI.open = true
backtosleep.GUI.visible = true
backtosleep.GUI.hue = 125
backtosleep.now = 0
backtosleep.interact = 0
backtosleep.move = 0
local backtosleepteleportnow = backtosleep.now
local backtosleepinteractnow = backtosleep.interact
local backtosleepmovenow = backtosleep.move

function backtosleep.ModuleInit()
	backtosleep.CheckMenu()
end


function backtosleep.stopRunning()
	backtosleep.runningroost = false
	backtosleep.runningmizzen = false
	backtosleep.runninghourglass = false
	backtosleep.runningcloudnine = false
	backtosleep.running = false
	backtosleep.stopIfMoving()
end


function backtosleep.ToggleRun()
end

--Toggle Function 
function backtosleep.ToggleRunRoost()
    backtosleep.runningroost = not backtosleep.runningroost
	backtosleep.running = not backtosleep.running
	
	-- the others
	backtosleep.runningmizzen = false
	backtosleep.runninghourglass = false
	backtosleep.runningcloudnine = false
	backtosleep.stopIfMoving()
end

function backtosleep.ToggleRunMizzen()
    backtosleep.runningmizzen = not backtosleep.runningmizzen
	backtosleep.running = not backtosleep.running
	
	-- the others
	backtosleep.runningroost = false
	backtosleep.runninghourglass = false
	backtosleep.runningcloudnine = false
	backtosleep.stopIfMoving()
end

function backtosleep.ToggleRunHourglass()
    backtosleep.runninghourglass = not backtosleep.runninghourglass
	backtosleep.running = not backtosleep.running
	
	-- the others
	backtosleep.runningroost = false
	backtosleep.runningmizzen = false
	backtosleep.runningcloudnine = false
	backtosleep.stopIfMoving()
end

function backtosleep.ToggleRunCloudNine()
    backtosleep.runningcloudnine = not backtosleep.runningcloudnine
	backtosleep.running = not backtosleep.running
	
	-- the others
	backtosleep.runningroost = false
	backtosleep.runningmizzen = false
	backtosleep.runninghourglass = false
	backtosleep.stopIfMoving()
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
				local toggleroostsleep = GUI:Button("Roost Inn",100,20)
                if GUI:IsItemClicked(toggleroostsleep) then 
					backtosleep.ToggleRunRoost()
                end
				GUI:SameLine()
				GUI:NewLine()
				local togglemizzensleep = GUI:Button("Mizzenmast",100,20)
                if GUI:IsItemClicked(togglemizzensleep) then 
					backtosleep.ToggleRunMizzen()
                end
				GUI:SameLine()
				GUI:NewLine()
				local togglehourglasssleep = GUI:Button("Hourglass",100,20)
                if GUI:IsItemClicked(togglehourglasssleep) then 
					backtosleep.ToggleRunHourglass()
                end
				GUI:SameLine()
				GUI:NewLine()
				local togglecloudninesleep = GUI:Button("CloudNine",100,20)
                if GUI:IsItemClicked(togglecloudninesleep) then 
					backtosleep.ToggleRunCloudNine()
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
		if IsControlOpen("SelectString") and GetControl("SelectString"):GetData()[0] == querystring then
			if TimeSince(backtosleepinteractnow) > 1000 then
				UseControlAction("SelectString", "SelectIndex", 0)
				backtosleepinteractnow = Now() 
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

function backtosleep.cityBigAetheryteTravel(posx,posy,posz,deviation,aetheryteContentID,querystring)
	if not (math.distance3d(Player.pos,{x= posx,y= posy, z= posz})<= deviation) then
		backtosleep.canMoveTo(posx,posy,posz)
	else
		backtosleep.stopIfMoving()
		backtosleep.bigAetheryteInteract(aetheryteContentID,querystring)
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
end

RegisterEventHandler("Gameloop.Update",backtosleep.OnUpdateHandler)
RegisterEventHandler("Module.Initalize",backtosleep.ModuleInit) 
RegisterEventHandler("Gameloop.Draw", backtosleep.Draw, "backtosleep Draw")
