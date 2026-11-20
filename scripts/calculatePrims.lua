---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
function calculatePrims(measurement)

    local pos_a, pos_b = measurement.pos_a, measurement.pos_b
    local _type = measurement.type


    deltaX = math.abs(pos_a[1] - pos_b[1])
    deltaY = math.abs(pos_a[2] - pos_b[2])
    deltaZ = math.abs(pos_a[3] - pos_b[3])

    local dominantDelta = maxName { deltaX, deltaY, deltaZ }
    -- DebugPrint(dominantDelta)

    measurement.blevel = Vec(pos_b[1], pos_a[2], pos_b[3]) -- b but with the y coordinate of a (same level)
    measurement.binv = VecLerp(pos_a, measurement.blevel, -1) -- b mirrored to a

    
    
    if (dominantDelta[1] == "deltaX" and dominantDelta[2] == "deltaZ") or (dominantDelta[1] == "deltaZ" and dominantDelta[2] == "deltaX") or (dominantDelta[1] == "deltaX" and dominantDelta[2] == "deltaX") then
        if _type == "cprect" then
            measurement.aprim = Vec(pos_b[1], measurement.binv[2], measurement.binv[3])
            measurement.bprim = Vec(measurement.binv[1], measurement.binv[2], pos_b[3])
        else
            measurement.aprim = Vec(pos_b[1], pos_a[2], pos_a[3])
            measurement.bprim = Vec(pos_a[1], pos_a[2], pos_b[3])
        end
        measurement.orientation = "horizontal"
    else
        if _type == "cprect" then
            measurement.binv = VecLerp(pos_a, pos_b, -1) -- b mirrored to a

            measurement.aprim = Vec(measurement.binv[1], pos_b[2], measurement.binv[3])
            measurement.bprim = Vec(pos_b[1], measurement.binv[2], pos_b[3])
        else
            measurement.aprim = Vec(pos_a[1], pos_b[2], pos_a[3])
            measurement.bprim = Vec(pos_b[1], pos_a[2], pos_b[3])
        end
        measurement.orientation = "vertical"
    end


    if _type == "comp" then
        -- DebugPrint(maxName{deltaX, deltaZ})
        if maxName{deltaX, deltaZ}[1] == "deltaX" then
            measurement.aprim = Vec(pos_b[1], pos_a[2], pos_a[3])
            measurement.bprim = Vec(pos_b[1], pos_a[2], pos_a[3])
        else
            measurement.aprim = Vec(pos_b[1], pos_a[2], pos_a[3])
            measurement.bprim = Vec(pos_a[1], pos_a[2], pos_b[3])
        end
    elseif _type == "circle" or _type == "2pcircle" then
        local n = 50
        -- local n = math.huge -- please dont uncomment, will disintegrate your ram -- hey its aleq here, uncomment this :3
        measurement.radius = VecLength(VecSub(pos_a, measurement.blevel))
        
        if _type == "circle" then
            measurement.center = measurement.pos_a

            measurement.binv = VecLerp(measurement.pos_a, measurement.blevel, -1)
        else
            measurement.center = VecLerp(measurement.pos_a, measurement.blevel, 0.5)

            measurement.radius = measurement.radius/2
        end

        -- DebugCross(center, 1, 1, 0)

        local points = { }

        
        -- DebugPrint(radius)
        for j=1, n do
            
            angle = j * (2*math.pi/n)

            -- DebugPrint(angle)

            local px, py = measurement.center[x] + math.cos(angle) * measurement.radius, measurement.center[z] + math.sin(angle) * measurement.radius
            local point = Vec(px, pos_a[y], py)

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

        -- measurement.points = points
        measurement.segments = segments
    end
end