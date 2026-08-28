local name, hipe = ...

local settings = hipe.settings
local blocker = hipe.blocker
local callout = hipe.callout

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
    -- aggressively queue a couple of aura removals after login/zone-change
    for i = 1, 5 do
        C_Timer.After(i, function()
            blocker:removeAllStandard()
        end)
    end
    -- dismiss the professions tutorial frame if enabled in settings
    if HipeConf.dismissMicroMenuCallout then
        C_Timer.After(1, function()
            callout:CloseMicroMenuProfessionCallout()
        end)
    end
end

function frame:UNIT_AURA(target, updateInfo)
	-- skip events for other units, or when the update table is a read-protected secret
	if target ~= "player" or not canaccessvalue(updateInfo) then
		return
	end

	-- the aura list was fully rebuilt (login/zone change): always clear standard auras here,
	-- even with instant-hide off, since no profession activity is in progress to wait on
	local ok, isFull = pcall(function() return updateInfo.isFullUpdate end)
	if ok and isFull then
		blocker:removeAllStandard()
		return
	end

	-- with instant-hide off, auras are removed later once the activity finishes, so do nothing here
	if not (HipeConf and HipeConf.instantHide) then
		return
	end

	-- resolve instance ids to aura data and remove any that match a blocked spell
	blocker:removeByInstanceID(target, updateInfo.updatedAuraInstanceIDs)
	blocker:removeByInstanceID(target, updateInfo.addedAuraInstanceIDs)

	-- iterate the added auras payload and remove any matching a blocked spell (guard against secrets)
	if canaccessvalue(updateInfo.addedAuras) and type(updateInfo.addedAuras) == "table" then
		pcall(function()
			for _, auraData in pairs(updateInfo.addedAuras) do
				blocker:removeAuraData(auraData)
			end
		end)
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
