-- Title: Placed Item Announcer
-- Author: LownIgnitus
-- Version: 0.0.1
-- Desc: Announces when consumable items are placed in group

CF = CreateFrame
local addon_name = "PlacedItemAnnouncer"

-- RegisterForEvent table
local piaEvents_table = {}

piaEvents_table.eventFrame = CF("Frame");
piaEvents_table.eventFrame:RegisterEvent("ADDON_LOADED");
piaEvents_table.eventFrame:SetScript("OnEvent", function(self, event, ...)
	piaEvents_table.eventFrame[event](self, ...);
end);

function piaEvents_table.eventFrame:ADDON_LOADED(AddOn)
	if AddOn ~= addon_name then
		return -- not my addon
	end

	-- unregister ADDON_LOADED
	piaEvents_table.eventFrame:UnregisterEvent("ADDON_LOADED")

	-- Defaults
	local deafults = {
		["options"] = {
			["piaActivate"] = true,
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

	if not InCombatLockdown() then
		piaEvents_table.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	end
	piaEvents_table.eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED");
	piaEvents_table.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED");
end


feastIDs = {
	[57301], -- Great Feast (LK)
	[57426], -- Fish Feast (LK)
	[58465], -- Gigantic Feast (LK)
	[58474], -- Small Feast (LK)
	[66476], -- Bountiful Feast (Pilgrim's Bounty)
	[87643], -- Broiled Dragon Feast (Cata)
	[87644], -- Seafood Magnifique Feast (Cata)
	[87915], -- Goblin Barbecue (Cata)
	[104958], -- Pandaren Banquet (MoP)
	[105193], -- Great Pandaren Banquet (MoP)
	[126492], -- Banquet of the Grill (MoP)
	[126494], -- Great Banquet of the Grill (MoP)
	[126495], -- Banquet of the Wok (MoP)
	[126496], -- Great Banquet of the Wok (MoP)
	[126497], -- Banquet of the Pot (MoP)
	[126498], -- Great Banquet of the Pot (MoP)
	[126499], -- Banquet of the Steamer (MoP)
	[126500], -- Great Banquet of the Steamer (MoP)
	[126501], -- Banquet of the Oven (MoP)
	[126502], -- Great Banquet of the Oven (MoP)
	[126503], -- Banquet of the Brew (MoP)
	[126504], -- Great Banquet of the Brew (MoP)
	[160740], -- Feast of Blood (WoD)
	[160914], -- Feast of the Waters (WoD)
	[175215], -- Savage Feast (WoD)
	[185706], -- Fancy Darkmoon Feast (DMF)
	[185709], -- Sugar-Crusted Fish Feast (DMF)
	[201351], -- Hearty Feast (Legion)
	[201352], -- Lavish Suramar Feast (Legion)
	[216333], -- Potato Stew Feast (BattleGround (Legion))
	[216347], -- Feast of Ribs (Battleground (Legion)) 
	[251254], -- Feast of the Fishes (Legion)
	[259409], -- Gallery Banquet (BFA)
	[259410], -- Bountiful Captain's Feast (BFA)
	[286050], -- Sanguinated Feast (BFA)
	[297048], -- Famine Evaluator And Snack Table (BFA)
	[308458], -- Surprisingly Palatable Feast (SL)
	[308462], -- Feast of Gluttonous Hedonism (SL)
	}

cauldrenIDs = {
	[41443], -- Cauldron of Major Arcane Protection (TBC)
	[41494], -- Cauldron of Major Fire Protection (TBC)
	[41495], -- Cauldron of Major Frost Protection (TBC)
	[41497], -- Cauldron of Major Nature Protection (TBC)
	[41498], -- Cauldron of Major Shadow Protection (TBC)
	[92649], -- Cauldron of Battle (Cata)
	[92712], -- Big Cauldron of Battle (Cata)
	[188036], -- Spirit Cauldron (Legion)
	[276972], -- Mystical Cauldron (BFA)
	[298861], -- Greater Mystical Cauldron (BFA)
	[307157], -- Eternal Cauldron (SL)
	}

repairIDs = {
	[22700], -- Field Repair Bot 74A (WoW)
	[44389], -- Field Repair Bot 110G (TBC)
	[54711], -- Scrapbopt Consctruction Kit (LK)
	[67826], -- Jeeves (LK)
	[157066], -- Walter (WoD)
	[199109], -- Auto-Hammer (Legion)
	}

codexIDs = {
	[226241], -- Codex of the Tranquil Min (LEgion)
	[256230], -- Codex of the Quiet Mind (BFA)
	[324029], -- Codex of the Still Mind (SL)
	}

summonkID = {
	[698], -- Ritual of Summoning (Warlock)
	}

miscIDs = {
	[29893], -- Creat Soulwell (Warlock)
	[42955], -- Conjure Refreshment (Mage)
	[255473], -- Interdimensional Companion Repository (BFA)
	[256153], -- Deployable Attire Rearranger (BFA)
	}

function piaEvents_table.eventFrame:COMBAT_LOG_EVENT_UNFILTERED()
	local _, subevent, _, _, sourceName, _, _, _, destinationName, _, _, spellID, spellName = CombatLogGetCurrentEventInfo()
	local message
	if subevent == "SPELL_CAST_START" then
		if feastIDs[spellID] or cauldrenIDs[spellID] or repairIDs[spellID] or codexIDs[spellID] or miscIDs[spellID] then
			messgae = sourceName .. " just placed a " .. spellName
		elseif summonIDs[spellID] then
			message = sourceName .. " is casting " .. spellName
		end
		SendChatMessage(message, INSTANCE_CHAT)
	end
end

function piaEvents_table.eventFrame:PLAYER_REGEN_ENABLED()
	piaEvents_table.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

function piaEvents_table.eventFrame:PLAYER_REGEN_DISABLED()
	piaEvents_table.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")