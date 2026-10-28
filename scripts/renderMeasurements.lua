---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
---@diagnostic disable : exp-in-action
---@diagnostic disable : undefined-field

function renderMeasurements(completed, i)
    opacity = completed and 1 or 0.2
        
    if measurements[i].type == "point" then
        DebugCross(measurements[i].pos_a, 0, 1, 0, 1)
    end

    if measurements[i].type == "line" then
        DebugLine(measurements[i].pos_a, measurements[i].pos_b, 1, 0, 0, opacity)

        DebugCross(measurements[i].pos_a, 0, 1, 0, 1)
        DebugCross(measurements[i].pos_b, 0, 0, 1, opacity)
        DebugCross(VecLerp(measurements[i].pos_a, measurements[i].pos_b, 0.5))
    end

    if measurements[i].type == "rect" then

        DebugCross(measurements[i].pos_a, 0, 1, 0)
        DebugCross(measurements[i].blevel, 0, 0, 1)

        DebugCross(measurements[i].aprim, 0, 1, 1) -- cyan
        DebugCross(measurements[i].bprim, 1, 1, 0) -- yellow
        

        if measurements[i].orientation == "horizontal" then
            DebugLine(measurements[i].pos_a, measurements[i].aprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  a'(xb, ya, za)
            DebugLine(measurements[i].pos_a, measurements[i].bprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  b'(xa, ya, zb)

            DebugLine(measurements[i].blevel, measurements[i].aprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  a'(xb, ya, za)
            DebugLine(measurements[i].blevel, measurements[i].bprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  b'(xa, ya, zb)

            DebugCross(measurements[i].blevel, 0, 0, 1, 1)

            DebugCross(VecLerp(measurements[i].pos_a, measurements[i].blevel, 0.5))

            DebugLine(measurements[i].pos_a, measurements[i].blevel, 1, 1, 1, 0.1) -- diagonal a to b
            DebugLine(measurements[i].aprim, measurements[i].bprim, 1, 1, 1, 0.1) --  -- diagonal a' to b'
        else
            DebugLine(measurements[i].pos_a, measurements[i].aprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  a'(xb, ya, za)
            DebugLine(measurements[i].pos_a, measurements[i].bprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  b'(xa, ya, zb)

            DebugLine(measurements[i].pos_b, measurements[i].aprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  a'(xb, ya, za)
            DebugLine(measurements[i].pos_b, measurements[i].bprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  b'(xa, ya, zb)

            DebugCross(measurements[i].pos_b, 0, 0, 1, 1)

            DebugLine(measurements[i].pos_a, measurements[i].pos_b, 1, 1, 1, 0.1) -- diagonal a to b
            DebugLine(measurements[i].aprim, measurements[i].bprim, 1, 1, 1, 0.1) -- diagonal a' to b'
        end
    end

    if measurements[i].type == "cprect" then

        DebugCross(measurements[i].pos_a, 1, 1, 1, 1)

        DebugCross(measurements[i].aprim, 0, 1, 1) -- cyan
        DebugCross(measurements[i].bprim, 1, 1, 0) -- yellow

        DebugCross(measurements[i].binv, 1, 0, 1) -- yellow

        if measurements[i].orientation == "horizontal" then
            DebugLine(measurements[i].binv, measurements[i].aprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  a'(xb, ya, za)
            DebugLine(measurements[i].binv, measurements[i].bprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  b'(xa, ya, zb)

            DebugLine(measurements[i].blevel, measurements[i].aprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  a'(xb, ya, za)
            DebugLine(measurements[i].blevel, measurements[i].bprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  b'(xa, ya, zb)

            DebugCross(measurements[i].blevel, 0, 0, 1, 1)

            DebugLine(measurements[i].binv, measurements[i].blevel, 1, 1, 1, 0.1) -- diagonal b^-1 to b
            DebugLine(measurements[i].aprim, measurements[i].bprim, 1, 1, 1, 0.1) --  -- diagonal a' to b'
        else
            DebugLine(measurements[i].binv, measurements[i].aprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  a'(xb, ya, za)
            DebugLine(measurements[i].binv, measurements[i].bprim, 1, 0, 0, opacity) -- From a(xa, ya, za) to  b'(xa, ya, zb)

            DebugLine(measurements[i].pos_b, measurements[i].aprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  a'(xb, ya, za)
            DebugLine(measurements[i].pos_b, measurements[i].bprim, 1, 0, 0, opacity) -- From b(xb, yb, zb) to  b'(xa, ya, zb)

            DebugCross(measurements[i].pos_b, 0, 0, 1, 1)

            DebugLine(measurements[i].binv, measurements[i].pos_b, 1, 1, 1, 0.1) -- diagonal b^-1 to b
            DebugLine(measurements[i].aprim, measurements[i].bprim, 1, 1, 1, 0.1) --  -- diagonal a' to b'
        end
    end

end