require "WeightSettingsCore.lua"
require "WeightSettingsOptions.lua"


WeightSettings.contexMenu = {}


WeightSettings.contexMenu.addOptionForPropertyContainer = function(context, menu, propertyContainer)
    if propertyContainer then
        if instanceof(propertyContainer, "PropertyContainer") then
            local propertiesOption = menu:addOption("Properties")

            local tooltip = ISWorldObjectContextMenu.addToolTip()
            tooltip:setName(getText("PropertyContainer info:"))
            tooltip.description = string.format("toString()=\"%s\"\n", propertyContainer:toString())

            local propertyNames = propertyContainer:getPropertyNames()
            local propertyNamesSize = propertyNames:size()
            if propertyNamesSize ~= 0 then
                for i = 0, propertyNamesSize - 1, 1 do
                    local propertyName = propertyNames:get(i)
                    tooltip.description = tooltip.description .. string.format("%s=\"%s\"", propertyName, propertyContainer:Val(propertyName))

                    if i ~= propertyNamesSize - 1 then
                        tooltip.description = tooltip.description .. "\n"
                    end
                end
            else
                tooltip.description = tooltip.description .. "No properties."
            end

            propertiesOption.toolTip = tooltip
        else
            menu:addOption(string.format("Unknow PropertyContainer \"%s\"!", propertyContainer:toString()))
        end
    else
        menu:addOption("PropertyContainer=\"nil\"!")
    end
end


WeightSettings.contexMenu.addOptionForIsoObject = function(context, menu, isoObject)
    if isoObject then
        if instanceof(isoObject, "IsoObject") then
            local isoObjectOption = menu:addOption(isoObject:toString())
            local isoObjectMenu = ISContextMenu:getNew(context)
            context:addSubMenu(isoObjectOption, isoObjectMenu)

            local tooltip = ISWorldObjectContextMenu.addToolTip()
            tooltip:setName(getText("IsoObject info:"))
            tooltip.description = string.format("toString()=\"%s\"\n" ..
                                                "getTextureName()=\"%s\"\n" ..
                                                "getType()=\"%s\"",
                                                isoObject:toString(),
                                                isoObject:getTextureName(),
                                                tostring(isoObject:getType()))
            isoObjectOption.toolTip = tooltip

            local weightSettingsDataOption = isoObjectMenu:addOption("WeightSettings data")

            local tooltip = ISWorldObjectContextMenu.addToolTip()
            tooltip:setName(getText("WeightSettings info:"))

            local isoObjectData = WeightSettings.core.isoObjects[isoObject]

            if isoObjectData then
                if isoObjectData.originalPickUpWeight then
                    tooltip.description = tooltip.description .. string.format("originalPickUpWeight=\"%s\"\n",
                                                                               isoObjectData.originalPickUpWeight)
                else
                    tooltip.description = tooltip.description .. "originalPickUpWeight=\"nil\"\n"
                end

                if isoObjectData.originalContainerCapacity then
                    tooltip.description = tooltip.description .. string.format("originalContainerCapacity=\"%s\"\n",
                                                                               isoObjectData.originalContainerCapacity)
                else
                    tooltip.description = tooltip.description .. "originalContainerCapacity=\"nil\"\n"
                end
            else
                tooltip.description = "nil"
            end

            weightSettingsDataOption.toolTip = tooltip

            WeightSettings.contexMenu.addOptionForPropertyContainer(context, isoObjectMenu, isoObject:getProperties())

            local containersCount = isoObject:getContainerCount()
            if containersCount ~= 0 then
                local containersOption = isoObjectMenu:addOption("Containers")
                local containersMenu = ISContextMenu:getNew(context)
                context:addSubMenu(containersOption, containersMenu)

                for i = 0, containersCount - 1, 1 do
                    WeightSettings.contexMenu.addOptionForItemContainer(context, containersMenu, isoObject:getContainerByIndex(i))
                end
            else
                isoObjectMenu:addOption("No containers")
            end
        else
            menu:addOption(string.format("Unknow IsoObject \"%s\"!", isoObject:toString()))
        end
    else
        menu:addOption("IsoObject=\"nil\"!")
    end
end


WeightSettings.contexMenu.addOptionForItemContainer = function(context, menu, itemContainer)
    if itemContainer then
        if instanceof(itemContainer, "ItemContainer") then
            local itemContainerOption = menu:addOption(itemContainer:toString())
            local itemContainerMenu = ISContextMenu:getNew(context)
            context:addSubMenu(itemContainerOption, itemContainerMenu)

            local tooltip = ISWorldObjectContextMenu.addToolTip()
            tooltip:setName(getText("ItemContainer info:"))
            tooltip.description = string.format("toString()=\"%s\"\n" ..
                                                "getCapacity()=\"%s\"\n" ..
                                                "getCapacityWeight()=\"%s\"\n" ..
                                                "getContentsWeight()=\"%s\"\n" ..
                                                "getMaxWeight()=\"%s\"\n" ..
                                                "getWeight()=\"%s\"\n" ..
                                                "getWeightReduction()=\"%s\"",
                                                itemContainer:toString(),
                                                itemContainer:getCapacity(),
                                                itemContainer:getCapacityWeight(),
                                                itemContainer:getContentsWeight(),
                                                itemContainer:getMaxWeight(),
                                                itemContainer:getWeight(),
                                                itemContainer:getWeightReduction())
            itemContainerOption.toolTip = tooltip

            local inventoryItems = itemContainer:getItems()
            local inventoryItemsSize = inventoryItems:size()
            if inventoryItemsSize ~= 0 then
                local itemsOption = itemContainerMenu:addOption("Inventory items")
                local itemsMenu = ISContextMenu:getNew(context)
                context:addSubMenu(itemsOption, itemsMenu)

                for i = 0, inventoryItemsSize - 1, 1 do
                    WeightSettings.contexMenu.addOptionForInventoryItem(context, itemsMenu, inventoryItems:get(i))
                end
            else
                itemContainerMenu:addOption("No inventory items")
            end
        else
            menu:addOption(string.format("Unknow ItemContainer \"%s\"!", itemContainer:toString()))
        end
    else
        menu:addOption("ItemContainer=\"nil\"!")
    end
end


WeightSettings.contexMenu.addOptionForIsoWorldInventoryObject = function(context, menu, isoWorldInventoryObject)
    if isoWorldInventoryObject then
        if instanceof(isoWorldInventoryObject, "IsoWorldInventoryObject") then
            local isoWorldInventoryObjectOption = menu:addOption(isoWorldInventoryObject:toString())
            local isoWorldInventoryObjectMenu = ISContextMenu:getNew(context)
            context:addSubMenu(isoWorldInventoryObjectOption, isoWorldInventoryObjectMenu)

            WeightSettings.contexMenu.addOptionForInventoryItem(context, isoWorldInventoryObjectMenu, isoWorldInventoryObject:getItem())
        else
            menu:addOption(string.format("Unknow IsoWorldInventoryObject \"%s\"!", isoWorldInventoryObject:toString()))
        end
    else
        menu:addOption("IsoWorldInventoryObject=\"nil\"!")
    end
end


WeightSettings.contexMenu.addOptionForAttachedItems = function(context, menu, attachedItems)
    if isoMovingObject then
        if instanceof(isoMovingObject, "AttachedItems") then
            for i = 0, inventoryItemsSize - 1, 1 do
                WeightSettings.contexMenu.addOptionForInventoryItem(context, menu, attachedItems:getItemByIndex(i))
            end
        else
            menu:addOption(string.format("Unknow AttachedItems \"%s\"!", attachedItems:toString()))
        end
    else
        menu:addOption("AttachedItems=\"nil\"!")
    end
end


WeightSettings.contexMenu.addOptionForIsoMovingObject = function(context, menu, isoMovingObject)
    if isoMovingObject then
        if instanceof(isoMovingObject, "IsoPlayer") then
            local isoPlayerOption = menu:addOption(isoMovingObject:toString())
            local isoPlayerMenu = ISContextMenu:getNew(context)
            context:addSubMenu(isoPlayerOption, isoPlayerMenu)

            local tooltip = ISWorldObjectContextMenu.addToolTip()
            tooltip:setName(getText("IsoPlayer info:"))
            tooltip.description = string.format("toString()=\"%s\"\n" ..
                                                "getMaxWeightDelta()=\"%s\"\n" ..
                                                "getDeferredRotationWeight()=\"%s\"\n" ..
                                                "getInventoryWeight()=\"%s\"\n" ..
                                                "getMaxWeightBase()=\"%s\"\n" ..
                                                "getMaxWeight()=\"%s\"\n" ..
                                                "getWeightMod()=\"%s\"\n" ..
                                                "getWeight()=\"%s\"",
                                                isoMovingObject:toString(),
                                                isoMovingObject:getMaxWeightDelta(),
                                                isoMovingObject:getDeferredRotationWeight(),
                                                isoMovingObject:getInventoryWeight(),
                                                isoMovingObject:getMaxWeightBase(),
                                                isoMovingObject:getMaxWeight(),
                                                isoMovingObject:getWeightMod(),
                                                isoMovingObject:getWeight())
            isoPlayerOption.toolTip = tooltip

            local weightSettingsDataOption = isoPlayerMenu:addOption("WeightSettings data")

            local tooltip = ISWorldObjectContextMenu.addToolTip()
            tooltip:setName(getText("WeightSettings info:"))

            local playerData = WeightSettings.core.players[isoMovingObject]

            if playerData then
                if playerData.originalMaxWeightBase then
                    tooltip.description = tooltip.description .. string.format("originalMaxWeightBase=\"%s\"\n",
                                                                               playerData.originalMaxWeightBase)
                else
                    tooltip.description = tooltip.description .. "originalMaxWeightBase=\"nil\"\n"
                end
            else
                tooltip.description = "nil"
            end

            weightSettingsDataOption.toolTip = tooltip

            WeightSettings.contexMenu.addOptionForItemContainer(context, isoPlayerMenu, isoMovingObject:getInventory())

            local attachedItems = isoMovingObject:getAttachedItems()
            if not attachedItems:isEmpty() then
                local attachedItemsOption = isoPlayerMenu:addOption("Attached items")
                local attachedItemsMenu = ISContextMenu:getNew(context)
                context:addSubMenu(attachedItemsOption, attachedItemsMenu)

                WeightSettings.contexMenu.addOptionForAttachedItems(context, attachedItemsMenu, attachedItems)
            else
                isoPlayerMenu:addOption("No attached items")
            end

            local equippedItemsOption = isoPlayerMenu:addOption("Equipped items")
            local equippedItemsMenu = ISContextMenu:getNew(context)
            context:addSubMenu(equippedItemsOption, equippedItemsMenu)

            WeightSettings.contexMenu.addOptionForInventoryItem(context, equippedItemsMenu, isoMovingObject:getClothingItem_Back())
            WeightSettings.contexMenu.addOptionForInventoryItem(context, equippedItemsMenu, isoMovingObject:getClothingItem_Feet())
            WeightSettings.contexMenu.addOptionForInventoryItem(context, equippedItemsMenu, isoMovingObject:getClothingItem_Hands())
            WeightSettings.contexMenu.addOptionForInventoryItem(context, equippedItemsMenu, isoMovingObject:getClothingItem_Head())
            WeightSettings.contexMenu.addOptionForInventoryItem(context, equippedItemsMenu, isoMovingObject:getClothingItem_Legs())
            WeightSettings.contexMenu.addOptionForInventoryItem(context, equippedItemsMenu, isoMovingObject:getClothingItem_Torso())
            WeightSettings.contexMenu.addOptionForInventoryItem(context, equippedItemsMenu, isoMovingObject:getPrimaryHandItem())
            WeightSettings.contexMenu.addOptionForInventoryItem(context, equippedItemsMenu, isoMovingObject:getSecondaryHandItem())
        elseif instanceof(isoMovingObject, "BaseVehicle") then
            -- TODO: get vehicle parts
            local isoMovingObjectOption = menu:addOption(isoMovingObject:toString())

            local tooltip = ISWorldObjectContextMenu.addToolTip()
            tooltip:setName(getText("BaseVehicle info:"))
            tooltip.description = string.format("toString()=\"%s\"\n" ..
                                                "getWeight()=\"%s\"",
                                                isoMovingObject:toString(),
                                                isoMovingObject:getWeight())
            isoMovingObjectOption.toolTip = tooltip
        elseif instanceof(isoMovingObject, "IsoMovingObject") then
            local isoMovingObjectOption = menu:addOption(isoMovingObject:toString())

            local tooltip = ISWorldObjectContextMenu.addToolTip()
            tooltip:setName(getText("IsoMovingObject info:"))
            tooltip.description = string.format("toString()=\"%s\"\n" ..
                                                "getWeight()=\"%s\"",
                                                isoMovingObject:toString(),
                                                isoMovingObject:getWeight())
            isoMovingObjectOption.toolTip = tooltip
        else
            menu:addOption(string.format("Unknow IsoMovingObject \"%s\"!", isoMovingObject:toString()))
        end
    else
        menu:addOption("IsoMovingObject=\"nil\"!")
    end
end


WeightSettings.contexMenu.addOptionForInventoryItem = function(context, menu, inventoryItem)
    if inventoryItem then
        if instanceof(inventoryItem, "InventoryItem") then
            local inventoryItemOption = menu:addOption(inventoryItem:toString())
            local inventoryItemMenu = ISContextMenu:getNew(context)
            context:addSubMenu(inventoryItemOption, inventoryItemMenu)

            local tooltip = ISWorldObjectContextMenu.addToolTip()
            tooltip:setName(getText("InventoryItem info:"))

            tooltip.description = string.format("toString()=\"%s\"\n" ..
                                                "getCategory()=\"%s\"\n" ..
                                                "getType()=\"%s\"\n" ..
                                                "getActualWeight()=\"%s\"\n" ..
                                                "getEquippedWeight()=\"%s\"\n" ..
                                                "getExtraItemsWeight()=\"%s\"\n" ..
                                                "getHotbarEquippedWeight()=\"%s\"\n" ..
                                                "getUnequippedWeight()=\"%s\"\n" ..
                                                "getWeight()=\"%s\"\n" ..
                                                "isCustomWeight()=\"%s\"\n",
                                                inventoryItem:toString(),
                                                inventoryItem:getCategory(),
                                                inventoryItem:getType(),
                                                inventoryItem:getActualWeight(),
                                                inventoryItem:getEquippedWeight(),
                                                inventoryItem:getExtraItemsWeight(),
                                                inventoryItem:getHotbarEquippedWeight(),
                                                inventoryItem:getUnequippedWeight(),
                                                inventoryItem:getWeight(),
                                                tostring(inventoryItem:isCustomWeight()))

            if inventoryItem:getCategory() == "Container" then
                tooltip.description = tooltip.description .. string.format("getCapacity()=\"%s\"\n" ..
                                                                           "getWeightReduction()=\"%s\"\n",
                                                                           inventoryItem:getCapacity(),
                                                                           inventoryItem:getWeightReduction())
            else
                tooltip.description = tooltip.description .. "getCapacity()=\"none\"\n" ..
                                                             "getWeightReduction()=\"none\"\n"
            end

            if inventoryItem:getCategory() == "Food" then
                tooltip.description = tooltip.description .. string.format("getBaseHunger()=\"%s\"\n" ..
                                                                           "getCalories()=\"%s\"\n" ..
                                                                           "getCarbohydrates()=\"%s\"\n" ..
                                                                           "getProteins()=\"%s\"\n" ..
                                                                           "getLipids()=\"%s\"\n",
                                                                           inventoryItem:getBaseHunger(),
                                                                           inventoryItem:getCalories(),
                                                                           inventoryItem:getCarbohydrates(),
                                                                           inventoryItem:getProteins(),
                                                                           inventoryItem:getLipids())
            else
                tooltip.description = tooltip.description .. "getBaseHunger()=\"none\"\n" ..
                                                             "getCalories()=\"none\"\n" ..
                                                             "getCarbohydrates()=\"none\"\n" ..
                                                             "getProteins()=\"none\"\n"
            end

            local isoWorldInventoryObject = inventoryItem:getWorldItem()
            if isoWorldInventoryObject then
                tooltip.description = tooltip.description .. string.format("getWorldItem()=\"%s\"",
                                                                           isoWorldInventoryObject:toString())
            else
                tooltip.description = tooltip.description .. "getWorldItem()=\"nil\""
            end

            if instanceof(inventoryItem, "Moveable") then
                isoSpriteGrid = inventoryItem:getSpriteGrid()
                if isoSpriteGrid then
                    isoSprite = isoSpriteGrid:getAnchorSprite()
                    if isoSprite then
                        WeightSettings.contexMenu.addOptionForPropertyContainer(context, inventoryItemMenu, isoSprite:getProperties())
                    end
                else
                    local tmpOption = inventoryItemMenu:addOption("inventoryItem:getSpriteGrid()=\"nil\"")
                end
            end

            inventoryItemOption.toolTip = tooltip

            local weightSettingsDataOption = inventoryItemMenu:addOption("WeightSettings data")

            local tooltip = ISWorldObjectContextMenu.addToolTip()
            tooltip:setName(getText("WeightSettings info:"))

            local inventoryItemData = WeightSettings.core.inventoryItems[inventoryItem]

            if inventoryItemData then
                if inventoryItemData.originalWeight then
                    tooltip.description = tooltip.description .. string.format("originalWeight=\"%s\"\n",
                                                                               inventoryItemData.originalWeight)
                else
                    tooltip.description = tooltip.description .. "originalWeight=\"nil\"\n"
                end

                if inventoryItemData.originalWeightEmpty then
                    tooltip.description = tooltip.description .. string.format("originalWeightEmpty=\"%s\"\n",
                                                                               inventoryItemData.originalWeightEmpty)
                else
                    tooltip.description = tooltip.description .. "originalWeightEmpty=\"nil\"\n"
                end

                if inventoryItemData.originalCapacity then
                    tooltip.description = tooltip.description .. string.format("originalCapacity=\"%s\"\n",
                                                                               inventoryItemData.originalCapacity)
                else
                    tooltip.description = tooltip.description .. "originalCapacity=\"nil\"\n"
                end

                if inventoryItemData.originalWeightReduction then
                    tooltip.description = tooltip.description .. string.format("originalWeightReduction=\"%s\"\n",
                                                                               inventoryItemData.originalWeightReduction)
                else
                    tooltip.description = tooltip.description .. "originalWeightReduction=\"nil\"\n"
                end
            else
                tooltip.description = "nil"
            end

            weightSettingsDataOption.toolTip = tooltip

            item = inventoryItem:getScriptItem()

            if item then
                local itemOption = inventoryItemMenu:addOption("Item")

                local tooltip = ISWorldObjectContextMenu.addToolTip()
                tooltip:setName(getText("Item info:"))
                tooltip.description = string.format("toString()=\"%s\"\n" ..
                                                    "getTypeString()=\"%s\"\n" ..
                                                    "getActualWeight()=\"%s\"\n" ..
                                                    "getWeaponWeight()=\"%s\"\n" ..
                                                    "getWeightEmpty()=\"%s\"\n" ..
                                                    "getWeightWet()=\"%s\"",
                                                    item:toString(),
                                                    item:getTypeString(),
                                                    item:getActualWeight(),
                                                    item:getWeaponWeight(),
                                                    item:getWeightEmpty(),
                                                    item:getWeightWet())
                itemOption.toolTip = tooltip
            else
                inventoryItemMenu:addOption("No item")
            end
        else
            menu:addOption(string.format("Unknow InventoryItem \"%s\"!", inventoryItem:toString()))
        end
    else
        menu:addOption("InventoryItem=\"nil\"!")
    end
end


WeightSettings.contexMenu.onFillInventoryObjectContextMenu = function(playerIndex, context, items)
    if WeightSettings.options.showDebugMenu then
        local weightSettingsDebugOption = context:addOption("WeightSettings Debug")
        local weightSettingsDebugMenu = ISContextMenu:getNew(context)
        context:addSubMenu(weightSettingsDebugOption, weightSettingsDebugMenu)

        local itemsWeightMultiplier = SandboxVars.WeightSettings.ItemsWeightMultiplier
        for i, item in ipairs(items) do
            if not instanceof(item, "InventoryItem") then
                inventoryItem = item.items[1]
            end

            WeightSettings.contexMenu.addOptionForInventoryItem(context, weightSettingsDebugMenu, inventoryItem)
        end
    end
end


WeightSettings.contexMenu.onFillWorldObjectContextMenu = function(playerIndex, context, worldObjects, test)
    if WeightSettings.options.showDebugMenu then
        local weightSettingsDebugOption = context:addOption("WeightSettings Debug")
        local weightSettingsDebugMenu = ISContextMenu:getNew(context)
        context:addSubMenu(weightSettingsDebugOption, weightSettingsDebugMenu)

        for i, worldObject in ipairs(worldObjects) do
            local square = worldObject:getSquare()

            local squareOption = weightSettingsDebugMenu:addOption("Square " .. i)
            local squareMenu = ISContextMenu:getNew(context)
            context:addSubMenu(squareOption, squareMenu)

            if square then
                local isoLocalTemporaryObjects = square:getLocalTemporaryObjects()
                local isoLocalTemporaryObjectsSize = isoLocalTemporaryObjects:size()
                for j = 0, isoLocalTemporaryObjectsSize - 1, 1 do
                    WeightSettings.contexMenu.addOptionForIsoObject(context, squareMenu, isoLocalTemporaryObjects:get(j))
                end

                local isoMovingObjects = square:getMovingObjects()
                local isoMovingObjectsSize = isoMovingObjects:size()
                for j = 0, isoMovingObjectsSize - 1, 1 do
                    WeightSettings.contexMenu.addOptionForIsoMovingObject(context, squareMenu, isoMovingObjects:get(j))
                end

                local isoObjects = square:getObjects()
                local isoObjectsSize = isoObjects:size()
                for j = 0, isoObjectsSize - 1, 1 do
                    WeightSettings.contexMenu.addOptionForIsoObject(context, squareMenu, isoObjects:get(j))
                end

                local isoSpecialObjects = square:getSpecialObjects()
                local isoSpecialObjectsSize = isoSpecialObjects:size()
                for j = 0, isoLocalTemporaryObjectsSize - 1, 1 do
                    WeightSettings.contexMenu.addOptionForIsoObject(context, squareMenu, isoSpecialObjects:get(j))
                end

                local isoStaticMovingObjects = square:getStaticMovingObjects()
                local isoStaticMovingObjectsSize = isoStaticMovingObjects:size()
                for j = 0, isoStaticMovingObjectsSize - 1, 1 do
                    WeightSettings.contexMenu.addOptionForIsoMovingObject(context, squareMenu, isoMovingObjects:get(j))
                end

                local isoWorldInventoryObjects = square:getWorldObjects()
                local isoWorldInventoryObjectsSize = isoWorldInventoryObjects:size()
                for j = 0, isoWorldInventoryObjectsSize - 1, 1 do
                    WeightSettings.contexMenu.addOptionForIsoWorldInventoryObject(context, squareMenu, isoWorldInventoryObjects:get(j))
                end

                WeightSettings.contexMenu.addOptionForPropertyContainer(context, squareMenu, square:getProperties())
            end
        end
    end
end
