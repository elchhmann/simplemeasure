#version 2

---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global


KEY_NEW = "m"
KEY_CANCEL = "rmb"
KEY_MENU = ","
KEY_SNAP = "shift"


function maxName(deltas)
    local copy = { }
    local names = { "deltaX", "deltaY", "deltaZ" }
    for _, v in ipairs(deltas) do table.insert(copy, v) end
    
    table.sort(copy, function (a, b) return a > b end)
    
    local result = { }
    
    for biggestKey, biggestValue in ipairs(copy) do
        for index, value in pairs(deltas) do
            if biggestValue == value then
                table.insert(result, names[index])
                break
            end
        end
        
        if #result == 2 then
            return result
        end
    end
end

function avg(a, b)
    return ((a+b)/2)
end

maxDist = 1000

menu = false

mode = "line"

measurements = {
    pos_a = Vec(0, 0, 0),
    set_a = false,
    pos_b = Vec(0, 0, 0),
    set_b = false,
    length = nil,
    type = nil
}

function round(value, decimals)
    local factor = 10 ^ decimals
    local scaled = value * factor

    if scaled >= 0 then
        return math.floor(scaled + 0.5) / factor
    else
        return math.ceil(scaled - 0.5) / factor
    end
end

function renderMeasurement(finished, i)
    opacity = finished and 1 or 0.2
        
    DebugCross(measurements[i].pos_a, 0, 1, 0, 1)

    if measurements[i].type == "line" then
        DebugLine(measurements[i].pos_a, measurements[i].pos_b, 1, 0, 0, opacity)
        DebugCross(measurements[i].pos_b, 0, 0, 1, opacity)
    end

    if measurements[i].type == "rect" then

        DebugCross(blevel, 0, 0, 1, 1)

        DebugCross(aprim, 0, 1, 1) -- cyan
        DebugCross(bprim, 1, 1, 0) -- yellow

        if orientation == "horizontal" then
            DebugLine(measurements[i].pos_a, aprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  a'(xb, ya, za)
            DebugLine(measurements[i].pos_a, bprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  b'(xa, ya, zb)

            DebugLine(blevel, aprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  a'(xb, ya, za)
            DebugLine(blevel, bprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  b'(xa, ya, zb)

            DebugCross(blevel, 0, 0, 1, 1)
        else
            DebugLine(measurements[i].pos_a, aprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  a'(xb, ya, za)
            DebugLine(measurements[i].pos_a, bprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  b'(xa, ya, zb)

            DebugLine(measurements[i].pos_b, aprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  a'(xb, ya, za)
                DebugLine(measurements[i].pos_b, bprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  b'(xa, ya, zb)

            DebugCross(measurements[i].pos_b, 0, 0, 1, 1)
        end
    end
end


function client.init()

end

function client.tick() -- Measurement math etc
    origin = GetCameraTransform().pos -- Position of the camera
    cameraDirection = TransformToParentVec(GetCameraTransform(), Vec(0, 0, -1)) -- Direction the camera is facing
    raycast, dist = QueryRaycast(origin, cameraDirection, maxDist) -- Raycast from the camera
    hitPosition = VecAdd(origin, VecScale(cameraDirection, dist)) -- Position where the raycast hits
    hitPositionSnapped = Vec(round(hitPosition[1],1), round(hitPosition[2],1), round(hitPosition[3],1))

    if InputPressed(KEY_MENU) then
        menu = not menu
    end

    if InputDown(KEY_SNAP) and VecLength(GetPlayerVelocity()) < 0.1 then
        hitPosition = hitPositionSnapped
        DebugCross(hitPosition, 0, 0, 255, 1)
    end

    if InputPressed(KEY_NEW) then

        if #measurements == 0 then -- If there are no measurements, create the first one
            table.insert(measurements, {
                pos_a = nil,
                set_a = false,
                pos_b = nil,
                set_b = false,
                length = nil,
                type = mode
            })
        end

        if measurements[#measurements].set_b then -- Create a new measurement
            table.insert(measurements, {
                        pos_a = nil,
                        set_a = false,
                        pos_b = nil,
                        set_b = false,
                        length = nil,
                        type = mode
                    })
        end

        if not measurements[#measurements].set_b and measurements[#measurements].set_a and dist < maxDist then -- Second point of the measurement; create a new one
            measurements[#measurements].pos_b = hitPosition
            measurements[#measurements].set_b = true
            measurements[#measurements].length = VecLength(VecSub(measurements[#measurements].pos_a, measurements[#measurements].pos_b))
        end

        if not measurements[#measurements].set_a and dist < maxDist then -- First point of the measurement
            measurements[#measurements].pos_a = hitPosition
            measurements[#measurements].set_a = true 
        end
        
    end

    if #measurements > 0 and measurements[#measurements].set_a and not measurements[#measurements].set_b then
        measurements[#measurements].pos_b = hitPosition
        if dist < maxDist then
            measurements[#measurements].length = VecLength(VecSub(measurements[#measurements].pos_a, measurements[#measurements].pos_b))
        end
    end

    if InputPressed(KEY_CANCEL) then -- Removes last measurement

        if #measurements > 0 and measurements[#measurements].set_a and not measurements[#measurements].set_b then
            table.remove(measurements, #measurements)
        end
    end
    
end

function client.draw() -- Rendering
    
    for i = 1, #measurements do

        deltaX = math.abs(measurements[i].pos_a[1] - measurements[i].pos_b[1])
        deltaY = math.abs(measurements[i].pos_a[2] - measurements[i].pos_b[2])
        deltaZ = math.abs(measurements[i].pos_a[3] - measurements[i].pos_b[3])

        local dominantDelta = maxName { deltaX, deltaY, deltaZ }
        -- DebugPrint(dominantDelta)

        if (dominantDelta[1] == "deltaX" and dominantDelta[2] == "deltaZ") or (dominantDelta[1] == "deltaZ" and dominantDelta[2] == "deltaX") then
            aprim = Vec(measurements[i].pos_b[1], measurements[i].pos_a[2], measurements[i].pos_a[3]) -- a'(xb, ya, za)
            bprim = Vec(measurements[i].pos_a[1], measurements[i].pos_a[2], measurements[i].pos_b[3]) -- b'(xa, ya, zb)

            blevel = Vec(measurements[i].pos_b[1], measurements[i].pos_a[2], measurements[i].pos_b[3]) -- b but with the y coordinate of a (same level)

            orientation = "horizontal"
        else
            aprim = Vec(measurements[i].pos_a[1], measurements[i].pos_b[2], measurements[i].pos_a[3]) -- a'(xb, ya, za)
            bprim = Vec(measurements[i].pos_b[1], measurements[i].pos_a[2], measurements[i].pos_b[3]) -- b'(xa, ya, zb)

            blevel = Vec(measurements[i].pos_b[1], measurements[i].pos_a[2], measurements[i].pos_b[3]) -- b but with the y coordinate of a (same level)
            
            orientation = "vertical"
        end

        dimensionx = VecLength(VecSub(measurements[i].pos_a, bprim))
        dimensiony = VecLength(VecSub(measurements[i].pos_a, aprim))
        
        uiX, uiY, UIdist = UiWorldToPixel(VecLerp(measurements[i].pos_a, measurements[i].pos_b, 0.5)) -- Get the position of the text in the middle of the line

        if measurements[i].type == "rect" then
            if orientation == "horizontal" then
                uiX, uiY, UIdist = UiWorldToPixel(VecLerp(measurements[i].pos_a, blevel, 0.5)) -- Get the position of the text in the middle of the line
            else
                uiX, uiY, UIdist = UiWorldToPixel(VecLerp(measurements[i].pos_a, measurements[i].pos_b, 0.5))
            end
        end
        
        renderMeasurement(measurements[i].set_b, i)

        if UIdist > 0 and measurements[i].set_a and measurements[i].length < maxDist then -- Measurement length label
            if (not measurements[i].set_b and dist < maxDist) or measurements[i].set_b then
                UiPush()
                    UiFont("bold.ttf", 24)
                    UiAlign("center middle")
                    UiTranslate(uiX, uiY)
                    if measurements[i].set_b then
                        UiColor(1,1,1,1)
                        UiTextOutline(0,0,0,5)
                    end
                    if not measurements[i].set_b then
                        UiColor(1,1,1,0.3)
                    end
                    if measurements[i].type == "line" then
                       UiText(string.format("%.2f m", measurements[i].length))  
                    end
                    -- DebugPrint(measurements[i].type)
                    if measurements[i].type == "rect" then
                       UiText(string.format("%.2f m x %.2f m", dimensionx, dimensiony))
                    end
                              
                UiPop()
            end
        end

    end

    if menu then
        BUTTON_SIZE = 128
        BUTTON_SPACING_HORIZONTAL = 50
        BUTTON_SPACING_VERTICAL = 50

        HORI_BUTTONS = 5
        VERT_BUTTONS = 2

        MENU_WIDTH = HORI_BUTTONS * BUTTON_SIZE + (HORI_BUTTONS+1) * BUTTON_SPACING_HORIZONTAL
        MENU_HEIGHT = 500

        UiMakeInteractive()

        UiTranslate(UiCenter(), UiMiddle())
        UiAlign("center middle")
        UiFont("bold.ttf", 24)
        UiAlign("center middle")
        UiBackgroundBlur(1.0)

        UiPush()
            UiColor(0, 0, 0, 0.6)
            UiRect(MENU_WIDTH, MENU_HEIGHT)
        UiPop()

        UiPush()
            UiTranslate(-MENU_WIDTH/2 + BUTTON_SIZE/2 + BUTTON_SPACING_HORIZONTAL, -MENU_HEIGHT/2 + BUTTON_SIZE/2 + BUTTON_SPACING_VERTICAL) -- First row

            UiPush() -- Line mode
                if UiImageButton("/media/button_line.png") then
                    mode = "line"
                end
                UiPush()
                    UiTranslate(0, 80)
                    UiText("Line")
                UiPop()
            UiPop()

            UiPush() -- Rectangular mode
                UiTranslate(BUTTON_SIZE + BUTTON_SPACING_HORIZONTAL)
                if UiImageButton("/media/button_rect.png") then
                    mode = "rect"
                end
                UiPush()
                    UiTranslate(0, 80)
                    UiText("Rectangular")
                UiPop()
            UiPop()

            -- UiPush() -- Button 3
            --     UiTranslate((BUTTON_SIZE + BUTTON_SPACING_HORIZONTAL)*2)
            --     if UiImageButton("/media/button_line.png") then
            --         DebugPrint("Button 3")
            --     end
            --     UiPush()
            --         UiTranslate(0, 80)
            --         UiText("Button 3")
            --     UiPop()
            -- UiPop()

            -- UiPush() -- Button 4
            --     UiTranslate((BUTTON_SIZE + BUTTON_SPACING_HORIZONTAL)*3)
            --     if UiImageButton("/media/button_line.png") then
            --         DebugPrint("Button 4")
            --     end
            --     UiPush()
            --         UiTranslate(0, 80)
            --         UiText("Button 4")
            --     UiPop()
            -- UiPop()

            UiPush() -- Clear all
                UiTranslate((BUTTON_SIZE + BUTTON_SPACING_HORIZONTAL)*4)
                if UiImageButton("/media/clear.png") then
                    measurements = {} -- Clear all measurements
                end
                UiPush()
                    UiTranslate(0, 80)
                    UiText("Clear all")
                UiPop()
            UiPop()

            UiPush() -- Second row
                UiTranslate(0, BUTTON_SPACING_VERTICAL*2 + BUTTON_SIZE)
                
                    UiPush() -- Button 5
                    if UiImageButton("/media/button_line.png") then
                        DebugPrint("point")
                    end
                    UiPush()
                        UiTranslate(0, 80)
                        UiText("Point")
                    UiPop()
                UiPop()

                UiPush() -- Button 6
                    UiTranslate(BUTTON_SIZE + BUTTON_SPACING_HORIZONTAL)
                    if UiImageButton("/media/button_line.png") then
                        DebugPrint("Center Point Rectangular")
                    end
                    UiPush()
                        UiTranslate(0, 80)
                        UiText("Center Point")
                        UiTranslate(0, 25)
                        UiText("Rectangular")
                    UiPop()
                UiPop()

                -- UiPush() -- Button 7
                --     UiTranslate((BUTTON_SIZE + BUTTON_SPACING_HORIZONTAL)*2)
                --     if UiImageButton("/media/button_line.png") then
                --         DebugPrint("Button 7")
                --     end
                --     UiPush()
                --         UiTranslate(0, 80)
                --         UiText("Button 7")
                --     UiPop()
                -- UiPop()

                -- UiPush() -- Settings [WIP]
                --     UiTranslate((BUTTON_SIZE + BUTTON_SPACING_HORIZONTAL)*3)
                --     if UiImageButton("/media/settings.png") then
                --         DebugPrint("settings")
                --     end
                --     UiPush()
                --         UiTranslate(0, 80)
                --         UiText("Settings")
                --     UiPop()
                -- UiPop()

                UiPush() -- Clear last
                    UiTranslate((BUTTON_SIZE + BUTTON_SPACING_HORIZONTAL)*4)
                    if UiImageButton("/media/revert.png") then
                        table.remove(measurements, #measurements) -- Remove last measurement
                    end
                    UiPush()
                        UiTranslate(0, 80)
                        UiText("Clear last")
                    UiPop()
                UiPop()
        UiPop()
    end
end