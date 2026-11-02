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

    if measurements[i].type == "circle" then
        local n = 50
        -- local n = math.huge -- please dont uncomment, will disintegrate your ram -- hey its aleq here, uncomment this :3
        local radius = VecLength(VecSub(measurements[i].pos_a, measurements[i].pos_b))

        local points = { }

        
        -- DebugPrint(radius)
        for j=1, n do
            
            angle = j * (2*math.pi/n)

            -- DebugPrint(angle)

            local px, py = measurements[i].pos_a[x] + math.cos(angle) * radius, measurements[i].pos_a[z] + math.sin(angle) * radius
            local point = Vec(px, measurements[i].pos_a[y], py)

            -- DebugCross(point)
            table.insert(points, point)
        end


        -- to segments
        local segments = { }

        for i = 2, #points do
            table.insert(
                segments,
                { points[i - 1], points[i] }
            )
        end
        table.insert(segments, { points[#points], points[1] })

        -- measurements[i].points = points
        measurements[i].segments = segments
    end
end