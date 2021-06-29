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
local backtosleepteleportnow = backtosleep.now
local backtosleepinteractnow = backtosleep.interact

function backtosleep.ModuleInit()
	backtosleep.CheckMenu()
end


--Toggle Function 
function backtosleep.ToggleRunRoost()
    backtosleep.runningroost = not backtosleep.runningroost
	backtosleep.running = not backtosleep.running
	
	-- the others
	backtosleep.runningmizzen = false
	backtosleep.runninghourglass = false
	backtosleep.runningcloudnine = false
	if Player:IsMoving() then
		Player:Stop()
	end
end

function backtosleep.ToggleRunMizzen()
    backtosleep.runningmizzen = not backtosleep.runningmizzen
	backtosleep.running = not backtosleep.running
	
	-- the others
	backtosleep.runningroost = false
	backtosleep.runninghourglass = false
	backtosleep.runningcloudnine = false
	if Player:IsMoving() then
		Player:Stop()
	end
end

function backtosleep.ToggleRunHourglass()
    backtosleep.runninghourglass = not backtosleep.runninghourglass
	backtosleep.running = not backtosleep.running
	
	-- the others
	backtosleep.runningroost = false
	backtosleep.runningmizzen = false
	backtosleep.runningcloudnine = false
	if Player:IsMoving() then
		Player:Stop()
	end
end

function backtosleep.ToggleRunCloudNine()
    backtosleep.runningcloudnine = not backtosleep.runningcloudnine
	backtosleep.running = not backtosleep.running
	
	-- the others
	backtosleep.runningroost = false
	backtosleep.runningmizzen = false
	backtosleep.runninghourglass = false
	if Player:IsMoving() then
		Player:Stop()
	end
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
            end
            GUI:End()
        end
    end
end




function backtosleep.OnUpdateHandler( Event, ticks )	
--ROOST
	if backtosleep.runningroost then
		--backtosleep.runningmizzen = false
		if Player.localmapid == 179 then
			backtosleep.runningroost = false
			backtosleep.running = false
		elseif not (Player.localmapid == 132) then
			if TimeSince(backtosleepteleportnow) > 6000 then
				if not  MIsCasting() then
					Player:Teleport(2)
				end
				backtosleepteleportnow = Now()
			end
		elseif (Player.localmapid == 132) then
			if not (math.distance3d(Player.pos,{x=25.56,y=-8.00,z=97.94})<=1) then
				if not MIsCasting() or not MIsLoading() then
					Player:MoveTo(25.56,-8.00,97.94)
				end
			else
				if MEntityList('contentid=1000102,maxdistance=25') then
					if not IsControlOpen("SelectString") then
						if TimeSince(backtosleepinteractnow) > 1000 then
							Player:SetTarget(tonumber(tostring(next(MEntityList('contentid=1000102,nearest')))))
							Player:Interact(Player:GetTarget().id)
							backtosleepinteractnow = Now()
						end
					else
						if TimeSince(backtosleepinteractnow) > 1000 then
							if IsControlOpen("SelectString") and Player:GetTarget().contentid == 1000102 then
								UseControlAction("SelectString", "SelectIndex", 0)
							end
						end
					end
				end	
			end
		end
	end
--MIZZENMAST	
	if backtosleep.runningmizzen then
		--backtosleep.runningroost = false
		if Player.localmapid == 177 then
			backtosleep.runningmizzen = false
			backtosleep.running = false
		elseif not (Player.localmapid == 128) and not (Player.localmapid == 129) then
			if TimeSince(backtosleepteleportnow) > 6000 then
				if not  MIsCasting() then
					Player:Teleport(8)
				end
				backtosleepteleportnow = Now()
			end		
		elseif (Player.localmapid == 129) then
			if not (math.distance3d(Player.pos,{x=-84.03,y=20.77,z=0.02})<=8) then
				Player:MoveTo(-84.03,20.77,0.02)
			else
				if Player:IsMoving() then
					Player:Stop()
				end
				if MEntityList('contentid=8,maxdistance=25') then
					if Player:GetTarget() == nil then
						if TimeSince(backtosleepinteractnow) > 500 then
							Player:SetTarget(tonumber(tostring(next(MEntityList('contentid=8,nearest')))))
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
					if IsControlOpen("SelectString") and GetControl("SelectString"):GetData()[0] == "The Aftcastle." then
						if TimeSince(backtosleepinteractnow) > 1000 then
							UseControlAction("SelectString", "SelectIndex", 0)
							backtosleepinteractnow = Now()
						end								
					end					
				end
			end
			
		elseif (Player.localmapid == 128) then
			if not (math.distance3d(Player.pos,{x=12.83,y=40.00,z=11.66})<=1) then
				if not MIsCasting() or not MIsLoading() then
					Player:MoveTo(12.83,40.00,11.66)
				end
				
			else
				if MEntityList('contentid=1000974,maxdistance=25') then					
					if Player:GetTarget() == nil then
						if TimeSince(backtosleepinteractnow) > 1000 then
							Player:SetTarget(tonumber(tostring(next(MEntityList('contentid=1000974,nearest')))))
							Player:Interact(Player:GetTarget().id)
							backtosleepinteractnow = Now()
						end
					end
					if IsControlOpen("SelectString") and Player:GetTarget().contentid == 1000974 then
						if TimeSince(backtosleepinteractnow) > 1000 then
							UseControlAction("SelectString", "SelectIndex", 0)
							backtosleepinteractnow = Now()
						end						
					end
				end	
			end
		end		
	end
--HOURGLASS	
	if backtosleep.runninghourglass then
		--backtosleep.runningroost = false
		if Player.localmapid == 178 then
			backtosleep.runninghourglass = false
			backtosleep.running = false
		elseif not (Player.localmapid == 130) then
			if TimeSince(backtosleepteleportnow) > 6000 then
				if not  MIsCasting() then
					Player:Teleport(9)
				end
				backtosleepteleportnow = Now()
			end
		elseif (Player.localmapid == 130) then
			if math.distance3d(Player.pos,{x=-147.05,y=-3.15,z=-165.64})<=10 then
				if not (math.distance3d(Player.pos,{x=-147.05,y=-3.15,z=-165.64})<=3) then
					Player:MoveTo(-147.05,-3.15,-165.64)
				else
					if Player:IsMoving() then
						Player:Stop()
					end
					if MEntityList('contentid=9,maxdistance=25') then
						if Player:GetTarget() == nil then
							if TimeSince(backtosleepinteractnow) > 1000 then
								Player:SetTarget(tonumber(tostring(next(MEntityList('contentid=9,nearest')))))
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
						if IsControlOpen("SelectString") and GetControl("SelectString"):GetData()[0] == "Adventurers' Guild." then
							if TimeSince(backtosleepinteractnow) > 1000 then
								UseControlAction("SelectString", "SelectIndex", 0)
								backtosleepinteractnow = Now()
							end
						end					
					end
				end
			elseif math.distance3d(Player.pos,{x=39.32,y=8.00,z=-98.18})<=40 then
				if not (math.distance3d(Player.pos,{x=29.06,y=7.00,z=-80.31})<=1) then
					if not MIsCasting() or not MIsLoading() then
						Player:MoveTo(29.06,7.00,-80.31)
					end
					
				else
					if MEntityList('contentid=1001976,maxdistance=25') then
						if Player:GetTarget() == nil then
							if TimeSince(backtosleepinteractnow) > 1000 then
								Player:SetTarget(tonumber(tostring(next(MEntityList('contentid=1001976,nearest')))))
								Player:Interact(Player:GetTarget().id)
								backtosleepinteractnow = Now()
							end
						end
						if IsControlOpen("SelectString") and Player:GetTarget().contentid == 1001976 then
							if TimeSince(backtosleepinteractnow) > 1000 then						
								UseControlAction("SelectString", "SelectIndex", 0)
								backtosleepinteractnow = Now()
							end
						end
					end	
				end
			else
				if TimeSince(backtosleepteleportnow) > 6000 then			
					if not  MIsCasting() then
						Player:Teleport(9)
					end
					backtosleepteleportnow = Now()					
				end
			end
		end		
	end
--CloudNine
	if backtosleep.runningcloudnine then
		d(backtosleepteleportnow)
		if TimeSince(backtosleepteleportnow) > 5000 then
			if not  MIsCasting() then
				Player:Teleport(70)
			end
			backtosleepteleportnow = Now()
		end
		

	end
end

RegisterEventHandler("Gameloop.Update",backtosleep.OnUpdateHandler)
--RegisterEventHandler("backtosleep.TOGGLE", backtosleep.ToggleRun) 
RegisterEventHandler("Module.Initalize",backtosleep.ModuleInit) 
RegisterEventHandler("Gameloop.Draw", backtosleep.Draw, "backtosleep Draw")

