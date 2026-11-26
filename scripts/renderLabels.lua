
---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global

import "Luva.Engine.matching_expr"


local function getSide(a, b)
    return round(VecLength(VecSub(a, b)), 2)
end

local format = string.format

local function getLength(x)
    return format("%.2f m", x)
end

local function getSize(x, y)
    return format("%.2f m x %.2f m", x, y)
end

local function forCircle(measurement)
    uiX, uiY, UIdist = UiWorldToPixel(measurement.center)
    measurement.label = getLength(measurement.radius * 2)
end


local function getCompoundMiddle(compoundPoints, j)
    return UiWorldToPixel(VecLerp(compoundPoints[j], compoundPoints[j + 1], 0.5))
end


function renderLabels(i)
    local measurement = measurements[i]

    local set_b, blevel = measurement.set_b, measurement.blevel
    local _type, bprim, length = measurement.type, measurement.bprim, measurement.length
    local pos_a, pos_b = measurement.pos_a, measurement.pos_b
    
    if not set_b then
        local aprim, thePoint = measurement.aprim, nil

        if _type == "cprect" then
            thePoint = measurement.binv
        else
            thePoint = pos_a
        end

        measurement.dimensionx = getSide(thePoint, bprim)
        measurement.dimensiony = getSide(thePoint, aprim)
    end

    switch (_type, {
        ["line"] = function ()
            uiX, uiY, UIdist = UiWorldToPixel(VecLerp(pos_a, pos_b, 0.5)) -- Get the position of the text in the middle of the line
            measurement.label = getLength(length)
        end,

        ["rect"] = function ()
            if measurement.orientation == "horizontal" then
                uiX, uiY, UIdist = UiWorldToPixel(VecLerp(pos_a, blevel, 0.5)) -- Get the position of the text in the middle of the line
            else
                uiX, uiY, UIdist = UiWorldToPixel(VecLerp(pos_a, pos_b, 0.5))
            end

            measurement.label = getSize(measurement.dimensionx, measurement.dimensiony)
        end,

        ["cprect"] = function ()
            uiX, uiY, UIdist = UiWorldToPixel(pos_a) -- Get the position of the text in the middle of the line [for cprect or circle]
            measurement.label = getSize(measurement.dimensionx, measurement.dimensiony)
        end,

        ["circle"] = function ()
            forCircle(measurement)
        end,

        ["2pcircle"] = function ()
            forCircle(measurement)
        end,

        default = function () end
    })

    local compoundPoints = { pos_a, bprim, blevel, pos_b }

    -- measurement.label = string.format("%.2f m", measurement.length)

    local showindex = config.show_index and (i .. ": " .. " ") or ("")

    UiPush()
        UiFont("bold.ttf", 24)
        UiAlign("center middle")

        if set_b then
            UiColor(1, 1, 1, 1)
            UiTextOutline(0, 0, 0, 5)
        else
            UiColor(1, 1, 1, 0.3)
        end

        local isValid = UIdist > 0 and measurement.set_a and length < maxDist and _type ~= "comp"
        local shouldOccur = (not set_b and dist < maxDist) or set_b

        if isValid and shouldOccur then
            UiTranslate(uiX, uiY - 15)
            UiText(showindex .. measurement.label)
        end

        if _type == "comp" then
            for j = 1, 3 do
                DebugCross(VecLerp(compoundPoints[j], compoundPoints[j + 1], 0.5))

                -- compoundUIx[j], compoundUIy[j], compoundUIdist[j] = getCompoundMiddle(compoundPoints, j)
                local compoundUIx, compoundUIy, compoundUIdist = getCompoundMiddle(compoundPoints, j)

                if compoundUIdist > 0 then
                    UiTranslate(compoundUIx, compoundUIy - 15)

                    -- DebugPrint("a: " .. tostring(points[j]) .. " b: " .. tostring(points[j+1]))

                    local lengthCompound = VecLength(VecSub(compoundPoints[j], compoundPoints[j + 1]))

                    measurement.label = getLength(lengthCompound)

                    UiText(showindex .. measurement.label)
                end
            end
        end
    UiPop()
end