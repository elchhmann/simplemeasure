---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global

function addMeasurement(hitPosition, dist)
    if #measurements == 0 then -- If there are no measurements, create the first one
        table.insert(measurements, GET_NULL_MEASUREMENT())
    end

    if measurements[#measurements].set_b then -- Create a new measurement
            table.insert(measurements, GET_NULL_MEASUREMENT())
    end

    if measurements[#measurements].type == "point" then
        measurements[#measurements].pos_a = hitPosition
        measurements[#measurements].pos_b = hitPosition
        measurements[#measurements].set_a = true
        measurements[#measurements].set_b = true
        measurements[#measurements].length = VecLength(VecSub(measurements[#measurements].pos_a, measurements[#measurements].pos_b))
    else
        

        if not measurements[#measurements].set_b and measurements[#measurements].set_a and dist < maxDist then -- Second point of the measurement; create a new one
            measurements[#measurements].pos_b = hitPosition
            measurements[#measurements].set_b = true
            measurements[#measurements].length = VecLength(VecSub(measurements[#measurements].pos_a, measurements[#measurements].pos_b))
        end

        if not measurements[#measurements].set_a and dist < maxDist then -- First point of the measurement
            measurements[#measurements].pos_a = hitPosition
            measurements[#measurements].set_a = true
        end
    end
end