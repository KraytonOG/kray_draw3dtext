-- Configurable 3D Menu/Text Display System

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

-- Render a single menu
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
    
    -- Draw header
    Draw3DText(coords.x, coords.y, coords.z + headerOffsetZ, header.text, header.scale, 
        header.color[1], header.color[2], header.color[3], header.color[4], font)
    
    -- Draw categories if they exist
    if categories and #categories > 0 then
        local numCategories = #categories
        local startOffset = -((numCategories - 1) / 2) * columnSpacing
        
        for colIndex, category in ipairs(categories) do
            local colOffset = startOffset + ((colIndex - 1) * columnSpacing)
            local colX, colY = GetRotatedOffset(coords, 0, colOffset, rotation)
            local currentZ = headerOffsetZ - 0.3
            
            -- Category header
            Draw3DText(colX, colY, coords.z + currentZ, category.name, 1.2,
                category.color[1], category.color[2], category.color[3], category.color[4], font)
            currentZ = currentZ - categorySpacing
            
            -- Items
            for i, item in ipairs(category.items) do
                local z = coords.z + currentZ - ((i - 1) * itemSpacing)
                local text = item.price 
                    and string.format("%s ~g~%s", item.name, item.price)
                    or item.name
                local itemColor = item.color or {255, 255, 255, 255}
                Draw3DText(colX, colY, z, text, 0.9, 
                    itemColor[1], itemColor[2], itemColor[3], itemColor[4], font)
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
        return true
    end
    return false
end)