---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global



function mark(a, b, blevel, aprim, bprim, binv, type, orientation, radius, red, green, blue, iterations, segments)
    
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
    
    if type == "comp" then
        local compoundPoints = {a, bprim, blevel, b}
        
        for i = 1, 3  do
            local m = GET_NULL_MEASUREMENT()
            m.pos_a = compoundPoints[i]
            m.pos_b = compoundPoints[i + 1]
            m.iterations = iterations
            m.segments = compoundPoints
            
            MarkBuffer:Add(m, iterations, nil)
        end
        
        return
    end
    
    -- DebugPrint(_G.type(iterations))
    
    local spot, vel
    local life = 1
    
    local function _paint()
        PaintRGBA(spot, radius, red, green, blue)
        ClientCall(0, "client.particle", spot, vel, life, red, green, blue)
    end
  

    for i=1, iterations do
        local spacing = i/iterations

        vel = Vec(0,0,0)


        -- DebugPrint(type)

        if orientation == "vertical" then
            orientB = b
        else
            orientB = blevel
        end

        if type == "line" then
            spot = VecLerp(a, b, spacing)
            _paint()
            -- DebugCross(spot)
        end

        if type == "rect" then
            spot = VecLerp(a, aprim, spacing)
            _paint()

            spot = VecLerp(a, bprim, spacing)
            _paint()

            spot = VecLerp(orientB, aprim, spacing)
            _paint()

            spot = VecLerp(orientB, bprim, spacing)
            _paint()
        end

        if type == "cprect" then -- cp stands for center point *
            spot = VecLerp(binv, aprim, spacing)
            _paint()

            spot = VecLerp(binv, bprim, spacing)
            _paint()

            spot = VecLerp(orientB, aprim, spacing)
            _paint()
        
            spot = VecLerp(orientB, bprim, spacing)
            _paint()
        end

        ClientCall(0, "client.fx", spot, vel, life, red, green, blue)
    end

end