local _, hipe = ...

local blocker = {
	standard = {
		[394003] = "Spark of Madness",
		[388658] = "Suited For Smithing",
		[394015] = "An Eye For Shine",
		[394008] = "A Looker's Charm",
		[394007] = "A Production-Grade Display",
		[394016] = "Artist's Duds",
		[394001] = "Sculpting Leather Finery",
		[391312] = "Wrapped Up In Weaving",
		[391775] = "What's Cookin', Good Lookin'?",
		[394005] = "A Cultivator's Colors",
		[394006] = "Rockin' Mining Gear",
		[394011] = "Dressed To Kill",
	},
	-- fishing auras should never be instantly removed, as their
	-- removal also prematurely ends the profession related activity
	fishing = {
		[394009] = "Fishing for Attention",
	},
}

local aura = hipe.aura

function blocker:removeIfBlocked(spellId)
	if canaccessvalue(spellId) and self.standard[spellId] then
		aura:remove(spellId)
	end
end

function blocker:removeAllStandard()
	for k in pairs(self.standard) do
		aura:remove(k)
	end
end

function blocker:removeFishing()
	for k in pairs(self.fishing) do
		aura:remove(k)
	end
end

hipe.blocker = blocker
