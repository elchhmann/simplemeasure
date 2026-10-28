#version 2

---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
---@diagnostic disable : exp-in-action

#include "scripts/renderMeasurements.lua"
#include "scripts/renderLabels.lua"
#include "scripts/mark.lua"
#include "scripts/round.lua"
#include "scripts/maxName.lua"
#include "scripts/config.lua"
#include "scripts/button.lua"
#include "scripts/calculatePrims.lua"


function avg(a, b)
    return ((a+b)/2)
end

maxDist = 1000

menu = false

mode = "line"

measurements = {}


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
                type = mode,

                aprim = nil,
                bprim = nil,
                blevel = nil,
                binv = nil
            })
        end

        if measurements[#measurements].set_b then -- Create a new measurement
                table.insert(measurements, {
                            pos_a = nil,
                            set_a = false,
                            pos_b = nil,
                            set_b = false,
                            length = nil,
                            type = mode,

                            aprim = nil,
                            bprim = nil,
                            blevel = nil,
                            binv = nil,

                            orientation = nil
                        })
        end

        if measurements[#measurements].type == "point" then
            measurements[#measurements].pos_a = hitPosition
            measurements[#measurements].pos_b = hitPosition
            measurements[#measurements].set_a = true 
            measurements[#measurements].set_b = true
            measurements[#measurements].length = VecLength(VecSub(measurements[#measurements].pos_a, measurements[#measurements].pos_b))
        else

            

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

    for i = 1, #measurements do
        calculatePrims(measurements, i)
    end
end

function client.draw() -- Rendering
    
    for i = 1, #measurements do
        renderMeasurements(measurements[i].set_b, i)

        renderLabels(i)
    end

    if menu then
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

            button(1, 1, "/media/button_line.png", "Line", _, function()
                mode = "line"
            end)

            button(1, 2, "/media/button_rect.png", "Rectangular", _, function()
                mode = "rect"
            end)

            button(1, 4, "/media/button_mark.png", "Mark", _, function()
                local sm = measurements
                ServerCall("server.mark", sm)
            end)

            button(1, 5, "/media/clear.png", "Clear all", _, function()
                measurements = {} -- Clear all measurements
            end)

            button(2, 1, "/media/button_point.png", "Point", _, function()
                mode = "point"
            end)

            button(2, 2, "/media/button_cprect.png", "Center Point", "Rectangular", function()
                mode = "cprect"
            end)

            button(2, 5, "/media/revert.png", "Clear last", _, function()
                table.remove(measurements, #measurements) -- Remove last measurement
            end)
        UiPop()
    end
end

function server.mark(sm)
    for i=1, #sm do
        local radius = 0.15
        local red = 1
        local green = 0.698
        local blue = 0.098

        mark(sm[i].pos_a, sm[i].pos_b, sm[i].aprim, sm[i].bprim, sm[i].binv, sm[i].type, radius, red, green, blue, i, sm[i].length*15)
    end
end



-- function server.tick()
--     DebugPrint()
-- end