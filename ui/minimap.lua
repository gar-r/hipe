local _, hipe = ...

function Hipe_OnAddonCompartmentClick()
    if hipe and hipe.settings and hipe.settings.category then
        Settings.OpenToCategory(hipe.settings.category.ID)
    end
end
