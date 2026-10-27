deltaX = math.abs(measurements[i].pos_a[1] - measurements[i].pos_b[1])
        deltaY = math.abs(measurements[i].pos_a[2] - measurements[i].pos_b[2])
        deltaZ = math.abs(measurements[i].pos_a[3] - measurements[i].pos_b[3])

        local dominantDelta = maxName { deltaX, deltaY, deltaZ }
        -- DebugPrint(dominantDelta)

        blevel = Vec(measurements[i].pos_b[1], measurements[i].pos_a[2], measurements[i].pos_b[3]) -- b but with the y coordinate of a (same level)
        binv = VecLerp(measurements[i].pos_a, measurements[i].pos_b, -1) -- b mirrored to a

        if (dominantDelta[1] == "deltaX" and dominantDelta[2] == "deltaZ") or (dominantDelta[1] == "deltaZ" and dominantDelta[2] == "deltaX") then
            if measurements[i].type == "cprect" then
                aprim = Vec(measurements[i].pos_b[1], binv[2], binv[3]) -- a'(xb, ya, za)
                bprim = Vec(binv[1], binv[2], measurements[i].pos_b[3]) -- b'(xa, ya, zb)
            else
                aprim = Vec(measurements[i].pos_b[1], measurements[i].pos_a[2], measurements[i].pos_a[3]) -- a'(xb, ya, za)
                bprim = Vec(measurements[i].pos_a[1], measurements[i].pos_a[2], measurements[i].pos_b[3]) -- b'(xa, ya, zb)
            end
            orientation = "horizontal"
        else
            if measurements[i].type == "cprect" then
                aprim = Vec(binv[1], measurements[i].pos_b[2], binv[3]) -- a'(xb, ya, za)
                bprim = Vec(measurements[i].pos_b[1], binv[2], measurements[i].pos_b[3]) -- b'(xa, ya, zb)
            else
                aprim = Vec(measurements[i].pos_a[1], measurements[i].pos_b[2], measurements[i].pos_a[3]) -- a'(xb, ya, za)
                bprim = Vec(measurements[i].pos_b[1], measurements[i].pos_a[2], measurements[i].pos_b[3]) -- b'(xa, ya, zb)
            end
            orientation = "vertical"
        end