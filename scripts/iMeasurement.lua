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

                local ilabel

                if measurements[i].type == "comp" then
                    compoundPoints = {measurements[i].pos_a, measurements[i].bprim, measurements[i].blevel, measurements[i].pos_b}

                    ilabel = string.format("%.2f m x %.2f m %.2f m", VecLength(VecSub(compoundPoints[1], compoundPoints[2])), VecLength(VecSub(compoundPoints[2], compoundPoints[3])), VecLength(VecSub(compoundPoints[3], compoundPoints[4])))
                else
                    ilabel = measurements[i].label
                end
                local scale = UiGetScale()
                local image = not measurements[i].hidden and "media/button_show.png" or "media/button_hide.png"
                local text = i .. ": " .. measurements[i].type .. " " .. ilabel
                local w = (UiGetTextSize(text) / 2)
                
                if UiImageButton("/media/clear.png") then
                    table.remove(measurements, i)
                end
                
                UiTranslate(25/scale)

                
                if UiImageButton(image) then
                    measurements[i].hidden = not measurements[i].hidden
                end

                UiTranslate(25/scale) -- marking
                if UiImageButton("/media/button_mark.png") then
                    local sm = {measurements[i]}
                    ServerCall("server.mark", sm, slider_red_value, slider_green_value, slider_blue_value)
                    -- DebugPrint(slider_red_value)
                    -- DebugPrint(measurements[i])
                end

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