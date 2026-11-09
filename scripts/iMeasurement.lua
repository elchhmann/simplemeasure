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

            UiPush()
                UiTranslate(w, 1)
                UiTextAlignment("left")
                UiText(text)
            UiPop()
            
            UiPush()
                UiTranslate(335)

                UiScale(20/128)

                local scale = UiGetScale()


                
                -- if UiImageButton("/media/clear.png") then
                --     table.remove(measurements, i)
                -- end
                
                UiTranslate(25/scale)

                local bool = not measurements[i].hidden and "media/button_show.png" or "media/button_hide.png"
                
                if UiImageButton(bool) then
                    measurements[i].hidden = not measurements[i].hidden
                end

                -- UiTranslate(25)
                -- if UiImageButton(bool) then
                --     -- mark
                -- end

                -- UiTranslate(25)
                -- if UiImageButton(bool) then
                --     -- share
                -- end
            UiPop()
        UiPop()
    UiPop()
end