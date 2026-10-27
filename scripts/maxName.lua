---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
---@diagnostic disable : exp-in-action

function maxName(deltas)
    local copy = { }
    local names = { "deltaX", "deltaY", "deltaZ" }
    for _, v in ipairs(deltas) do table.insert(copy, v) end
    
    table.sort(copy, function (a, b) return a > b end)
    
    local result = { }
    
    for biggestKey, biggestValue in ipairs(copy) do
        for index, value in pairs(deltas) do
            if biggestValue == value then
                table.insert(result, names[index])
                break
            end
        end
        
        if #result == 2 then
            return result
        end
    end
end