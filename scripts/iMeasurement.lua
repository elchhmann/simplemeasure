---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
---@diagnostic disable : exp-in-action

local tremove = table.remove

function iMeasurement(i)

    local measurement = measurements[i]

    UiPush()
        UiTranslate(
            0,
            (i - 1) * (config.SETTING_SPACING * 2 + config.SETTING_SIZE - 9)
        )

        UiPush()
            -- text = i .. ": " .. "Type: " .. measurements[i].type .. " Length: " .. round(measurements[i].length, 2) .. "m"
            UiPush()
                UiTranslate(335)

                UiScale(config.SETTING_SIZE / config.BUTTON_SIZE)

                local ilabel

                if measurement.type == "comp" then
                    compoundPoints = { measurement.pos_a, measurement.bprim, measurement.blevel, measurement.pos_b }

                    ilabel = string.format(
                        "%.2f m x %.2f m %.2f m",
                        VecLength(
                            VecSub(compoundPoints[1], compoundPoints[2])
                        ),
                        VecLength(
                            VecSub(compoundPoints[2], compoundPoints[3])
                        ),
                        VecLength(
                            VecSub(compoundPoints[3], compoundPoints[4])
                        )
                    )
                else
                    ilabel = measurement.label
                end

                local scale = UiGetScale()
                local image = not measurement.hidden and "media/button_show.png" or "media/button_hide.png"
                local text = i .. ": " .. measurement.type .. " " .. ilabel
                local w = UiGetTextSize(text) / 2

                if UiImageButton("/media/clear.png") then
                    tremove(measurements, i)
                end

                UiTranslate(25 / scale)

                if UiImageButton(image) then
                    measurement.hidden = not measurement.hidden
                end

                UiTranslate(25 / scale) -- marking
                if UiImageButton("/media/button_mark.png") then
                    local sm = { measurement }
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