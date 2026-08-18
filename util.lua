if not _G.canaccessvalue then
    if issecretvalue then
        _G.canaccessvalue = function(value)
            return not issecretvalue(value)
        end
    else
        _G.canaccessvalue = function(value)
            return true
        end
    end
end
