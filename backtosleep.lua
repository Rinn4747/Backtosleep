--using Kitanoi snippet from discord
--Rinn#4747

backtosleep= { }
backtosleep.runningroost = false
backtosleep.runningmizzen = false
backtosleep.lastticks = 0
backtosleep.GUI = {}
backtosleep.GUI.open = true
backtosleep.GUI.visible = true
backtosleep.GUI.hue = 125

function backtosleep.ModuleInit()
	backtosleep.CheckMenu()
end

function backtosleep.ToggleRunRoost()
    backtosleep.runningroost = not backtosleep.runningroost
	if Player:IsMoving() then
		Player:Stop()
	end
end

function backtosleep.ToggleRunMizzen()
    backtosleep.runningmizzen = not backtosleep.runningmizzen
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
			GUI:SetNextWindowSize(285,75,GUI.SetCond_FirstUseEver) 			
            backtosleep.GUI.visible, backtosleep.GUI.open = GUI:Begin("backtosleep", backtosleep.GUI.open)
            if ( backtosleep.GUI.visible ) then
                backtosleep.Enable,changed = GUI:Checkbox("Enable##Enable", backtosleep.Enable)
				local toggleroostsleep = GUI:Button("Roost Inn",100)
                if GUI:IsItemClicked(toggleroostsleep) then 
					backtosleep.ToggleRunRoost()
                end
				GUI:SameLine()
				GUI:InputText([[##StateRoost]], tostring(backtosleep.runningroost), (GUI.InputTextFlags_ReadOnly))
				GUI:NewLine()
				local togglemizzensleep = GUI:Button("Mizzenmast",100)
                if GUI:IsItemClicked(togglemizzensleep) then 
					backtosleep.ToggleRunMizzen()
                end
				GUI:SameLine()
				GUI:InputText([[##StateMizzen]], tostring(backtosleep.runningmizzen), (GUI.InputTextFlags_ReadOnly))
            end
            GUI:End()
        end
    end
end


function backtosleep.OnUpdateHandler( Event, ticks )

	if backtosleep.runningroost then
		backtosleep.runningmizzen = false
		if Player.localmapid == 179 then
			backtosleep.runningroost = false
		elseif not (Player.localmapid == 132) then
			if not  MIsCasting() then
				Player:Teleport(2)
			end
		elseif (Player.localmapid == 132) then
			if not (math.distance3d(Player.pos,{x=25.56,y=-8.00,z=97.94})<=1) then
				if not MIsCasting() or not MIsLoading() then
					Player:MoveTo(25.56,-8.00,97.94)
				end
			else
				if MEntityList('contentid=1000102,maxdistance=25') then
					Player:SetTarget(tonumber(tostring(next(MEntityList('contentid=1000102,nearest')))))
					Player:Interact(Player:GetTarget().id)
					if IsControlOpen("SelectString") and Player:GetTarget().contentid == 1000102 then
						UseControlAction("SelectString", "SelectIndex", 0)
					end
				end	
			end
		end
	end
	if backtosleep.runningmizzen then
		backtosleep.runningroost = false
		if Player.localmapid == 177 then
			backtosleep.runningmizzen = false
		elseif not (Player.localmapid == 128) and not (Player.localmapid == 129) then
			if not  MIsCasting() then
				Player:Teleport(8)
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
						Player:SetTarget(tonumber(tostring(next(MEntityList('contentid=8,nearest')))))
					end
					if not IsControlOpen("SelectString") and not (Player:GetTarget() == nil) then
						Player:Interact(Player:GetTarget().id)
					end
					if IsControlOpen("SelectString") and GetControl("SelectString"):GetData()[0] == "Aethernet." then
						UseControlAction("SelectString", "SelectIndex", 0)
					end
					if IsControlOpen("SelectString") and GetControl("SelectString"):GetData()[0] == "The Aftcastle." then
						UseControlAction("SelectString", "SelectIndex", 0)
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
					Player:SetTarget(tonumber(tostring(next(MEntityList('contentid=1000974,nearest')))))
					Player:Interact(Player:GetTarget().id)
					if IsControlOpen("SelectString") and Player:GetTarget().contentid == 1000974 then
						UseControlAction("SelectString", "SelectIndex", 0)
					end
				end	
			end
		end		
	end
end

RegisterEventHandler("Gameloop.Update",backtosleep.OnUpdateHandler)
--RegisterEventHandler("backtosleep.TOGGLE", backtosleep.ToggleRun) 
RegisterEventHandler("Module.Initalize",backtosleep.ModuleInit) 
RegisterEventHandler("Gameloop.Draw", backtosleep.Draw, "backtosleep Draw")
