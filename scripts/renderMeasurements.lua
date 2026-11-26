---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
---@diagnostic disable : exp-in-action
---@diagnostic disable : undefined-field

local x = 1
local y = 2
local z = 3

import "Luva.Engine.matching_expr"
import "scripts.Color"

local DebugCross = DebugCross
local DebugLine = DebugLine

local function fpoint(pos_a)
    DebugCross(pos_a, 0, 1, 0, 1)
end

local function fline(pos_a, pos_b, completed, opacity)
    local color = isParallel(pos_a, pos_b) and (completed and {1, 0, 0} or {0, 1, 0}) or {1, 0, 0}
    DebugLine(pos_a, pos_b, color[1], color[2], color[3], opacity)

    DebugCross(pos_a, 0, 1, 0, 1)
    DebugCross(pos_b, 0, 0, 1, opacity)
    DebugCross(VecLerp(pos_a, pos_b, 0.5))
end

local function showCross(value)
    DebugCross(value, 0, 0, 1, 1)
end

local function showWhiteLine(a, b)
    DebugLine(a, b, 1, 1, 1, 0.1)
end

local function showColoredLine(va, vb, color, opacity) -- white and colored segregation made a return???
    DebugLine(va, vb, color[1], color[2], color[3], opacity) -- yes
end

local function frect(measurement, color, opacity)
    
    local pos_a, pos_b = measurement.pos_a, measurement.pos_b
    local aprim, bprim = measurement.aprim, measurement.bprim
    local blevel = measurement.blevel
    local showDiag = config.show_diag

    DebugCross(pos_a, 0, 1, 0)
    DebugCross(blevel, 0, 0, 1)

    DebugCross(aprim, 0, 1, 1) -- cyan
    DebugCross(bprim, 1, 1, 0) -- yellow
    

    if measurement.orientation == "horizontal" then
        showColoredLine(pos_a, aprim, color, opacity)
        showColoredLine(pos_a, bprim, color, opacity)

        showColoredLine(blevel, aprim, color, opacity)
        showColoredLine(blevel, bprim, color, opacity)

        showCross(blevel)

        DebugCross(VecLerp(pos_a, blevel, 0.5))

        if showDiag then
            showWhiteLine(pos_a, blevel)
            showWhiteLine(aprim, bprim)
        end
    else
        showColoredLine(pos_a, aprim, color, opacity)
        showColoredLine(pos_a, bprim, color, opacity)

        showColoredLine(pos_b, aprim, color, opacity)
        showColoredLine(pos_b, bprim, color, opacity)

        showCross(pos_b)

        if showDiag then
            showWhiteLine(pos_a, pos_b) -- a to b
            showWhiteLine(aprim, bprim) -- a' to b'
        end
    end
end

local function fcprect(measurement, color, opacity)
    DebugCross(measurement.pos_a, 1, 1, 1, 1)

    DebugCross(measurement.aprim, 0, 1, 1) -- cyan
    DebugCross(measurement.bprim, 1, 1, 0) -- yellow

    DebugCross(measurement.binv, 1, 0, 1) -- yellow

    if measurement.orientation == "horizontal" then
        showColoredLine(measurement.binv, measurement.aprim, color, opacity)
        showColoredLine(measurement.binv, measurement.bprim, color, opacity)

        showColoredLine(measurement.blevel, measurement.aprim, color, opacity)
        showColoredLine(measurement.blevel, measurement.bprim, color, opacity)

        DebugCross(measurement.blevel, 0, 0, 1, 1)

        if config.show_diag then
            showWhiteLine(measurement.binv, measurement.blevel) -- diagonal b^-1 to b
            showWhiteLine(measurement.aprim, measurement.bprim) --  -- diagonal a' to b'
        end
    else
        showColoredLine(measurement.binv, measurement.aprim, color, opacity)
        showColoredLine(measurement.binv, measurement.bprim, color, opacity)

        showColoredLine(measurement.pos_b, measurement.aprim, color, opacity)
        showColoredLine(measurement.pos_b, measurement.bprim, color, opacity)

        DebugCross(measurement.pos_b, 0, 0, 1, 1)

        if config.show_diag then
            showWhiteLine(measurement.binv, measurement.pos_b) -- diagonal b^-1 to b
            showWhiteLine(measurement.aprim, measurement.bprim) --  -- diagonal a' to b'
        end
    end
end

local function fcircle(measurement, opacity, completed)
    local color = isParallel(measurement.binv, measurement.blevel) and (completed and {1, 1, 1} or {0, 1, 0}) or {1, 1, 1}

    DebugCross(measurement.binv, 0, 1, 0, 1)
    DebugCross(measurement.center, 1, 1, 1, 1)
    DebugCross(measurement.blevel, 0, 0, 1)

    -- DebugPrint(measurement.center)

    for _, segment in ipairs(measurement.segments) do
        DebugLine(segment[1], segment[2], 1, 0, 0, opacity)
    end

    DebugLine(measurement.binv, measurement.blevel, color[1], color[2], color[3], opacity) -- diameter
end


local function f2pcircle(measurement, opacity, completed)
    local color = isParallel(measurement.pos_a, measurement.blevel) and (completed and {1, 1, 1} or {0, 1, 0}) or {1, 1, 1}

    DebugCross(measurement.pos_a, 0, 1, 0, 1)
    DebugCross(measurement.blevel, 0, 0, 1)
    DebugCross(measurement.center)

    for _, segment in ipairs(measurement.segments) do
        DebugLine(segment[1], segment[2], 1, 0, 0, opacity)
    end

    DebugLine(measurement.pos_a, measurement.blevel, color[1], color[2], color[3], opacity) -- diameter
end

local function fcomp(measurement, opacity)
    DebugCross(measurement.pos_a, 0, 1, 0, 1)
    DebugCross(measurement.pos_b, 0, 0, 1, 1)

    DebugCross(measurement.blevel, 0, 1, 1) -- cyan
    DebugCross(measurement.bprim, 1, 1, 0) -- yellow

    local compoundPoints = {measurement.pos_a, measurement.bprim, measurement.blevel, measurement.pos_b}

    for j = 1, 3 do
        DebugLine(compoundPoints[j], compoundPoints[j+1], 1, 0, 0, opacity)
    end
end

function renderMeasurements(completed, i)
    local opacity = completed and 1 or 0.2
    
    local color
    local measurement = measurements[i]
    
    if measurement.dimensionx == measurement.dimensiony then
        color = completed and {1, 0, 0} or {0, 1, 0}
    else
        color = {1, 0, 0}
    end
    
    -- color = (measurements[i].dimensionx == measurements[i].dimensiony) and (completed and {1, 0, 0} or {0, 1, 0}) or {1, 0, 0}

    -- DebugPrint(measurements[i].dimensionx)
    -- DebugPrint(measurements[i].dimensiony)


    switch (measurement.type, {
        ["point"] = function ()
            fpoint(measurement.pos_a)
        end,

        ["line"] = function ()
            fline(measurement.pos_a, measurement.pos_b, , completed, opacity)
        end,

        ["rect"] = function ()
            frect(measurement, color, opacity)
        end,

        ["cprect"] = function ()
            fcprect(measurement, color, opacity)
        end,

        ["circle"] = function ()
            fcircle(measurement, opacity, completed)
        end,

        ["2pcircle"] = function ()
            f2pcircle(measurement, opacity, completed)
        end,

        ["comp"] = function ()
            fcomp(measurement, opacity)
        end
    })
end