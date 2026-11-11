---@diagnostic disable : lowercase-global

function isParallel(i)
    local x = 1
    local y = 2
    local z = 3
    
    if measurements[i].pos_a[y] == measurements[i].pos_b[y] then
        if (measurements[i].pos_a[x] == measurements[i].pos_b[x]) or (measurements[i].pos_a[z] == measurements[i].pos_b[z]) then
            return true
        else
            return false
        end
    else
        if (measurements[i].pos_a[x] == measurements[i].pos_b[x]) and (measurements[i].pos_a[z] == measurements[i].pos_b[z]) then
            return true
        else
            return false
        end
    end
end