-- Draw 3D Text Function with rotation and font support
function Draw3DText(x, y, z, text, scale, r, g, b, a, font)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    
    local fov = (1 / GetGameplayCamFov()) * 100
    local scaleCalc = ((1 / dist) * scale) * fov
    
    if onScreen then
        SetTextScale(0.0 * scaleCalc, 0.55 * scaleCalc)
        SetTextFont(font or Config.DefaultFont)
        SetTextProportional(1)
        SetTextColour(r or 255, g or 255, b or 255, a or 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

-- Draw interaction prompt (2D on screen)
function DrawPrompt(text)
    SetTextFont(4)
    SetTextScale(0.0, 0.4)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.5, 0.9)
end

-- Calculate rotated offset position
function GetRotatedOffset(baseCoords, offsetX, offsetY, rotation)
    local rad = math.rad(rotation or 0)
    local cosR = math.cos(rad)
    local sinR = math.sin(rad)
    
    local newX = baseCoords.x + (offsetX * cosR) - (offsetY * sinR)
    local newY = baseCoords.y + (offsetX * sinR) + (offsetY * cosR)
    
    return newX, newY
end

-- Handle interaction
function HandleInteraction(interaction, name)
    if not interaction or not interaction.enabled then return end
    
    DrawPrompt(interaction.prompt)
    
    if IsControlJustReleased(0, interaction.key) then
        if interaction.eventType == "server" then
            TriggerServerEvent(interaction.event, name)
        else
            TriggerEvent(interaction.event, name)
        end
    end
end

-- Split category items into columns based on maxItemsPerColumn
function SplitCategoryIntoColumns(category, maxItemsPerColumn)
    local columns = {}
    local items = category.items
    local totalItems = #items
    
    if totalItems <= maxItemsPerColumn then
        -- No wrapping needed
        table.insert(columns, {
            name = category.name,
            color = category.color,
            items = items,
            showHeader = true
        })
    else
        -- Split into multiple columns
        local numColumns = math.ceil(totalItems / maxItemsPerColumn)
        
        for col = 1, numColumns do
            local startIdx = ((col - 1) * maxItemsPerColumn) + 1
            local endIdx = math.min(col * maxItemsPerColumn, totalItems)
            local columnItems = {}
            
            for i = startIdx, endIdx do
                table.insert(columnItems, items[i])
            end
            
            table.insert(columns, {
                name = category.name,
                color = category.color,
                items = columnItems,
                showHeader = true -- Show header on all columns
            })
        end
    end
    
    return columns
end

-- Render a single menu with column wrapping support
function RenderMenu(menu, playerCoords)
    local coords = menu.coords
    local header = menu.header
    local categories = menu.categories
    local rotation = menu.rotation or 0.0
    local font = menu.font or Config.DefaultFont
    local columnSpacing = menu.columnSpacing or 1.0
    local itemSpacing = menu.itemSpacing or Config.DefaultItemSpacing
    local categorySpacing = menu.categorySpacing or Config.DefaultCategorySpacing
    local headerOffsetZ = header.offsetZ or 1.5
    local maxItemsPerColumn = menu.maxItemsPerColumn or Config.MaxItemsPerColumn or 10
    
    -- Draw header
    Draw3DText(coords.x, coords.y, coords.z + headerOffsetZ, header.text, header.scale, 
        header.color[1], header.color[2], header.color[3], header.color[4], font)
    
    -- Process categories with column wrapping
    if categories and #categories > 0 then
        -- Calculate total columns needed
        local totalColumns = 0
        for _, category in ipairs(categories) do
            local itemCount = #category.items
            totalColumns = totalColumns + math.ceil(itemCount / maxItemsPerColumn)
        end
        
        local startOffset = ((totalColumns - 1) / 2) * columnSpacing
        local currentColumn = 0
        
        -- Render each category in order
        for _, category in ipairs(categories) do
            local categoryColumns = SplitCategoryIntoColumns(category, maxItemsPerColumn)
            
            -- Render each wrapped column for this category
            for _, column in ipairs(categoryColumns) do
                local colOffset = startOffset - (currentColumn * columnSpacing)
                local colX, colY = GetRotatedOffset(coords, 0, colOffset, rotation)
                local currentZ = headerOffsetZ - 0.3
                
                -- Category header
                if column.showHeader then
                    Draw3DText(colX, colY, coords.z + currentZ, column.name, 1.2,
                        column.color[1], column.color[2], column.color[3], column.color[4], font)
                end
                currentZ = currentZ - categorySpacing
                
                -- Items
                for i, item in ipairs(column.items) do
                    local z = coords.z + currentZ - ((i - 1) * itemSpacing)
                    local text = item.price 
                        and string.format("%s ~g~%s", item.name, item.price)
                        or item.name
                    local itemColor = item.color or {255, 255, 255, 255}
                    Draw3DText(colX, colY, z, text, 0.9, 
                        itemColor[1], itemColor[2], itemColor[3], itemColor[4], font)
                end
                
                currentColumn = currentColumn + 1
            end
        end
    end
    
    -- Handle interaction if close enough
    if menu.interaction and menu.interaction.enabled then
        local interactDist = menu.interaction.distance or Config.DefaultInteractDistance
        local dist = #(playerCoords - coords)
        if dist < interactDist then
            HandleInteraction(menu.interaction, menu.name)
        end
    end
end

-- Render standalone text display
function RenderTextDisplay(display, playerCoords)
    local coords = display.coords
    local rotation = display.rotation or 0.0
    local font = display.font or Config.DefaultFont
    
    for _, line in ipairs(display.lines) do
        local offsetX = line.offsetX or 0
        local offsetY = line.offsetY or 0
        local posX, posY = GetRotatedOffset(coords, offsetX, offsetY, rotation)
        
        Draw3DText(posX, posY, coords.z + (line.offsetZ or 0), 
            line.text, line.scale,
            line.color[1], line.color[2], line.color[3], line.color[4], font)
    end
    
    -- Handle interaction if close enough
    if display.interaction and display.interaction.enabled then
        local interactDist = display.interaction.distance or Config.DefaultInteractDistance
        local dist = #(playerCoords - coords)
        if dist < interactDist then
            HandleInteraction(display.interaction, display.lines[1] and display.lines[1].text or "display")
        end
    end
end

-- Main Thread
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())
        
        -- Process menus
        for _, menu in ipairs(Config.Menus) do
            local dist = #(playerCoords - menu.coords)
            local displayDist = menu.displayDistance or Config.DefaultDisplayDistance
            
            if dist < displayDist then
                sleep = 0
                RenderMenu(menu, playerCoords)
            end
        end
        
        -- Process standalone text displays
        for _, display in ipairs(Config.TextDisplays) do
            local dist = #(playerCoords - display.coords)
            local displayDist = display.displayDistance or Config.DefaultDisplayDistance
            
            if dist < displayDist then
                sleep = 0
                RenderTextDisplay(display, playerCoords)
            end
        end
        
        Citizen.Wait(sleep)
    end
end)

-- Export functions for other resources to use
exports('AddMenu', function(menuData)
    table.insert(Config.Menus, menuData)
end)

exports('RemoveMenu', function(name)
    for i, menu in ipairs(Config.Menus) do
        if menu.name == name then
            table.remove(Config.Menus, i)
            return true
        end
    end
    return false
end)

exports('AddTextDisplay', function(displayData)
    table.insert(Config.TextDisplays, displayData)
end)

exports('RemoveTextDisplay', function(index)
    if Config.TextDisplays[index] then
        table.remove(Config.TextDisplays, index)
        return false
    end
    return false
end)
