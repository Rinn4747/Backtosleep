--using Kitanoi draw function / menu snippet from discord #lua-help
--Rinn#4747
--with help from HereToPlay#4566 to update to the new teleport control
--v0.0.14

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
							"vendoreulmore",
							"exarchiceulmore",
							"twinaddersbarracks",
							"maelstrombarracks",
							"immortalbarracks",						
}

local function currentProcess(string)
	return backtosleep["running"..string]
end

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
backtosleep.currentservertravel = ""
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
			["Eulmore"] = 820,
			["TwinAdders Barracks"] = 534, 
			["Maelstrom Barracks"] = 536,
			["Immortal Barracks"] = 535,
}

backtosleep.pos.aetheryteID = {
			["Gridania"] = {id = 2, tpradius = 7},
			["Limsa"] = {id = 8, tpradius = 8},
			["Ul'dah"] = {id = 9, tpradius = 4},
			["Ishgard"] = {id = 70, tpradius = 8},
			["Kugane"] = {id = 111, tpradius = 8},
			["Crystarium"] = {id = 133, tpradius = 9},
			["Eulmore"] = {id = 134, tpradius = 10},
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
			["Eulmore Aetheryte"] = {x=0.259,y=82.313,z=0.060, radius = 14},
			["Eulmore Vendor Stop"] = {x=-46.817,y=84.195,z=30.547, radius = 3},
			["Eulmore Exarchic Stop"] = {x=-16.350,y=82.273, z=-22.697, radius = 3 },

}

backtosleep.pos.innkeeper = {
			["Gridania"] = {x=25.56 , y=-8 , z=97.94 , contentID =1000102 },
			["Limsa"] = {x=12.83 , y=40 , z=11.66 , contentID =1000974 },
			["Ul'dah"] = {x=29.06 , y=7.00 , z=-80.31 , contentID =1001976 },
			["Ishgard"] = {x=84.83 , y=15.09 , z=33.61 , contentID =1011193 },
			["Kugane"] = {x=-85.85 , y=19.00 , z=-198.99 , contentID =1018981 },
			["Crystarium"] = {x=62.71 , y=1.72 , z=247.85 , contentID =1027231 },
			["Maelstrom"] = {x=97.47 , y=40.25 , z=62.84 , contentID =2007527 },
			["TwinAdders"] = {x=-79.63 , y=-0.5 , z=-6.18 , contentID =2006962},
			["Immortal"] = {x=-152.2 , y=4.11 , z=-97.38 , contentID =2007529 },
}

backtosleep.serveridtoname = {
			[23] = "Asura",
			[24] = "Belias",
			[28] = "Pandaemonium",
			[29] = "Shinryu",
			[30] = "Unicorn",
			[31] = "Yojimbo",
			[32] = "Zeromus",
			[33] = "Twintania",
			[34] = "Brynhildr",
			[35] = "Famfrit",
			[36] = "Lich",
			[37] = "Mateus",
			[39] = "Omega",
			[40] = "Jenova",
			[41] = "Zalera",
			[42] = "Zodiark",
			[43] = "Alexander",
			[44] = "Anima",
			[45] = "Carbuncle",
			[46] = "Fenrir",
			[47] = "Hades",
			[48] = "Ixion",
			[49] = "Kujata",
			[50] = "Typhon",
			[51] = "Ultima",
			[52] = "Valefor",
			[53] = "Exodus",
			[54] = "Faerie",
			[55] = "Lamia",
			[56] = "Phoenix",
			[57] = "Siren",
			[58] = "Garuda",
			[59] = "Ifrit",
			[60] = "Ramuh",
			[61] = "Titan",
			[62] = "Diabolos",
			[63] = "Gilgamesh",
			[64] = "Leviathan",
			[65] = "Midgardsormr",
			[66] = "Odin",
			[67] = "Shiva",
			[68] = "Atomos",
			[69] = "Bahamut",
			[70] = "Chocobo",
			[71] = "Moogle",
			[72] = "Tonberry",
			[73] = "Adamantoise",
			[74] = "Coeurl",
			[75] = "Malboro",
			[76] = "Tiamat",
			[77] = "Ultros",
			[78] = "Behemoth",
			[79] = "Cactuar",
			[80] = "Cerberus",
			[81] = "Goblin",
			[82] = "Mandragora",
			[83] = "Louisoix",
			[85] = "Spriggan",
			[90] = "Aegis",
			[91] = "Balmung",
			[92] = "Durandal",
			[93] = "Excalibur",
			[94] = "Gungnir",
			[95] = "Hyperion",
			[96] = "Masamune",
			[97] = "Ragnarok",
			[98] = "Ridill",
			[99] = "Sargatanas",
}
backtosleep.servernametoid = {
			["Adamantoise"] = 73,
			["Aegis"] = 90,
			["Alexander"] = 43,
			["Anima"] = 44,
			["Asura"] = 23,
			["Atomos"] = 68,
			["Bahamut"] = 69,
			["Balmung"] = 91,
			["Behemoth"] = 78,
			["Belias"] = 24,
			["Brynhildr"] = 34,
			["Cactuar"] = 79,
			["Carbuncle"] = 45,
			["Cerberus"] = 80,
			["Chocobo"] = 70,
			["Coeurl"] = 74,
			["Diabolos"] = 62,
			["Durandal"] = 92,
			["Excalibur"] = 93,
			["Exodus"] = 53,
			["Faerie"] = 54,
			["Famfrit"] = 35,
			["Fenrir"] = 46,
			["Garuda"] = 58,
			["Gilgamesh"] = 63,
			["Goblin"] = 81,
			["Gungnir"] = 94,
			["Hades"] = 47,
			["Hyperion"] = 95,
			["Ifrit"] = 59,
			["Ixion"] = 48,
			["Jenova"] = 40,
			["Kujata"] = 49,
			["Lamia"] = 55,
			["Leviathan"] = 64,
			["Lich"] = 36,
			["Louisoix"] = 83,
			["Malboro"] = 75,
			["Mandragora"] = 82,
			["Masamune"] = 96,
			["Mateus"] = 37,
			["Midgardsormr"] = 65,
			["Moogle"] = 71,
			["Odin"] = 66,
			["Omega"] = 39,
			["Pandaemonium"] = 28,
			["Phoenix"] = 56,
			["Ragnarok"] = 97,
			["Ramuh"] = 60,
			["Ridill"] = 98,
			["Sargatanas"] = 99,
			["Shinryu"] = 29,
			["Shiva"] = 67,
			["Siren"] = 57,
			["Spriggan"] = 85,
			["Tiamat"] = 76,
			["Titan"] = 61,
			["Tonberry"] = 72,
			["Twintania"] = 33,
			["Typhon"] = 50,
			["Ultima"] = 51,
			["Ultros"] = 77,
			["Unicorn"] = 30,
			["Valefor"] = 52,
			["Yojimbo"] = 31,
			["Zalera"] = 41,
			["Zeromus"] = 32,
			["Zodiark"] = 42,
}

backtosleep.servertoregionid = {
			[23] = 3,
			[24] = 3,
			[28] = 3,
			[29] = 3,
			[30] = 1,
			[31] = 2,
			[32] = 2,
			[33] = 7,
			[34] = 8,
			[35] = 5,
			[36] = 7,
			[37] = 8,
			[39] = 6,
			[40] = 4,
			[41] = 8,
			[42] = 7,
			[43] = 2,
			[44] = 3,
			[45] = 1,
			[46] = 2,
			[47] = 3,
			[48] = 3,
			[49] = 1,
			[50] = 1,
			[51] = 2,
			[52] = 2,
			[53] = 5,
			[54] = 4,
			[55] = 5,
			[56] = 7,
			[57] = 4,
			[58] = 1,
			[59] = 2,
			[60] = 1,
			[61] = 3,
			[62] = 8,
			[63] = 4,
			[64] = 5,
			[65] = 4,
			[66] = 7,
			[67] = 7,
			[68] = 1,
			[69] = 2,
			[70] = 3,
			[71] = 6,
			[72] = 1,
			[73] = 4,
			[74] = 8,
			[75] = 8,
			[76] = 2,
			[77] = 5,
			[78] = 5,
			[79] = 4,
			[80] = 6,
			[81] = 8,
			[82] = 3,
			[83] = 6,
			[85] = 6,
			[90] = 1,
			[91] = 8,
			[92] = 2,
			[93] = 5,
			[94] = 1,
			[95] = 5,
			[96] = 3,
			[97] = 6,
			[98] = 2,
			[99] = 4,
}


backtosleep.server = {
			[1] = {
				90,
				68,
				45,
				58,
				94,
				49,
				60,
				72,
				50,
				30,
			},
			[2] = {
				43,
				69,
				92,
				46,
				59,
				98,
				76,
				51,
				52,
				31,
				32,
			},
			[3] = {
				44,
				23,
				24,
				70,
				47,
				48,
				82,
				96,
				28,
				29,
				61,
			},
			[4] = {
				73,
				79,
				54,
				63,
				40,
				65,
				99,
				57,
			},
			[5] = {
				78,
				93,
				53,
				35,
				95,
				55,
				64,
				77,	
			},
			[6] = {
				80,
				83,
				71,
				39,
				97,
				85,	
			},
			[7] = {
				36,
				66,
				56,
				67,
				33,
				42,	
			},
			[8] = {
				91,
				34,
				74,
				62,
				81,
				75,
				37,
				41,	
			},
}

function backtosleep.countIndex(worldstring)
	local count = 0
	
	--local currentservername = GetControl("_DTR"):GetStrings()[4]
	--local matchedcurrentserverid = backtosleep.servernametoid[currentservername]
	local matchedcurrentserverid = Player.currentworld
	local regionid = backtosleep.servertoregionid[Player.homeworld]
	local worldid = backtosleep.servernametoid[worldstring]
	for _,world in pairs(backtosleep.server[regionid]) do
		if worldid == matchedcurrentserverid then
			break
		else
			if not (world == matchedcurrentserverid) then
				count = count + 1
			end
			if world == worldid then
				break
			end
		end
	end
	if count == 0 then
		return count
	else
		return count + 1
	end
end

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
                    if (v.name ~= nil and v.name == "RinnLib") then
                        Status = true
                    end
                end
            end
        end
    end
    if (not Status) then
		local menuiconpath = GetLuaModsPath().."\\Backtosleep\\Rinn.jpg"
		local iconpath = GetLuaModsPath().."\\Backtosleep\\bts.png"
        ml_gui.ui_mgr:AddMember({ id = "FFXIVMINION##RinnLib", name = "RinnLib", texture = menuiconpath, test = "backtosleep"},"FFXIVMINION##MENU_HEADER")
        ml_gui.ui_mgr:AddSubMember({ id = "FFXIVMINION##backtosleep", name = "backtosleep", onClick = function() backtosleep.GUI.open = not backtosleep.GUI.open end, tooltip = "backtosleep", texture = iconpath},"FFXIVMINION##MENU_HEADER","FFXIVMINION##RinnLib")
    elseif (Status) then
		local iconpath = GetLuaModsPath().."\\Backtosleep\\bts.png"
        ml_gui.ui_mgr:AddSubMember({ id = "FFXIVMINION##backtosleep", name = "backtosleep", onClick = function() backtosleep.GUI.open = not backtosleep.GUI.open end, tooltip = "backtosleep", texture = iconpath},"FFXIVMINION##MENU_HEADER","FFXIVMINION##RinnLib")
    end
end

local function guitogglebutton(strbuttonfunction,strbuttoncaption)
	local buttonfunction = GUI:Button(strbuttoncaption,100,20)
	if GUI:IsItemClicked(buttonfunction) then 
		ToggleRun(strbuttonfunction)
	end
end



function backtosleep.Draw( event, ticks )
	local regionid = backtosleep.servertoregionid[Player.currentworld]
    local gamestate = GetGameState()
    if ( gamestate == FFXIV.GAMESTATE.INGAME ) then
        if ( backtosleep.GUI.open ) then
			GUI:SetNextWindowSize(440,335,GUI.SetCond_FirstUseEver) 			
			--GUI:SetNextWindowSize(440,335) 
            backtosleep.GUI.visible, backtosleep.GUI.open = GUI:Begin("Backtosleep", backtosleep.GUI.open)
            if ( backtosleep.GUI.visible ) then
                backtosleep.Enable,changed = GUI:Checkbox("Enable##Enable", backtosleep.Enable)
				GUI:InputTextEditor([[##State]], "Currently running : "..tostring(backtosleep.running),430,50,(GUI.InputTextFlags_ReadOnly))
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
				GUI:SameLine()
				GUI:NewLine()
					guitogglebutton("vendoreulmore","Aymark")
				GUI:SameLine()
					guitogglebutton("exarchiceulmore","Hilicen")
				GUI:SameLine()
				GUI:NewLine()
					local servers = {}
					for i,e in pairs(backtosleep.server[regionid]) do 
						if not (e == Player.currentworld) then
							servers[#servers+1] = tostring(backtosleep.serveridtoname[e])
						end
					end
					for _,server in pairs(servers) do
						if not backtosleep["running"..server] then
							backtosleep["running"..server] = false
						end
						backtosleep.toggletable[#backtosleep.toggletable+1] = server					
					end
					local counter = 0
					if backtosleep.server[regionid] ~= nil then
						for i,e in pairs(backtosleep.server[regionid]) do
							

							if not (e == Player.currentworld) then
								if counter >= 4 then
									counter = 0
									GUI:SameLine()
									GUI:NewLine()
								end							
								local buttonserverfunction = GUI:Button(tostring(backtosleep.serveridtoname[e]),100,20)
								if GUI:IsItemClicked(buttonserverfunction) then 
									backtosleep.currentservertravel = backtosleep.serveridtoname[e]
									ToggleRun(backtosleep.serveridtoname[e])
								end
								GUI:SameLine()
								counter = counter  +  1 
							end
						end
					end					
				GUI:SameLine()
				GUI:NewLine()
					if Player.GrandCompanyRank >= 9 then
						if Player.GrandCompany == 2 then
							guitogglebutton("twinaddersbarracks","Twin Adders")
						elseif Player.GrandCompany == 1 then
							guitogglebutton("maelstrombarracks","Maelstrom")
						elseif Player.GrandCompany == 3 then
							guitogglebutton("immortalbarracks","Immortal")
						end
						GUI:SameLine()
					end
					if Player.GrandCompanyRank >= 9 then
						if Player.GrandCompany == 2 then
							local buttonfunction = GUI:Button("GC Ticket",100,20)
							if GUI:IsItemClicked(buttonfunction) then
								backtosleep.useTeleportGC()
								ToggleRun("twinaddersbarracks")
							end
							--guitogglebutton("twinaddersbarracks","Twin Adders")
						elseif Player.GrandCompany == 1 then
							local buttonfunction = GUI:Button("GC Ticket",100,20)
							if GUI:IsItemClicked(buttonfunction) then 
								backtosleep.useTeleportGC()
								ToggleRun("maelstrombarracks")
							end						
							--guitogglebutton("maelstrombarracks","Maelstrom")
						elseif Player.GrandCompany == 3 then
							local buttonfunction = GUI:Button("GC Ticket",100,20)
							if GUI:IsItemClicked(buttonfunction) then 
								backtosleep.useTeleportGC()
								ToggleRun("immortalbarracks")
							end						
							--guitogglebutton("immortalbarracks","Immortal")
						end
						GUI:SameLine()
					end
					--guitogglebutton("hoptobooster","Do WorldHop")
				GUI:SameLine()
				GUI:NewLine()
					local stoprunning = GUI:Button("Stop",430,50)
					if GUI:IsItemClicked(stoprunning) then 
						stopRunning()
					end
				
            end
            GUI:End()
        end
    end
end

function backtosleep.useTeleportGC()
	local bags = {0, 1, 2, 3}
	for _, e in pairs(bags) do
		local bag = Inventory:Get(e)
		if (table.valid(bag)) then
			local ilist = bag:GetList()
			if (table.valid(ilist)) then
				for _, item in pairs(ilist) do
					if item.ID == 21069 and Player.GrandCompany == 1 then
						item:Cast(Player)
					end
					if item.ID == 21070 and Player.GrandCompany == 2 then
						item:Cast(Player)
					end					
					if item.ID == 21071 and Player.GrandCompany == 3 then
						item:Cast(Player)
					end		
				end
			end
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

local function worldTravelAetheryteInteract(contentid,querynumber)
	if MEntityList("contentid="..tostring(contentid)..",maxdistance=25") then
		if IsControlOpen("WorldTravelFinderReady") then
			backtosleepinteractnow = Now()
		end
		if Player:GetTarget() == nil then
			if TimeSince(backtosleepinteractnow) > 1000 then
				Player:SetTarget(tonumber(tostring(next(MEntityList("contentid="..tostring(contentid)..",nearest")))))
				backtosleepinteractnow = Now()
			end
			d("gettarget == nil")
		end
		if not IsControlOpen("SelectString") and not (Player:GetTarget() == nil) and not IsControlOpen("WorldTravelSelect") and not IsControlOpen("SelectYesno") then
			if TimeSince(backtosleepinteractnow) > 1000 then
				Player:Interact(Player:GetTarget().id)
				backtosleepinteractnow = Now()
			end
			d("not gettarget == nil")
		end
		if IsControlOpen("SelectString") then
			local worlddataindex = 2
			for i,string in pairs(GetControl("SelectString"):GetData()) do if string == "Visit Another World Server." then worlddataindex = i end end
				
			if IsControlOpen("SelectString") and GetControl("SelectString"):GetData()[worlddataindex] == "Visit Another World Server." then
				if TimeSince(backtosleepinteractnow) > 1000 then
					UseControlAction("SelectString", "SelectIndex", worlddataindex)
					backtosleepinteractnow = Now()
				end
				d("visit another world server")
			end
		end
		if IsControlOpen("WorldTravelSelect") then
			if TimeSince(backtosleepinteractnow) > 1000 then
				d("the fuck?")
				d("querynumber = "..tostring(querynumber))
				UseControlAction("WorldTravelSelect", "SelectIndex", querynumber)
				backtosleepinteractnow = Now() 
			end
		end
		if IsControlOpen("SelectYesno") then
			if TimeSince(backtosleepinteractnow) > 1000 then
				UseControlAction("SelectYesno", "Yes")
				backtosleepinteractnow = Now() 
			end
		end
	end
end

local function findAthernet(tableathernet,name)
	for _, v in pairs(tableathernet) do  
		if v.string == name then
			return v.index
		end
	end 
	return nil
end		

local function bigAetheryteInteract(contentid,querystring)
	if MEntityList("contentid="..tostring(contentid)..",maxdistance=25") then
		if Player:GetTarget() == nil then
			if TimeSince(backtosleepinteractnow) > 1000 then
				Player:SetTarget(tonumber(tostring(next(MEntityList("contentid="..tostring(contentid)..",nearest")))))
				backtosleepinteractnow = Now()
			end
		end
		if not IsControlOpen("SelectString") and not (Player:GetTarget() == nil) and not IsControlOpen("TelepotTown") then
			if TimeSince(backtosleepinteractnow) > 1000 then
				Player:Interact(Player:GetTarget().id)
				backtosleepinteractnow = Now()
			end
		end
		
			
		if IsControlOpen("SelectString") and GetControl("SelectString"):GetData()[0] == "Aethernet." and not IsControlOpen("TelepotTown") then
			if TimeSince(backtosleepinteractnow) > 1000 then
				UseControlAction("SelectString", "SelectIndex", 0)
				backtosleepinteractnow = Now()
			end
		end
		if GetControl("TelepotTown") ~= nil then
			if GetControl("TelepotTown"):GetData() ~= nil then
				if IsControlOpen("TelepotTown") then
					if TimeSince(backtosleepinteractnow) > 1000 then
						local currentaetherytequery = GetControl("TelepotTown"):GetData()
						if currentaetherytequery ~= nil then
							local currentindex = findAthernet(currentaetherytequery.aethernet, querystring )
							if currentindex == nil then
								d("BACKTOSLEEP ERROR: ATHERNET NOT FOUND - "..querystring)
								stopIfMoving()
								stopRunning()
							end
							
							UseControlAction("TelepotTown", "Teleport", currentindex)
							backtosleepinteractnow = Now() 
						end
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

local function barracksDoorInteract(contentid)
	if MEntityList("contentid="..tostring(contentid)..",maxdistance=25") then
		if not IsControlOpen("SelectYesno") then
			if TimeSince(backtosleepinteractnow) > 1000 then
				Player:SetTarget(tonumber(tostring(next(MEntityList("contentid="..tostring(contentid)..",nearest")))))
				Player:Interact(Player:GetTarget().id)
				backtosleepinteractnow = Now()
			end
		else
			if TimeSince(backtosleepinteractnow) > 2000 then
				if IsControlOpen("SelectYesno") and Player:GetTarget().contentid == contentid then
					UseControlAction("SelectYesno", "Yes")
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

local function cityBigAetheryteWorldTravel(aetherytelocation,aetheryteid,worldindex)
	local posx = backtosleep.pos.loc[aetherytelocation].x
	local posy = backtosleep.pos.loc[aetherytelocation].y
	local posz = backtosleep.pos.loc[aetherytelocation].z
	local deviation = backtosleep.pos.aetheryteID[aetheryteid].tpradius
	local aetheryteContentID = backtosleep.pos.aetheryteID[aetheryteid].id
	stopIfMoving()
	worldTravelAetheryteInteract(aetheryteContentID,worldindex)
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

function barracksDoorTravel(string)
	local posx = backtosleep.pos.innkeeper[string].x
	local posy = backtosleep.pos.innkeeper[string].y
	local posz = backtosleep.pos.innkeeper[string].z
	local content = backtosleep.pos.innkeeper[string].contentID
	if not (math.distance3d(Player.pos,{x=posx,y=posy,z=posz})<=1) then
		canMoveTo(posx,posy,posz)
	else
		barracksDoorInteract(content)
	end
end

function backtosleep.exportGridaniaInn()
	if iAmOnMap("The Roost") then
		stopRunning()
	elseif not iAmOnMap("Old Gridania") then
		teleportTo("Gridania")		
	elseif iAmOnMap("Old Gridania") then
		innGuyTravel("Gridania")
	end
end

function backtosleep.exportLimsaInn()
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

function backtosleep.exportUldahInn()
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

function backtosleep.exportIshgardInn()
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

function backtosleep.exportKuganeInn()
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

function backtosleep.exportCrystariumInn()
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

function backtosleep.exportGCBarracks()
	if Player.GrandCompanyRank >= 9 then
		if Player.GrandCompany == 2 then --twinadders
			if iAmOnMap("TwinAdders Barracks")then
				stopRunning()
			elseif not iAmOnMap("Old Gridania") then
				teleportTo("Gridania")		
			elseif iAmOnMap("Old Gridania") then
				barracksDoorTravel("TwinAdders")
			end		
		elseif Player.GrandCompany == 1 then --maelstrom
			if iAmOnMap("Maelstrom Barracks") then
				stopRunning()
			elseif not iAmOnMap("Limsa Lominsa Upper Deck") and not iAmOnMap("Limsa Lominsa Lower Deck") then
				teleportTo("Limsa")
			elseif iAmOnMap("Limsa Lominsa Lower Deck") then
				cityBigAetheryteTravel("Limsa Aetheryte","Limsa","The Aftcastle.")
			elseif iAmOnMap("Limsa Lominsa Upper Deck") then
				barracksDoorTravel("Maelstrom")
			end	
		elseif Player.GrandCompany == 3 then -- immortal
			if iAmOnMap("Immortal Barracks")then
				stopRunning()
			elseif not iAmOnMap("Steps of Nald") then
				teleportTo("Ul'dah")		
			elseif iAmOnMap("Steps of Nald") then
				barracksDoorTravel("Immortal")
			end		
		end
	end	
end


function backtosleep.exportWorldTravel(worldstring)
	if iAmOnLocRange("Limsa Aetheryte") then
		if GetControl("_DTR"):GetStrings()[4] == worldstring and not MIsLoading() then
			stopRunning()
			stopIfMoving()
		else
			if not (math.distance3d(Player.pos,{x= -83.995,y= 18.908, z= -0.016})<= 8) and not (GetControl("_DTR"):GetStrings()[4] == worldstring) and not MIsLoading() then
				canMoveTo(-83.995,18.908,-0.016)
			else
				stopIfMoving()
				if GetControl("_DTR"):GetStrings()[4] == worldstring then
					stopRunning()
				else
					if iAmOnLocRange("Limsa Aetheryte") then
						local worldindex = backtosleep.countIndex(worldstring)
						cityBigAetheryteWorldTravel("Limsa Aetheryte","Limsa",worldindex)
					end
				end
			end
		end
	else
		teleportTo("Limsa")
	end
end

function backtosleep.exportWorldTravelRefactored(worldstring,locstring,aetherytestring)
	local loc = backtosleep.pos.loc[locstring]
	if iAmOnLocRange(locstring) then
		if GetControl("_DTR"):GetStrings()[4] == worldstring and not MIsLoading() then
			stopRunning()
			stopIfMoving()
		else
			if not (math.distance3d(Player.pos,{x= loc.x,y= loc.y, z= loc.z})<= loc.radius) and not (GetControl("_DTR"):GetStrings()[4] == worldstring) and not MIsLoading() then
				canMoveTo(loc.x,loc.y,loc.z)
			else
				stopIfMoving()
				if GetControl("_DTR"):GetStrings()[4] == worldstring then
					stopRunning()
				else
					if iAmOnLocRange(locstring) then
						local worldindex = backtosleep.countIndex(worldstring)
						cityBigAetheryteWorldTravel(locstring,aetherytestring,worldindex)
					end
				end
			end
		end
	else
		teleportTo(aetherytestring)
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
			cityBigAetheryteTravel("Limsa Aetheryte","Limsa","The Aftcastle")
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
				cityBigAetheryteTravel("Ul'dah Aetheryte","Ul'dah","Adventurers' Guild")
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
				cityBigAetheryteTravel("Ishgard Aetheryte","Ishgard","The Forgotten Knight")
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
				cityBigAetheryteTravel("Kugane Aetheryte","Kugane","Bokairo Inn")
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
				cityBigAetheryteTravel("Crystarium Aetheryte","Crystarium","The Pendants")
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
			if iAmOnLocRange("Limsa Aetheryte") then
				cityBigAetheryteTravel("Limsa Aetheryte","Limsa","Hawkers' Alley")
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
				cityBigAetheryteTravel("Limsa Aetheryte","Limsa","Hawkers' Alley")
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
				cityBigAetheryteTravel("Kugane Aetheryte","Kugane","Kogane Dori Markets")
			--if somewhere midway between aetheryte and objective 		
			elseif iAmOnLocRange("Kugane MB Area") then
				--random move to max radius < range where it ends (same pos as where it ends)
				if TimeSince(backtosleepmovenow) > 10000 then
					randomMoveTo("Kugane MB Stop",0,3)				
				end
			else
				if iAmOnLocRange("Kugane Leves Area") then
					cityBigAetheryteTravel("Kugane Aetheryte","Kugane","Kogane Dori Markets")
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
				cityBigAetheryteTravel("Crystarium Aetheryte","Crystarium","The Crystalline Mean")
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
				cityBigAetheryteTravel("Gridania Aetheryte","Gridania","Leatherworkers' Guild") 						
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
				cityBigAetheryteTravel("Ul'dah Aetheryte","Ul'dah","Sapphire Avenue Exchange") 						
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
				cityBigAetheryteTravel("Ul'dah Aetheryte","Ul'dah","Sapphire Avenue Exchange") 						
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
				cityBigAetheryteTravel("Gridania Aetheryte","Gridania","Leatherworkers' Guild") 						
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
		if iAmOnMap("The Pillars") and iAmOnLocRange("Ishgard MB Stop") then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		elseif not iAmOnMap("Foundation") and not iAmOnMap("The Pillars")  then
			teleportTo("Ishgard")
		elseif iAmOnMap("Foundation") then
			if iAmOnLocRange("Ishgard Aetheryte") then
				cityBigAetheryteTravel("Ishgard Aetheryte","Ishgard","The Jeweled Crozier") 						
			else
				teleportTo("Ishgard")
			end
		elseif iAmOnMap("The Pillars") and iAmOnLocRange("Ishgard MB Area") then
			randomMoveTo("Ishgard MB Stop",0,2)
		else
			teleportTo("Ishgard")
		end		
	end
--Eulmore Vendor
	if currentProcess("vendoreulmore") then
		if iAmOnMap("Eulmore") and iAmOnLocRange("Eulmore Vendor Stop") then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		elseif iAmOnMap("Eulmore") and iAmOnLocRange("Eulmore Aetheryte") then
			randomMoveTo("Eulmore Vendor Stop",0,2)
		elseif not iAmOnMap("Eulmore") then
			teleportTo("Eulmore")
		end
	end
--Exarchic Eulmore
	if currentProcess("exarchiceulmore") then
		if iAmOnMap("Eulmore") and iAmOnLocRange("Eulmore Exarchic Stop") then
			if not Player:IsMoving() then
				stopRunning()
				backtosleeprandompoint = nil
				d("stop running")
			end
		elseif iAmOnMap("Eulmore") and iAmOnLocRange("Eulmore Aetheryte") then
			randomMoveTo("Eulmore Exarchic Stop",0,2)
		elseif not iAmOnMap("Eulmore") then
			teleportTo("Eulmore")
		end
	end
--TwinAdders
	if currentProcess("twinaddersbarracks") then
		if iAmOnMap("TwinAdders Barracks")then
			stopRunning()
		elseif not iAmOnMap("Old Gridania") then
			teleportTo("Gridania")		
		elseif iAmOnMap("Old Gridania") then
			barracksDoorTravel("TwinAdders")
		end
	end
--Maelstrom	
	if currentProcess("maelstrombarracks") then
		if iAmOnMap("Maelstrom Barracks") then
			stopRunning()
		elseif not iAmOnMap("Limsa Lominsa Upper Deck") and not iAmOnMap("Limsa Lominsa Lower Deck") then
			teleportTo("Limsa")
		elseif iAmOnMap("Limsa Lominsa Lower Deck") then
			cityBigAetheryteTravel("Limsa Aetheryte","Limsa","The Aftcastle")
		elseif iAmOnMap("Limsa Lominsa Upper Deck") then
			barracksDoorTravel("Maelstrom")
		end		
	end
--Immortal
	if currentProcess("immortalbarracks") then
		if iAmOnMap("Immortal Barracks")then
			stopRunning()
		elseif not iAmOnMap("Steps of Nald") then
			teleportTo("Ul'dah")		
		elseif iAmOnMap("Steps of Nald") then
			barracksDoorTravel("Immortal")
		end
	end
--WORLDHOP
	if currentProcess(backtosleep.currentservertravel) then
		if Player.currentworld == backtosleep.servernametoid[backtosleep.currentservertravel] then
			stopRunning()
			backtosleep["running"..tostring(backtosleep.currentservertravel)] = false
		else
			backtosleep.exportWorldTravelRefactored(backtosleep.currentservertravel,"Gridania Aetheryte","Gridania")
		end
	end
end

RegisterEventHandler("Gameloop.Update",backtosleep.OnUpdateHandler,"backtosleep onupdate")
RegisterEventHandler("Module.Initalize",backtosleep.ModuleInit,"backtosleep init") 
RegisterEventHandler("Gameloop.Draw", backtosleep.Draw, "backtosleep Draw")
