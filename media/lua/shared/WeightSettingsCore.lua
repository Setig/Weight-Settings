require "WeightSettingsLogger.lua"

WeightSettings.core = {}

WeightSettings.core.players = {}
WeightSettings.core.inventoryItems = {}
WeightSettings.core.isoObjects = {}


WeightSettings.core.updatePlayer = function(player)
    local isFirstUpdate = false
    if not WeightSettings.core.players[player] then
        WeightSettings.core.players[player] = {}
        isFirstUpdate = true
    end

    local playerData = WeightSettings.core.players[player]

    if isFirstUpdate then
        playerData.originalMaxWeightBase = player:getMaxWeightBase()
    end

    -- Max weight base
    if playerData.originalMaxWeightBase > 0 then
        player:setMaxWeightBase(math.ceil(playerData.originalMaxWeightBase * SandboxVars.WeightSettings.PlayersMaxBaseWeightMultiplier))
    end
end


WeightSettings.core.updateInventoryItem = function(inventoryItem)
    local isFirstUpdate = false
    if not WeightSettings.core.inventoryItems[inventoryItem] then
        WeightSettings.core.inventoryItems[inventoryItem] = {}
        isFirstUpdate = true
    end

    local inventoryItemData = WeightSettings.core.inventoryItems[inventoryItem]

    item = inventoryItem:getScriptItem()

    if isFirstUpdate then
        inventoryItemData.originalWeight = inventoryItem:getWeight()
        inventoryItemData.originalWeightEmpty = item:getWeightEmpty()
        if inventoryItem:getCategory() == "Container" then
            inventoryItemData.originalCapacity = inventoryItem:getCapacity()
            inventoryItemData.originalWeightReduction = inventoryItem:getWeightReduction()
        end
    end

    -- Weight
    if inventoryItemData.originalWeight > 0 then
        item:DoParam("Weight = " .. inventoryItemData.originalWeight * SandboxVars.WeightSettings.ItemsWeightMultiplier)
    end

    -- Item empty weight
    if inventoryItemData.originalWeightEmpty > 0 then
        item:DoParam("WeightEmpty = " .. inventoryItemData.originalWeightEmpty * SandboxVars.WeightSettings.ItemsWeightMultiplier)
    end

    if inventoryItem:getCategory() == "Container" then
        -- Container capacity
        if inventoryItemData.originalCapacity > 0 then
            item:DoParam("Capacity = " .. math.ceil(inventoryItemData.originalCapacity * SandboxVars.WeightSettings.ContainersCapacityMultiplier))
        end

        -- Container weight reduction
        if inventoryItemData.originalWeightReduction > 0 then
            item:DoParam("WeightReduction = " .. math.max(math.min(math.ceil(inventoryItemData.originalWeightReduction * SandboxVars.WeightSettings.ContainersWeightReductionMultiplier), 100), 0))
        end
    end
end


WeightSettings.core.updateIsoObject = function(isoObject)
    local isFirstUpdate = false
    if not WeightSettings.core.isoObjects[isoObject] then
        WeightSettings.core.isoObjects[isoObject] = {}
        isFirstUpdate = true
    end

    local isoObjectData = WeightSettings.core.isoObjects[isoObject]

    local propertyContainer = isoObject:getProperties()
    if propertyContainer then
        if propertyContainer:Is("PickUpWeight") then
            if isFirstUpdate then
                isoObjectData.originalPickUpWeight = propertyContainer:Val("PickUpWeight")
            end

            if isoObjectData.originalPickUpWeight then
                if isoObjectData.originalPickUpWeight ~= "0" then
                    local newWeight = tostring(math.max(math.floor(tonumber(isoObjectData.originalPickUpWeight) * SandboxVars.WeightSettings.ItemsWeightMultiplier), 10))
                    if isoObjectData.originalPickUpWeight ~= newWeight then
                        propertyContainer:Set("PickUpWeight", newWeight)

                        local postWeight = propertyContainer:Val("PickUpWeight")

                        if newWeight ~= postWeight then
                            local correctedPostWeight = tostring(math.ceil(tonumber(newWeight) / 10) * 10)
                            propertyContainer:Set("PickUpWeight", correctedPostWeight)

                            local postPostWeight = propertyContainer:Val("PickUpWeight")
                            if postPostWeight ~= correctedPostWeight then
                                -- Return back to old pick up weight
                                WeightSettings.logger.error("Failed to change pick up weight property for isoObject:\"%s\"!", isoObject:toString())
                                propertyContainer:Set("PickUpWeight", isoObjectData.originalPickUpWeight)
                            end
                        end
                    end
                end
            end
        elseif propertyContainer:Is("CustomName") then
            -- Fixing PickUpWeight for "Road Cone": add PickUpWeight property!
            if propertyContainer:Val("CustomName") == "Road Cone" then
                if isFirstUpdate then
                    isoObjectData.originalPickUpWeight = "50"
                end

                if isoObjectData.originalPickUpWeight then
                    if isoObjectData.originalPickUpWeight ~= "0" then
                        local newWeight = tostring(math.max(math.floor(tonumber(isoObjectData.originalPickUpWeight) * SandboxVars.WeightSettings.ItemsWeightMultiplier), 10))
                        if isoObjectData.originalPickUpWeight ~= newWeight then
                            propertyContainer:Set("PickUpWeight", newWeight)

                            local postWeight = propertyContainer:Val("PickUpWeight")

                            if newWeight ~= postWeight then
                                local correctedPostWeight = tostring(math.ceil(tonumber(newWeight) / 10) * 10)
                                propertyContainer:Set("PickUpWeight", correctedPostWeight)

                                local postPostWeight = propertyContainer:Val("PickUpWeight")
                                if postPostWeight ~= correctedPostWeight then
                                    -- Return back to old pick up weight
                                    WeightSettings.logger.error("Failed to change pick up weight property for isoObject:\"%s\"!", isoObject:toString())
                                    propertyContainer:Set("PickUpWeight", isoObjectData.originalPickUpWeight)
                                end
                            end
                        end
                    end
                end
            end
        end

        -- Container capacity
        if propertyContainer:Is("ContainerCapacity") then
            if isFirstUpdate then
                isoObjectData.originalContainerCapacity = propertyContainer:Val("ContainerCapacity")
            end

            if isoObjectData.originalContainerCapacity then
                if isoObjectData.originalContainerCapacity ~= 0 then
                    local newCapacity = tostring(math.max(math.floor(tonumber(isoObjectData.originalContainerCapacity) * SandboxVars.WeightSettings.ContainersCapacityMultiplier), 1))
                    if isoObjectData.originalContainerCapacity ~= newCapacity then
                        propertyContainer:Set("ContainerCapacity", newCapacity)

                        local postCapacity = propertyContainer:Val("ContainerCapacity")

                        if newCapacity ~= postCapacity then
                            -- Return back to old capacity
                            WeightSettings.logger.error("Failed to change container capacity property for isoObject:\"%s\"!", isoObject:toString())
                            propertyContainer:Set("ContainerCapacity", isoObjectData.originalContainerCapacity)
                        end
                    end
                end
            end
        end
    end

    -- Check items on container
    itemContainer = isoObject:getItemContainer()
    if itemContainer then
        local inventoryItems = itemContainer:getItems()
        local inventoryItemsSize = inventoryItems:size()
        for i = 0, inventoryItemsSize - 1, 1 do
            WeightSettings.core.updateInventoryItem(inventoryItems:get(i))
        end
    end
end
