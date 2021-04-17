-- Title: Placed Items Announcer
-- Author: LownIgnitus
-- Version: 0.0.5
-- Desc: Announces when consumable items are placed in group

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

CF = CreateFrame
local addon_name = "PlacedItemsAnnouncer"
SLASH_PLACEDITEMSANNOUNCER1, SLASH_PLACEDITEMSANNOUNCER2 = '/PIA', '/pia'

-- RegisterForEvent table
local piaEvents_table = {}

piaEvents_table.eventFrame = CF("Frame");
piaEvents_table.eventFrame:RegisterEvent("ADDON_LOADED");
piaEvents_table.eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
piaEvents_table.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
piaEvents_table.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
piaEvents_table.eventFrame:SetScript("OnEvent", function(self, event, ...)
	piaEvents_table.eventFrame[event](self, ...);
end);

function piaEvents_table.eventFrame:ADDON_LOADED(AddOn)
	print(addon_name .. " loaded")
	if AddOn ~= addon_name then
		return -- not my addon
	end

	-- unregister ADDON_LOADED
	piaEvents_table.eventFrame:UnregisterEvent("ADDON_LOADED")

	-- Defaults
	local deafults = {
		["options"] = {
			["piaActivate"] = true,
			["piaDebug1"] = false,
			["piaDebug2"] = false,
			["piaDebug3"] = false,
			["piaDebug4"] = false,
			["piaDebug5"] = false,
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

function piaEvents_table.eventFrame:COMBAT_LOG_EVENT_UNFILTERED()
	if piaSettings.options.piaActivate == true then
		local _, subevent, _, _, sourceName, _, _, _, destinationName, _, _, spellID, spellName = CombatLogGetCurrentEventInfo()
		local player = UnitName("player")
		local inParty = UnitInParty(sourceName)

		if piaSettings.options.piaDebug2 == true then
			print(sourceName)
			print(inParty)
		end
		
		if (sourceName == player and piaSettings.options.piaDebug3 == true) then
			print(spellName)
			print(spellID)
			print(subevent)
		end
		--SPELL_CAST_START
		if subevent == "SPELL_CAST_SUCCESS" or subevent == "SPELL_SUMMON" or subevent == "SPELL_CREATE" then
			local inGroup = IsInGroup()
			local inDungeon = IsInGroup(LE_PARTY_CATEGORY_INSTANCE)
			local inRaid = IsInRaid()
			local inLFR = IsInRaid(LE_PARTY_CATEGORY_INSTANCE)
			
			if piaSettings.options.piaDebug4 == true then
				print("in sub events")
				print("Group " .. tostring(inGroup))
				print("Dungeon " .. tostring(inDungeon))
				print("Raid " .. tostring(inRaid))
				print("LFR " .. tostring(inLFR))
			end
			
			if (inGroup == true and inParty == true) then
				local message = ""
				local channel
				local spellLink = GetSpellLink(spellID)
				if (miscIDs[spellID] or cauldrenIDs[spellID] or codexIDs[spellID] or feastIDs[spellID]) and subevent == "SPELL_CAST_SUCCESS" then
					message = sourceName .. " just placed a " .. spellLink
				--[[elseif (miscIDs[spellID] and subevent == "SPELL_SUMMON") then
					message = sourceName .. " just placed a " .. spellLink]]
				elseif (summonIDs[spellID] or repairIDs[spellID]) and subevent == "SPELL_CREATE" then
					message = sourceName .. " is casting " .. spellLink
				end

				if piaSettings.options.piaDebug5 == true then
					print(message)
				end
				
				if inGroup == true and inRaid == true and not inLFR then
					channel = "RAID"
				elseif inGroup == true and not inRaid and not inDungeon then
					channel = "PARTY"
				elseif (inGroup == true and inLFR == true) or (inGroup == true and inDungeon == true) then
					channel = "INSTANCE_CHAT"
				end
				
				SendChatMessage(message, channel)
			end
		end
	end
end

function piaEvents_table.eventFrame:PLAYER_REGEN_ENABLED()
	if piaSettings.options.piaActivate == true then
		if piaSettings.options.piaDebug1 == true then
			print("out of combat")
		end

		piaEvents_table.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

function piaEvents_table.eventFrame:PLAYER_REGEN_DISABLED()
	if piaSettings.options.piaActivate == true then
		if piaSettings.options.piaDebug1 == true then
			print("in combat")
		end

		piaEvents_table.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	end
end

function SlashCmdList.PLACEDITEMSANNOUNCER(msg, Editbox)
	--print(msg)
	local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
	--print(cmd .. " " .. args)
	if cmd == "toggle" then
		piaToggle()
	elseif cmd == "debug" then
		piaDebug(args)
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

function piaDebug(args)
	if args == "1" then
		if piaSettings.options.piaDebug1 == false then
			piaSettings.options.piaDebug1 = true
			ChatFrame1:AddMessage("Placed Items Announcer |cff00ff00Debug Combat check Activated|r!")
		elseif piaSettings.options.piaDebug1 == true then
			piaSettings.options.piaDebug1 = false
			ChatFrame1:AddMessage("Placed Items Announcer |cffff0000Debug Combat check Deactivated|r!")
		end
	elseif args == "2" then
		if piaSettings.options.piaDebug2 == false then
			piaSettings.options.piaDebug2 = true
			ChatFrame1:AddMessage("Placed Items Announcer |cff00ff00Debug Party check Activated|r!")
		elseif piaSettings.options.piaDebug2 == true then
			piaSettings.options.piaDebug2 = false
			ChatFrame1:AddMessage("Placed Items Announcer |cffff0000Debug party check Deactivated|r!")
		end
	elseif args == "3" then
		if piaSettings.options.piaDebug3 == false then
			piaSettings.options.piaDebug3 = true
			ChatFrame1:AddMessage("Placed Items Announcer |cff00ff00Debug Spell Name & Event Activated|r!")
		elseif piaSettings.options.piaDebug3 == true then
			piaSettings.options.piaDebug3 = false
			ChatFrame1:AddMessage("Placed Items Announcer |cffff0000Debug Spell Name & Event Deactivated|r!")
		end
	elseif args == "3" then
		if piaSettings.options.piaDebug3 == false then
			piaSettings.options.piaDebug3 = true
			ChatFrame1:AddMessage("Placed Items Announcer |cff00ff00Debug Group check Activated|r!")
		elseif piaSettings.options.piaDebug3 == true then
			piaSettings.options.piaDebug3 = false
			ChatFrame1:AddMessage("Placed Items Announcer |cffff0000Debug Group check Deactivated|r!")
		end
	elseif args == "4" then
		if piaSettings.options.piaDebug4 == false then
			piaSettings.options.piaDebug4 = true
			ChatFrame1:AddMessage("Placed Items Announcer |cff00ff00Debug Message check Activated|r!")
		elseif piaSettings.options.piaDebug4 == true then
			piaSettings.options.piaDebug4 = false
			ChatFrame1:AddMessage("Placed Items Announcer |cffff0000Debug Message check Deactivated|r!")
		end
	else
		if piaSettings.options.piaDebug1 == false then
			piaSettings.options.piaDebug1 = true
			piaSettings.options.piaDebug2 = true
			piaSettings.options.piaDebug3 = true
			ChatFrame1:AddMessage("Placed Items Announcer |cff00ff00Debug Activated|r!")
		elseif piaSettings.options.piaDebug1 == true then
			piaSettings.options.piaDebug1 = false
			piaSettings.options.piaDebug2 = false
			piaSettings.options.piaDebug3 = false
			ChatFrame1:AddMessage("Placed Items Announcer |cffff0000Debug Deactivated|r!")
		end
	end
end