---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
---@diagnostic disable : exp-in-action

function iMeasurement(i, type, label)
    UiPush()
        UiTranslate(0 , (i-1)*(config.SETTING_SPACING*2 + config.SETTING_SIZE - 9))

        UiPush()
            -- text = i .. ": " .. "Type: " .. measurements[i].type .. " Length: " .. round(measurements[i].length, 2) .. "m"
            
            UiPush()
                UiTranslate(335)

                UiScale(20/128)

                local scale = UiGetScale()
                local image = not measurements[i].hidden and "media/button_show.png" or "media/button_hide.png"
                local text = i .. ": " .. "Type: " .. measurements[i].type .. " " .. measurements[i].label
                local w = (UiGetTextSize(text) / 2)
                
                if UiImageButton("/media/clear.png") then
                    table.remove(measurements, i)
                end
                
                UiTranslate(25/scale)

                
                if UiImageButton(image) then
                    measurements[i].hidden = not measurements[i].hidden
                end

                -- UiTranslate(25)
                -- if UiImageButton(image) then
                --     -- mark
                -- end

                -- UiTranslate(25)
                -- if UiImageButton(image) then
                --     -- share
                -- end
            UiPop()



            UiPush()
                UiTranslate(w, 1)
                UiTextAlignment("left")
                UiText(text)
            UiPop()
        UiPop()
    UiPop()
end