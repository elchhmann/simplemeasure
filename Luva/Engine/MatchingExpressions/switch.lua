
---@diagnostic disable : lowercase-global

#include "Luva/Engine/MatchingExpressions/matchingBase.lua"


--- Executes a function based on `value`
---@generic T
---@param value T
---@param switchBuilder Luva.Lang.MatchingBaseBuilder<T, fun(): any|nil>
---@return any|nil
switch = function (value, switchBuilder)
    return _LUVA._switch_match(value, switchBuilder, function (result)
        return result()
    end)
end