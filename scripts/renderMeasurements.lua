---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
---@diagnostic disable : exp-in-action
---@diagnostic disable : undefined-field

x = 1
y = 2
z = 3


function renderMeasurements(completed, i)
    opacity = completed and 1 or 0.2

    color = (measurements[i].dimensionx == measurements[i].dimensiony) and (completed and {1, 0, 0} or {0, 1, 0}) or {1, 0, 0}

    -- DebugPrint(measurements[i].dimensionx)
    -- DebugPrint(measurements[i].dimensiony)

    local measurement = measurements[i]
    
    if measurement.type == "point" then
        DebugCross(measurement.pos_a, 0, 1, 0, 1)
    end

    if measurement.type == "line" then
        color = isParallel(i) and (completed and {1, 0, 0} or {0, 1, 0}) or {1, 0, 0}
        DebugLine(measurement.pos_a, measurement.pos_b, color[1], color[2], color[3], opacity)

        DebugCross(measurement.pos_a, 0, 1, 0, 1)
        DebugCross(measurement.pos_b, 0, 0, 1, opacity)
        DebugCross(VecLerp(measurement.pos_a, measurement.pos_b, 0.5))
    end

    if measurement.type == "rect" then

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

    if measurement.type == "cprect" then

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

    if measurement.type == "circle" then
        DebugCross(measurements[i].binv, 0, 1, 0, 1)
        DebugCross(measurements[i].center, 1, 1, 1, 1)
        DebugCross(measurement.blevel, 0, 0, 1)

        for _, segment in ipairs(measurement.segments) do
            DebugLine(segment[1], segment[2], 1, 0, 0, opacity)
        end

        DebugLine(measurement.binv, measurement.blevel, 1, 1, 1, opacity) -- diameter
    end

    if measurement.type == "2pcircle" then
        DebugCross(measurement.pos_a, 0, 1, 0, 1)
        DebugCross(measurement.blevel, 0, 0, 1)
        DebugCross(measurements[i].center)

        for _, segment in ipairs(measurement.segments) do
            DebugLine(segment[1], segment[2], 1, 0, 0, opacity)
        end

        DebugLine(measurement.pos_a, measurement.blevel, 1, 1, 1, opacity) -- diameter
    end
end