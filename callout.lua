local _, hipe = ...

local callout = {}

function callout:CloseMicroMenuProfessionCallout()
    local tip = self:getProfessionCallout()
    if tip then
        tip:Close()
    end
end

function callout:getProfessionCallout()
    for helpTip in HelpTip.framePool:EnumerateActive() do
        if helpTip and helpTip.info then
            local info = helpTip.info
            if info.system == "MicroButtons" then
                if info.callbackArg
                    and info.callbackArg.commandName
                    and info.callbackArg.commandName == "TOGGLEPROFESSIONBOOK" then
                    return helpTip
                end
            end
        end
    end
end

hipe.callout = callout
