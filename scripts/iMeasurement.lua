---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
---@diagnostic disable : exp-in-action

function iMeasurement(i)
    UiPush()
        UiTranslate(0 , (i-1)*(config.SETTING_SPACING*2 + config.SETTING_SIZE - 9))

        UiPush()
            -- text = i .. ": " .. "Type: " .. measurements[i].type .. " Length: " .. round(measurements[i].length, 2) .. "m"

            text = i .. ": " .. "Type: " .. measurements[i].type .. " " .. measurements[i].label

            local w = (UiGetTextSize(text) / 2)

            UiTranslate(w, 1)
            UiTextAlignment("left")
            UiText(text)
            
        UiPop()
    UiPop()
end