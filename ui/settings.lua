local name, hipe = ...

local settings = {
    defaults = {
        instantHide = false,
        ignoreFishing = false,
        dismissMicroMenuCallout = false,
    }
}

function settings:Init()
    self.category, self.layout = Settings.RegisterVerticalLayoutCategory(name)
    self.category.ID = name

    self.layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(hipe.settingsTitle))
    self:CreateProxiedCheckBox(
        hipe.instantHideText,
        hipe.instantHideHint,
        "instantHide"
    )
    self:CreateProxiedCheckBox(
        hipe.ignoreFishingText,
        hipe.ignoreFishingHint,
        "ignoreFishing"
    )
    self:CreateProxiedCheckBox(
        hipe.dismissMicroMenuCalloutText,
        hipe.dismissMicroMenuCalloutHint,
        "dismissMicroMenuCallout"
    )

    Settings.RegisterAddOnCategory(self.category)
end

function settings:CreateProxiedCheckBox(text, tooltip, variable)
    local setting = Settings.RegisterAddOnSetting(self.category, variable, variable, HipeConf,
        Settings.VarType.Boolean, text, self.defaults[variable])
    Settings.CreateCheckbox(self.category, setting, tooltip)
end

hipe.settings = settings