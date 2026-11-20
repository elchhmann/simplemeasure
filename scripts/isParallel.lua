---@diagnostic disable : lowercase-global

function isParallel(a, b, i)
    local x = 1
    local y = 2
    local z = 3
    
    if a[y] == b[y] then
        if (a[x] == b[x]) or (a[z] == b[z]) then
            return true
        else
            return false
        end
    else
        if (a[x] == b[x]) and (a[z] == b[z]) then
            return true
        else
            return false
        end
    end
end