local _, hipe = ...

local issecretvalue, issecrettable, canaccesstable = issecretvalue, issecrettable, canaccesstable

local aura = {
    player = "player",
    filter = "HELPFUL|CANCELABLE",
}

function aura:remove(spellId)
    if InCombatLockdown() or issecretvalue(spellId) then
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
    if ok and buffData and canaccesstable(buffData) and not issecrettable(buffData) then
        local idx = buffData.index
        if not issecretvalue(idx) then
            return idx
        end
    end
    return nil
end

hipe.aura = aura