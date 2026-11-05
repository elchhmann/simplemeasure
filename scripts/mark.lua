---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global




function mark(a, b, blevel, aprim, bprim, binv, type, radius, red, green, blue, iterations, segments)

    -- DebugPrint("Makrela")

    -- DebugPrint(_G.type(radius))
    -- DebugPrint(radius)

    if type == "circle" or type == "2pcircle" then
        -- DebugPrint("Circle Makrela")
        for index, segment in ipairs(segments) do
            local m = GET_NULL_MEASUREMENT()
            m.pos_a = segment[1]
            m.pos_b = segment[2]
            m.iterations = iterations
            m.segments = segments

            MarkBuffer:Add(m, iterations, nil)
        end

        return
    end

    -- DebugPrint(_G.type(iterations))

    for i=1, iterations do
        local spacing = i/iterations

        -- DebugPrint(type)

        if type == "line" then
            spot = VecLerp(a, b, spacing)
            PaintRGBA(spot, radius, red, green, blue)
            -- DebugCross(spot)
        end

        if type == "rect" then
            spot = VecLerp(a, aprim, spacing)
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(a, bprim, spacing)
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(blevel, aprim, spacing)
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(blevel, bprim, spacing)
            PaintRGBA(spot, radius, red, green, blue)
        end

        if type == "cprect" then -- cp stands for center point *
            spot = VecLerp(binv, aprim, spacing)
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(binv, bprim, spacing)
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(blevel, aprim, spacing)
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(blevel, bprim, spacing)
            PaintRGBA(spot, radius, red, green, blue)
        end
    end
end