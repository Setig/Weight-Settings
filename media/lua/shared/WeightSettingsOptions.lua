require "WeightSettingsGlobal.lua"

WeightSettings.options = {
    showDebugMenu = false,
}

if ModOptions and ModOptions.getInstance then
    local settings = ModOptions:getInstance(WeightSettings.options, "WeightSettings", getText("UI_Options_WeightSettings"))

    local showDebugMenu = settings:getData("showDebugMenu")
    showDebugMenu.name = "UI_Options_WeightSettings_ShowDebugMenu_Name"
    showDebugMenu.tooltip = "UI_Options_WeightSettings_ShowDebugMenu_Tooltip"
end
