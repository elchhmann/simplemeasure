---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
---@diagnostic disable : exp-in-action
---@diagnostic disable : undefined-field

x = 1
y = 2
z = 3


function renderMeasurements(completed, i)
    opacity = completed and 1 or 0.2

    local measurement = measurements[i]
        
    if measurement.type == "point" then
        DebugCross(measurement.pos_a, 0, 1, 0, 1)
    end

    if measurement.type == "line" then
        DebugLine(measurement.pos_a, measurement.pos_b, 1, 0, 0, opacity)

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
            DebugLine(measurement.pos_a, measurement.aprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  a'(xb, ya, za)
            DebugLine(measurement.pos_a, measurement.bprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  b'(xa, ya, zb)

            DebugLine(measurement.blevel, measurement.aprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  a'(xb, ya, za)
            DebugLine(measurement.blevel, measurement.bprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  b'(xa, ya, zb)

            DebugCross(measurement.blevel, 0, 0, 1, 1)

            DebugCross(VecLerp(measurement.pos_a, measurement.blevel, 0.5))

            DebugLine(measurement.pos_a, measurement.blevel, 1, 1, 1, 0.1) -- diagonal a to b
            DebugLine(measurement.aprim, measurement.bprim, 1, 1, 1, 0.1) --  -- diagonal a' to b'
        else
            DebugLine(measurement.pos_a, measurement.aprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  a'(xb, ya, za)
            DebugLine(measurement.pos_a, measurement.bprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  b'(xa, ya, zb)

            DebugLine(measurement.pos_b, measurement.aprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  a'(xb, ya, za)
            DebugLine(measurement.pos_b, measurement.bprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  b'(xa, ya, zb)

            DebugCross(measurement.pos_b, 0, 0, 1, 1)

            DebugLine(measurement.pos_a, measurement.pos_b, 1, 1, 1, 0.1) -- diagonal a to b
            DebugLine(measurement.aprim, measurement.bprim, 1, 1, 1, 0.1) -- diagonal a' to b'
        end
    end

    if measurement.type == "cprect" then

        DebugCross(measurement.pos_a, 1, 1, 1, 1)

        DebugCross(measurement.aprim, 0, 1, 1) -- cyan
        DebugCross(measurement.bprim, 1, 1, 0) -- yellow

        DebugCross(measurement.binv, 1, 0, 1) -- yellow

        if measurement.orientation == "horizontal" then
            DebugLine(measurement.binv, measurement.aprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  a'(xb, ya, za)
            DebugLine(measurement.binv, measurement.bprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  b'(xa, ya, zb)

            DebugLine(measurement.blevel, measurement.aprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  a'(xb, ya, za)
            DebugLine(measurement.blevel, measurement.bprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  b'(xa, ya, zb)

            DebugCross(measurement.blevel, 0, 0, 1, 1)

            DebugLine(measurement.binv, measurement.blevel, 1, 1, 1, 0.1) -- diagonal b^-1 to b
            DebugLine(measurement.aprim, measurement.bprim, 1, 1, 1, 0.1) --  -- diagonal a' to b'
        else
            DebugLine(measurement.binv, measurement.aprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  a'(xb, ya, za)
            DebugLine(measurement.binv, measurement.bprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  b'(xa, ya, zb)

            DebugLine(measurement.pos_b, measurement.aprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  a'(xb, ya, za)
            DebugLine(measurement.pos_b, measurement.bprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  b'(xa, ya, zb)

            DebugCross(measurement.pos_b, 0, 0, 1, 1)

            DebugLine(measurement.binv, measurement.pos_b, 1, 1, 1, 0.1) -- diagonal b^-1 to b
            DebugLine(measurement.aprim, measurement.bprim, 1, 1, 1, 0.1) --  -- diagonal a' to b'
        end
    end

    if measurement.type == "circle" then
        DebugCross(measurement.pos_a, 1, 1, 1, 1)
        DebugCross(measurement.blevel, 0, 0, 1)

        for _, segment in ipairs(measurement.segments) do
            DebugLine(segment[1], segment[2], 1, 0, 0, opacity)
        end

        DebugLine(measurement.binv, measurement.pos_b, 1, 1, 1, opacity)
    end

end