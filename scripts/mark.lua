---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global

function mark(a, b, radius, red, green, blue, i, iterations)
    for i=1, iterations do
        spot = VecLerp(a, b, (1/iterations)+(i/iterations))
        PaintRGBA(spot, radius, red, green, blue)
    end
end