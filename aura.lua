local _, hipe = ...

local aura = {
    player = "player",
    filter = "HELPFUL|CANCELABLE",
}

function aura:remove(spellId)
    if InCombatLockdown() or not canaccessvalue(spellId) then
        return
    end
    local idx = self:find(spellId)
    if idx then
        pcall(CancelUnitBuff, self.player, idx, self.filter)
    end
end

function aura:find(spellId)
    if InCombatLockdown() then
        return nil  -- bail out in combat
    end
    local ok, buffData = pcall(C_UnitAuras.GetPlayerAuraBySpellID, spellId, self.filter)
    if ok
    and canaccessvalue(buffData)
    and canaccessvalue(buffData.index)
    then
        return buffData.index
    end
    return nil
end

hipe.aura = aura
