require "WeightSettingsCore.lua"
require "WeightSettingsContexMenu.lua"

WeightSettings.events = {}


WeightSettings.events.onCreatePlayer = function(playerIndex, player)
    WeightSettings.core.updatePlayer(player)
end


WeightSettings.events.onLoadMapZones = function()
    local items = getAllItems()
    local itemsSize = items:size()
    for i = 0, itemsSize - 1, 1 do
        WeightSettings.core.updateInventoryItem(items:get(i):InstanceItem(nil))
    end
end


WeightSettings.events.loadGridsquare = function(square)
    local isoObjects = square:getObjects()
    local isoObjectsSize = isoObjects:size()
    if isoObjectsSize ~= 0 then
        for i = 0, isoObjectsSize - 1, 1 do
            WeightSettings.core.updateIsoObject(isoObjects:get(i))
        end
    end
end


-- Main events
Events.OnCreatePlayer.Add(WeightSettings.events.onCreatePlayer)
Events.OnLoadMapZones.Add(WeightSettings.events.onLoadMapZones)
Events.LoadGridsquare.Add(WeightSettings.events.loadGridsquare)

-- Debug events
Events.OnFillInventoryObjectContextMenu.Add(WeightSettings.contexMenu.onFillInventoryObjectContextMenu)
Events.OnFillWorldObjectContextMenu.Add(WeightSettings.contexMenu.onFillWorldObjectContextMenu)
