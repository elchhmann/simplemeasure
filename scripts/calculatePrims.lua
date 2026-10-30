---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
function calculatePrims(measurements, i)
    deltaX = math.abs(measurements[i].pos_a[1] - measurements[i].pos_b[1])
    deltaY = math.abs(measurements[i].pos_a[2] - measurements[i].pos_b[2])
    deltaZ = math.abs(measurements[i].pos_a[3] - measurements[i].pos_b[3])

    local dominantDelta = maxName { deltaX, deltaY, deltaZ }
    -- DebugPrint(dominantDelta)

    measurements[i].blevel = Vec(measurements[i].pos_b[1], measurements[i].pos_a[2], measurements[i].pos_b[3]) -- b but with the y coordinate of a (same level)
    measurements[i].binv = VecLerp(measurements[i].pos_a, measurements[i].pos_b, -1) -- b mirrored to a

    
    
    if (dominantDelta[1] == "deltaX" and dominantDelta[2] == "deltaZ") or (dominantDelta[1] == "deltaZ" and dominantDelta[2] == "deltaX") or (dominantDelta[1] == "deltaX" and dominantDelta[2] == "deltaX") then
        if measurements[i].type == "cprect" then
            measurements[i].aprim = Vec(measurements[i].pos_b[1], measurements[i].binv[2], measurements[i].binv[3]) -- a'(xb, ya, za)
            measurements[i].bprim = Vec(measurements[i].binv[1], measurements[i].binv[2], measurements[i].pos_b[3]) -- b'(xa, ya, zb)
        else
            measurements[i].aprim = Vec(measurements[i].pos_b[1], measurements[i].pos_a[2], measurements[i].pos_a[3]) -- a'(xb, ya, za)
            measurements[i].bprim = Vec(measurements[i].pos_a[1], measurements[i].pos_a[2], measurements[i].pos_b[3]) -- b'(xa, ya, zb)
        end
        measurements[i].orientation = "horizontal"
    else
        if measurements[i].type == "cprect" then
            measurements[i].aprim = Vec(measurements[i].binv[1], measurements[i].pos_b[2], measurements[i].binv[3]) -- a'(xb, ya, za)
            measurements[i].bprim = Vec(measurements[i].pos_b[1], measurements[i].binv[2], measurements[i].pos_b[3]) -- b'(xa, ya, zb)
        else
            measurements[i].aprim = Vec(measurements[i].pos_a[1], measurements[i].pos_b[2], measurements[i].pos_a[3]) -- a'(xb, ya, za)
            measurements[i].bprim = Vec(measurements[i].pos_b[1], measurements[i].pos_a[2], measurements[i].pos_b[3]) -- b'(xa, ya, zb)
        end
        measurements[i].orientation = "vertical"
    end
end