---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global

function mark(a, b, aprim, bprim, binv, type, radius, red, green, blue, i, iterations)
    for i=1, iterations do
        if type == "line" then
            spot = VecLerp(a, b, (i/iterations))
            PaintRGBA(spot, radius, red, green, blue)
            -- DebugCross(spot)
        end

        if type == "rect" then
            spot = VecLerp(a, aprim, (i/iterations))
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(a, bprim, (i/iterations))
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(b, aprim, (i/iterations))
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(b, bprim, (i/iterations))
            PaintRGBA(spot, radius, red, green, blue)
        end

        if type == "cprect" then
            spot = VecLerp(binv, aprim, (i/iterations))
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(binv, bprim, (i/iterations))
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(b, aprim, (i/iterations))
            PaintRGBA(spot, radius, red, green, blue)

            spot = VecLerp(b, bprim, (i/iterations))
            PaintRGBA(spot, radius, red, green, blue)
        end
    end
end