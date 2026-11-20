
---@diagnostic disable : lowercase-global

#include "Luva/Engine/MatchingExpressions/matchingBase.lua"


--- Returns another value based on `value`
---@generic T
---@param value T
---@param matchBuilder Luva.Lang.MatchingBaseBuilder<T, any>
match = function (value, matchBuilder)
    return _LUVA._switch_match(value, matchBuilder, function (result)
        return result
    end)
end