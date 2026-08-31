local _, hipe = ...

local issecretvalue, issecrettable, canaccesstable = issecretvalue, issecrettable, canaccesstable

local aura = {
    player = "player",
}

function aura:remove(spellId)
    if InCombatLockdown() or issecretvalue(spellId) then
        return
    end
    local instanceId = self:find(spellId)
    if (instanceId) then
      pcall(C_UnitAuras.CancelAuraByInstanceID, self.player, instanceId)
    end
end

function aura:find(spellId)
    if InCombatLockdown() then
        return nil  -- bail out in combat
    end
    local ok, buffData = pcall(C_UnitAuras.GetPlayerAuraBySpellID, spellId)
    if ok and buffData and canaccesstable(buffData) and not issecrettable(buffData) then
        local instanceId = buffData.auraInstanceID
        if not issecretvalue(instanceId) then
          return instanceId
        end
    end
    return nil
end

hipe.aura = aura
