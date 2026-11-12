---@diagnostic disable : lowercase-global

---@alias Vector table<integer, number>
---@enum PointsEnum
local points =
{
    pos_a = "pos_a",
    pos_b = "pos_b",
    aprim = "aprim",
    bprim = "bprim",
    blevel = "blevel",
    binv = "binv"
}

---@class Dist
---@field public distance number
---@field public measurementRef table
---@field public field PointsEnum
local __x

---@generic T
---@param array table<any, T>
---@param element T
---@return boolean
---@nodiscard
function has(array, element)
    for _, v in pairs(array) do
        if v == element then
            return true
        end
    end

    return false
end

---@param measurements table<integer, table<string, any>>
---@param lookpoint Vector
function closestPoint(measurements, lookpoint)
    ---@type table<integer, Dist>
    local distances = {}
    ---@type Vector|nil
    local point

    for _, measur in ipairs(measurements) do
        if measur.set_b then

            for name, currentPoint in pairs(measur) do
                if has(points, name) then
                    

                    ---@type number
                    local distance = VecLength(VecSub(lookpoint, currentPoint))

                    table.insert(distances, {
                        distance = distance,
                        measurementRef = measur,
                        field = name
                    } --[[@as Dist]])
                end
            end

        end
    end

    ---@type Dist|nil
    local minDistance -- = math.min(unpack(distances))
    for _, d in ipairs(distances) do
        if not minDistance or d.distance < minDistance.distance then
            minDistance = d
        end
    end

    if minDistance and minDistance.distance < 0.15 then
        point = minDistance.measurementRef[minDistance.field]
    else
        point = nil
    end

    return point
end