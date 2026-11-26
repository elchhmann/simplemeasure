---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
---@diagnostic disable : exp-in-action

local insert, sort = table.insert, table.sort
local names = { "deltaX", "deltaY", "deltaZ" }

local function _sorter(a, b)
    return a > b
end

function maxName(deltas)
    local copy, result = { }, { }

    for _, v in ipairs(deltas) do insert(copy, v) end

    sort(copy, _sorter)

    for _, biggestValue in ipairs(copy) do
        for index, value in pairs(deltas) do
            if biggestValue == value then
                insert(result, names[index])
                break
            end
        end

        if #result == 2 then
            return result
        end
    end
end