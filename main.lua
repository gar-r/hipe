local name, hipe = ...

local settings = hipe.settings
local blocker = hipe.blocker

---@class Frame
local frame = CreateFrame("Frame")
frame:RegisterUnitEvent("UNIT_AURA", "player")
frame:RegisterUnitEvent("UNIT_SPELLCAST_STOP", "player")
frame:RegisterUnitEvent("UNIT_SPELLCAST_CHANNEL_STOP", "player")
frame:RegisterEvent("PLAYER_REGEN_ENABLED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, ...)
	self[event](self, ...)
end)

function frame:ADDON_LOADED(addonName)
	if name == addonName then
		HipeConf = HipeConf or settings.defaults
		settings:Init()
	end
end

function frame:PLAYER_ENTERING_WORLD()
    blocker:removeAllStandard()
end

function frame:UNIT_AURA(_, updateInfo)
	if HipeConf.instantHide then
		if updateInfo and updateInfo.addedAuras then
			for _, aura in pairs(updateInfo.addedAuras) do
				blocker:removeIfBlocked(aura.spellId)
			end
		end
	end
end

function frame:UNIT_SPELLCAST_STOP()
	blocker:removeAllStandard()
end

function frame:UNIT_SPELLCAST_CHANNEL_STOP()
	blocker:removeAllStandard()
	if not HipeConf.ignoreFishing then
		blocker:removeFishing()
	end
end

function frame:PLAYER_REGEN_ENABLED()
	blocker:removeAllStandard()
end
