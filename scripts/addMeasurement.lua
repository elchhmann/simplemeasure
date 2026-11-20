---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global

local insert = table.insert

function addMeasurement(hitPosition)
    if dist >= maxDist then
        return
    end
    
    if #measurements == 0 then -- If there are no measurements, create the first one
        insert(measurements, GET_NULL_MEASUREMENT())
    end
    
    local last = measurements[#measurements]
    
    if last.set_b then -- Create a new measurement
        insert(measurements, GET_NULL_MEASUREMENT())
        last = measurements[#measurements]
    end

    if not last.set_b and last.set_a then -- Second point of the measurement; create a new one
        last.pos_b = hitPosition
        last.set_b = true
        last.length = VecLength(VecSub(last.pos_a, last.pos_b))
    end
    
    if not last.set_a then -- First point of the measurement
        last.pos_a = hitPosition
        last.set_a = true
    end
end