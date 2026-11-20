---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
---@diagnostic disable : exp-in-action
---@diagnostic disable : undefined-field

x = 1
y = 2
z = 3

import "Luva.Engine.matching_expr"

local function fpoint(measurement)
    DebugCross(measurement.pos_a, 0, 1, 0, 1)
end

local function fline(measurement, color, i, completed, opacity)
    local color = isParallel(measurements[i].pos_a, measurements[i].pos_b, i) and (completed and {1, 0, 0} or {0, 1, 0}) or {1, 0, 0}
    DebugLine(measurement.pos_a, measurement.pos_b, color[1], color[2], color[3], opacity)

    DebugCross(measurement.pos_a, 0, 1, 0, 1)
    DebugCross(measurement.pos_b, 0, 0, 1, opacity)
    DebugCross(VecLerp(measurement.pos_a, measurement.pos_b, 0.5))
end

local function frect(measurement, color, opacity)
    DebugCross(measurement.pos_a, 0, 1, 0)
    DebugCross(measurement.blevel, 0, 0, 1)

    DebugCross(measurement.aprim, 0, 1, 1) -- cyan
    DebugCross(measurement.bprim, 1, 1, 0) -- yellow
    

    if measurement.orientation == "horizontal" then
        DebugLine(measurement.pos_a, measurement.aprim, color[1], color[2], color[3], opacity) -- From a(xa, ya, za) to  a'(xb, ya, za)
        DebugLine(measurement.pos_a, measurement.bprim, color[1], color[2], color[3], opacity) -- From a(xa, ya, za) to  b'(xa, ya, zb)

        DebugLine(measurement.blevel, measurement.aprim, color[1], color[2], color[3], opacity) -- From b(xb, yb, zb) to  a'(xb, ya, za)
        DebugLine(measurement.blevel, measurement.bprim, color[1], color[2], color[3], opacity) -- From b(xb, yb, zb) to  b'(xa, ya, zb)

        DebugCross(measurement.blevel, 0, 0, 1, 1)

        DebugCross(VecLerp(measurement.pos_a, measurement.blevel, 0.5))

        if config.show_diag then
            DebugLine(measurement.pos_a, measurement.blevel, 1, 1, 1, 0.1) -- diagonal a to b
            DebugLine(measurement.aprim, measurement.bprim, 1, 1, 1, 0.1) --  -- diagonal a' to b'
        end
    else
        DebugLine(measurement.pos_a, measurement.aprim, color[1], color[2], color[3], opacity) -- From a(xa, ya, za) to  a'(xb, ya, za)
        DebugLine(measurement.pos_a, measurement.bprim, color[1], color[2], color[3], opacity) -- From a(xa, ya, za) to  b'(xa, ya, zb)

        DebugLine(measurement.pos_b, measurement.aprim, color[1], color[2], color[3], opacity) -- From b(xb, yb, zb) to  a'(xb, ya, za)
        DebugLine(measurement.pos_b, measurement.bprim, color[1], color[2], color[3], opacity) -- From b(xb, yb, zb) to  b'(xa, ya, zb)

        DebugCross(measurement.pos_b, 0, 0, 1, 1)

        if config.show_diag then
            DebugLine(measurement.pos_a, measurement.pos_b, 1, 1, 1, 0.1) -- diagonal a to b
            DebugLine(measurement.aprim, measurement.bprim, 1, 1, 1, 0.1) -- diagonal a' to b' 
        end
    end
end

local function fcprect(measurement, color, opacity)
    DebugCross(measurement.pos_a, 1, 1, 1, 1)

    DebugCross(measurement.aprim, 0, 1, 1) -- cyan
    DebugCross(measurement.bprim, 1, 1, 0) -- yellow

    DebugCross(measurement.binv, 1, 0, 1) -- yellow

    if measurement.orientation == "horizontal" then
        DebugLine(measurement.binv, measurement.aprim, color[1], color[2], color[3], opacity) -- From a(xa, ya, za) to  a'(xb, ya, za)
        DebugLine(measurement.binv, measurement.bprim, color[1], color[2], color[3], opacity) -- From a(xa, ya, za) to  b'(xa, ya, zb)

        DebugLine(measurement.blevel, measurement.aprim, color[1], color[2], color[3], opacity) -- From b(xb, yb, zb) to  a'(xb, ya, za)
        DebugLine(measurement.blevel, measurement.bprim, color[1], color[2], color[3], opacity) -- From b(xb, yb, zb) to  b'(xa, ya, zb)

        DebugCross(measurement.blevel, 0, 0, 1, 1)

        if config.show_diag then
            DebugLine(measurement.binv, measurement.blevel, 1, 1, 1, 0.1) -- diagonal b^-1 to b
            DebugLine(measurement.aprim, measurement.bprim, 1, 1, 1, 0.1) --  -- diagonal a' to b'
        end
    else
        DebugLine(measurement.binv, measurement.aprim, color[1], color[2], color[3], opacity) -- From a(xa, ya, za) to  a'(xb, ya, za)
        DebugLine(measurement.binv, measurement.bprim, color[1], color[2], color[3], opacity) -- From a(xa, ya, za) to  b'(xa, ya, zb)

        DebugLine(measurement.pos_b, measurement.aprim, color[1], color[2], color[3], opacity) -- From b(xb, yb, zb) to  a'(xb, ya, za)
        DebugLine(measurement.pos_b, measurement.bprim, color[1], color[2], color[3], opacity) -- From b(xb, yb, zb) to  b'(xa, ya, zb)

        DebugCross(measurement.pos_b, 0, 0, 1, 1)

        if config.show_diag then
            DebugLine(measurement.binv, measurement.pos_b, 1, 1, 1, 0.1) -- diagonal b^-1 to b
            DebugLine(measurement.aprim, measurement.bprim, 1, 1, 1, 0.1) --  -- diagonal a' to b'
        end
    end
end

local function fcircle(measurement, opacity, completed)
    local color = isParallel(measurement.binv, measurement.blevel, i) and (completed and {1, 1, 1} or {0, 1, 0}) or {1, 1, 1}

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
    local color = isParallel(measurement.pos_a, measurement.blevel, i) and (completed and {1, 1, 1} or {0, 1, 0}) or {1, 1, 1}

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
            fpoint(measurement)
        end,

        ["line"] = function ()
            fline(measurement, color, i, completed, opacity)
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