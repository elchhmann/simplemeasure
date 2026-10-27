---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
---@diagnostic disable : exp-in-action

function round(value, decimals)
    local factor = 10 ^ decimals
    local scaled = value * factor

    if scaled >= 0 then
        return math.floor(scaled + 0.5) / factor
    else
        return math.ceil(scaled - 0.5) / factor
    end
end