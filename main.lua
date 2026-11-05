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
#include "scripts/isParallel.lua"
#include "scripts/button.lua"
#include "scripts/calculatePrims.lua"
#include "scripts/addMeasurement.lua"
#include "scripts/setting.lua"


function avg(a, b)
    return ((a+b)/2)
end

maxDist = 1000

menu = false

mode = "line"

measurements = {}

function GET_NULL_MEASUREMENT()
    return {
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

        center = nil,
        radius = nil,
        segments = {}
    }
end




function client.tick() -- Measurement math etc
    
    origin = GetCameraTransform().pos -- Position of the camera
    cameraDirection = TransformToParentVec(GetCameraTransform(), Vec(0, 0, -1)) -- Direction the camera is facing
    raycast, dist = QueryRaycast(origin, cameraDirection, maxDist) -- Raycast from the camera
    hitPosition = VecAdd(origin, VecScale(cameraDirection, dist)) -- Position where the raycast hits
    hitPositionSnapped = Vec(round(hitPosition[1],1), round(hitPosition[2],1), round(hitPosition[3],1))

    if InputPressed(config.KEY_MENU) then
        menu = not menu
    end

    if InputDown(config.KEY_SNAP) and VecLength(GetPlayerVelocity()) < 0.1 then
        hitPosition = hitPositionSnapped
        DebugCross(hitPosition, 0, 0, 255, 1)
    end

    if InputPressed(config.KEY_NEW) then
        addMeasurement(hitPosition, dist)
    end

    if #measurements > 0 and measurements[#measurements].set_a and not measurements[#measurements].set_b then
        measurements[#measurements].pos_b = hitPosition
        if dist < maxDist then
            measurements[#measurements].length = VecLength(VecSub(measurements[#measurements].pos_a, measurements[#measurements].pos_b))
        end
    end

    if InputPressed(config.KEY_CANCEL) then -- Removes last measurement

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
            UiRect(config.MENU_WIDTH, config.MENU_HEIGHT)
        UiPop()

        UiPush()
            UiTranslate(- config.MENU_WIDTH/2 + config.BUTTON_SIZE/2 + config.BUTTON_SPACING_HORIZONTAL, - config.MENU_HEIGHT/2 + config.BUTTON_SIZE/2 + config.BUTTON_SPACING_VERTICAL) -- Move cursor to first row and column

            button(1, 1, "/media/button_line.png", "Line", _, function()
                mode = "line"
            end)

            button(1, 2, "/media/button_rect.png", "Rectangular", _, function()
                mode = "rect"
            end)

            button(1, 3, "/media/button_2pcircle.png", "Circular", _, function()
                mode = "2pcircle"
            end)

            button(1, 4, "/media/button_mark.png", "Mark all", _, function()
                local sm = measurements
                ServerCall("server.mark", sm)
            end)

            button(1, 5, "/media/clear.png", "Clear all", _, function()
                measurements = {} -- Clear all measurements
            end)

            button(0.6, 5.5, "/media/button_close.png", _, _, function()
                menu = false -- Close the menu
            end)

            button(2, 1, "/media/button_point.png", "Point", _, function()
                mode = "point"
            end)

            button(2, 2, "/media/button_cprect.png", "Center Point", "Rectangular", function()
                mode = "cprect"
            end)

            button(2, 3, "/media/button_circle.png", "Center Point", "Circular", function()
                mode = "circle"
            end)

            button(2, 5, "/media/revert.png", "Clear last", _, function()
                table.remove(measurements, #measurements) -- Remove last measurement
            end)
        UiPop()
        
        UiPush()
            UiTranslate(-720, 0)

            UiPush()
                UiColor(0, 0, 0, 0.6)
                
                UiRect(450, config.MENU_HEIGHT*1.9)

                UiPush()
                    UiTranslate(0, -490)
                    UiColor(1, 1, 1, 1)
                    UiText("Settings")
                UiPop()
            UiPop()

            UiPush()
                UiTranslate(-200, -450)
                setting(1, "Show diagonals", "show_diag")
                setting(2, "Mark diagonals", "mark_diag")
                setting(3, "Mark points", "mark_points")
            UiPop()
        UiPop()
    end
end

function server.mark(sm)
    for i=1, #sm do
        local radius = 0.15
        local red = 1
        local green = 0.698
        local blue = 0.098

        local iterations
        
        if sm[i].type == "circle" or sm[i].type == "2pcircle" then
            -- sm[i].segments[1][1]
            -- sm[i].segments[1][2]
            local segment_length = VecLength(sm[i].segments[1][1], sm[i].segments[1][2])
            iterations = segment_length*1
            DebugPrint(iterations)
        else
            iterations = sm[i].length*15
        end

        if sm[i].set_b then
            DebugPrint(_G.type(iterations))
            mark(sm[i].pos_a, sm[i].pos_b, sm[i].blevel, sm[i].aprim, sm[i].bprim, sm[i].binv, sm[i].type, radius, red, green, blue, iterations, sm[i].segments)
        end
    end
end



-- function server.tick()
--     DebugPrint()
-- end