---@diagnostic disable : lowercase-global

function isParallel(a, b)
    local x = 1
    local y = 2
    local z = 3
    
    if a[y] == b[y] then
        return (a[x] == b[x]) or (a[z] == b[z])
    else
        return (a[x] == b[x]) and (a[z] == b[z])
    end
end