---@diagnostic disable : lowercase-global
---@diagnostic disable : undefined-doc-param


---@generic TKey
---@param array table<TKey, any>
---@param element any
---@return TKey|nil

function indexOf(array, element) -- lovies aleq
    for k, v in pairs(array) do
        if v == element then return k end
    end

    return nil
end
