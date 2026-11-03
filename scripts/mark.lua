---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global




function mark(a, b, aprim, bprim, binv, type, radius, red, green, blue, iterations, segments)
    if type == "circle" or type == "2pcircle" then
        for index, segment in ipairs(segments) do
            -- DebugPrint("Iteration: " .. tostring(i) .. " Segment: " .. tostring(index))
            mark(segment[1], segment[2], nil, nil, nil, "line", radius, red, green, blue, iterations, nil)
        end

        return
    end

    for i=1, iterations do
        local spacing = i/iterations

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

            spot = VecLerp(b, aprim, spacing)
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(b, bprim, spacing)
            PaintRGBA(spot, radius, red, green, blue)
        end

        if type == "cprect" then -- cp stands for center point *
            spot = VecLerp(binv, aprim, spacing)
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(binv, bprim, spacing)
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(b, aprim, spacing)
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(b, bprim, spacing)
            PaintRGBA(spot, radius, red, green, blue)
        end
    end
end