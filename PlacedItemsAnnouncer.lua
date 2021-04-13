-- Title: Placed Items Announcer
-- Author: LownIgnitus
-- Version: 0.0.4
-- Desc: Announces when consumable items are placed in group

CF = CreateFrame
local addon_name = "PlacedItemAnnouncer"
SLASH_PLACEDITEMSANNOUNCER1, SLASH_PLACEDITEMSANNOUNCER2 = '/PIA', '/pia'

-- RegisterForEvent table
local piaEvents_table = {}

piaEvents_table.eventFrame = CF("Frame");
piaEvents_table.eventFrame:RegisterEvent("ADDON_LOADED");
if not InCombatLockdown() then
	piaEvents_table.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end
piaEvents_table.eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
piaEvents_table.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
piaEvents_table.eventFrame:SetScript("OnEvent", function(self, event, ...)
	piaEvents_table.eventFrame[event](self, ...);
end);

function piaEvents_table.eventFrame:ADDON_LOADED(AddOn)
	--print("addon loaded")
	if AddOn ~= addon_name then
		return -- not my addon
	end

	-- unregister ADDON_LOADED
	piaEvents_table.eventFrame:UnregisterEvent("ADDON_LOADED")

	-- Defaults
	local deafults = {
		["options"] = {
			["piaActivate"] = true,
			["piaDebug"] = false,
		}
	}

	local function piaSVCheck(src, dst)
		if type(src) ~= "table" then return {} end
		
		if type(dst) ~= "table" then dst = {} end
		
		for k, v in pairs(src) do
			if type(v) == "table" then
				dst[k] = piaSVCheck(v, dst[k])
			elseif type(v) ~= type(dst[k]) then
				dst[k] = v
			end
		end
		
		return dst
	end

	piaSettings = piaSVCheck(deafults, piaSettings)
end


feastIDs = {
	[57301] = 1, -- Great Feast (LK)
	[57426] = 1, -- Fish Feast (LK)
	[58465] = 1, -- Gigantic Feast (LK)
	[58474] = 1, -- Small Feast (LK)
	[66476] = 1, -- Bountiful Feast (Pilgrim's Bounty)
	[87643] = 1, -- Broiled Dragon Feast (Cata)
	[87644] = 1, -- Seafood Magnifique Feast (Cata)
	[87915] = 1, -- Goblin Barbecue (Cata)
	[104958] = 1, -- Pandaren Banquet (MoP)
	[105193] = 1, -- Great Pandaren Banquet (MoP)
	[126492] = 1, -- Banquet of the Grill (MoP)
	[126494] = 1, -- Great Banquet of the Grill (MoP)
	[126495] = 1, -- Banquet of the Wok (MoP)
	[126496] = 1, -- Great Banquet of the Wok (MoP)
	[126497] = 1, -- Banquet of the Pot (MoP)
	[126498] = 1, -- Great Banquet of the Pot (MoP)
	[126499] = 1, -- Banquet of the Steamer (MoP)
	[126500] = 1, -- Great Banquet of the Steamer (MoP)
	[126501] = 1, -- Banquet of the Oven (MoP)
	[126502] = 1, -- Great Banquet of the Oven (MoP)
	[126503] = 1, -- Banquet of the Brew (MoP)
	[126504] = 1, -- Great Banquet of the Brew (MoP)
	[160740] = 1, -- Feast of Blood (WoD)
	[160914] = 1, -- Feast of the Waters (WoD)
	[175215] = 1, -- Savage Feast (WoD)
	[185706] = 1, -- Fancy Darkmoon Feast (DMF)
	[185709] = 1, -- Sugar-Crusted Fish Feast (DMF)
	[201351] = 1, -- Hearty Feast (Legion)
	[201352] = 1, -- Lavish Suramar Feast (Legion)
	[216333] = 1, -- Potato Stew Feast (BattleGround (Legion))
	[216347] = 1, -- Feast of Ribs (Battleground (Legion)) 
	[251254] = 1, -- Feast of the Fishes (Legion)
	[259409] = 1, -- Gallery Banquet (BFA)
	[259410] = 1, -- Bountiful Captain's Feast (BFA)
	[286050] = 1, -- Sanguinated Feast (BFA)
	[297048] = 1, -- Famine Evaluator And Snack Table (BFA)
	[308458] = 1, -- Surprisingly Palatable Feast (SL)
	[308462] = 1, -- Feast of Gluttonous Hedonism (SL)
	}

cauldrenIDs = {
	[41443] = 1, -- Cauldron of Major Arcane Protection (TBC)
	[41494] = 1, -- Cauldron of Major Fire Protection (TBC)
	[41495] = 1, -- Cauldron of Major Frost Protection (TBC)
	[41497] = 1, -- Cauldron of Major Nature Protection (TBC)
	[41498] = 1, -- Cauldron of Major Shadow Protection (TBC)
	[92649] = 1, -- Cauldron of Battle (Cata)
	[92712] = 1, -- Big Cauldron of Battle (Cata)
	[188036] = 1, -- Spirit Cauldron (Legion)
	[276972] = 1, -- Mystical Cauldron (BFA)
	[298861] = 1, -- Greater Mystical Cauldron (BFA)
	[307157] = 1, -- Eternal Cauldron (SL)
	}

repairIDs = {
	[22700] = 1, -- Field Repair Bot 74A (WoW)
	[44389] = 1, -- Field Repair Bot 110G (TBC)
	[54711] = 1, -- Scrapbopt Consctruction Kit (LK)
	[67826] = 1, -- Jeeves (LK)
	[157066] = 1, -- Walter (WoD)
	[199109] = 1, -- Auto-Hammer (Legion)
	}

codexIDs = {
	[226241] = 1, -- Codex of the Tranquil Min (Legion)
	[256234] = 1, -- Codex of the Quiet Mind (BFA)
	[324029] = 1, -- Codex of the Still Mind (SL)
	}

summonIDs = {
	[698] = 1, -- Ritual of Summoning (Warlock)
	}

miscIDs = {
	[29893] = 1, -- Creat Soulwell (Warlock)
	[190336] = 1, -- Conjure Refreshment (Mage)
	[255473] = 1, -- Interdimensional Companion Repository (BFA)
	[256153] = 1, -- Deployable Attire Rearranger (BFA)
	}

function piaEvents_table.eventFrame:COMBAT_LOG_EVENT_UNFILTERED()
	local _, subevent, _, _, sourceName, _, _, _, destinationName, _, _, spellID, spellName = CombatLogGetCurrentEventInfo()
	local player = UnitName("player")
	
	if sourceName == player and piaSettings.options.piaDebug == true then
		print(spellName)
		print(spellID)
		print(subevent)
		print(sourceName)
	end

	local message = ""
	local channel
	local spellLink = GetSpellLink(spellID)
	
	if subevent == "SPELL_CAST_START" or subevent == "SPELL_SUMMON" or subevent == "SPELL_CREATE" then
		local inGroup = IsInGroup()
		local inRaid = IsInRaid()
		
		if piaSettings.options.piaDebug == true then
			print("in sub events")
			print("Group " .. tostring(inGroup))
			print("Raid " .. tostring(inRaid))
		end
		
		if inGroup then
			if (cauldrenIDs[spellID] or codexIDs[spellID] or miscIDs[spellID] and subevent ~= "SPELL_CREATE") then
				message = sourceName .. " just placed a " .. spellLink
			elseif (feastIDs[spellID] or summonIDs[spellID] or repairIDs[spellID] and subevent == "SPELL_CREATE") then
				message = sourceName .. " is casting " .. spellLink
			end

			if piaSettings.options.piaDebug == true then
				print(message)
			end
			
			if inGroup == true and inRaid == true then
				channel = "RAID"
			elseif inGroup == true and not inRaid then
				channel = "PARTY"
			end
			
			SendChatMessage(message, channel)
		end
	end
end

function piaEvents_table.eventFrame:PLAYER_REGEN_ENABLED()
	--print("out of combat")
	piaEvents_table.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function piaEvents_table.eventFrame:PLAYER_REGEN_DISABLED()
	--print("in combat")
	piaEvents_table.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function piaInitialize()
	if piaSettings.options.piaActivate == true then
		ChatFrame1:AddMessage("Placed Items Announcer |cff00ff00Activated|r!")
	elseif piaSettings.options.piaActivate == false then
		piaEvents_table.eventFrame:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		piaEvents_table.eventFrame:UnregisterEvent
		piaEvents_table.eventFrame:UnregisterEvent
	end

	if piaSettings.options.piaDebug == true then
		ChatFrame1:AddMessage("Placed Items Announcer |cff00ff00Debug Activated|r!")
	end
end

function SlashCmdList.PLACEDITEMSANNOUNCER(msg, Editbox)
	if msg == "toggle" then
		piaToggle()
	elseif msg == "debug" then
		piaDebug()
	else
		ChatFrame1:AddMessage("|cff71C671" .. GetAddOnMetadata(addon_name, "Title") .. "|r")
		ChatFrame1:AddMessage("|cff71C671(Version: " .. GetAddOnMetadata(addon_name, "Version") .. "|r")
		ChatFrame1:AddMessage("|cff71C671type /pia followed by:|r")
		ChatFrame1:AddMessage("|cff71C671  -- toggle the addon activation state|r")
		ChatFrame1:AddMessage("|cff71C671  -- debug for debug mode|r")
	end
end

function piaToggle()
	if piaSettings.options.piaActivate == false then
		piaSettings.options.piaActivate = true
		ChatFrame1:AddMessage("Placed Items Announcer |cff00ff00Activated|r!")
	elseif piaSettings.options.piaActivate == true then
		piaSettings.options.piaActivate = false
		ChatFrame1:AddMessage("Placed Items Announcer |cffff0000Deactivated|r!")
	end
end

function piaDebug()
	if piaSettings.options.piaDebug == false then
		piaSettings.options.piaDebug = true
		ChatFrame1:AddMessage("Placed Items Announcer |cff00ff00Debug Activated|r!")
	elseif piaSettings.options.piaDebug == true then
		piaSettings.options.piaDebug = false
		ChatFrame1:AddMessage("Placed Items Announcer |cffff0000Debug Deactivated|r!")
	end
end