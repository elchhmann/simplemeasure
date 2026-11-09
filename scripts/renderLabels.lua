---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global

function renderLabels(i)
    if not measurements[i].set_b then
        if measurements[i].type == "cprect" then
            measurements[i].dimensionx = round(VecLength(VecSub(measurements[i].binv, measurements[i].bprim)), 2)
            measurements[i].dimensiony = round(VecLength(VecSub(measurements[i].binv, measurements[i].aprim)), 2)
        elseif measurements[i].type == "circle" then
            diameter = VecLength(VecSub(measurements[i].binv, measurements[i].blevel))
        elseif measurements[i].type == "2pcircle" then
            diameter = VecLength(VecSub(measurements[i].binv, measurements[i].pos_a))
        else
            measurements[i].dimensionx = round(VecLength(VecSub(measurements[i].pos_a, measurements[i].bprim)), 2)
            measurements[i].dimensiony = round(VecLength(VecSub(measurements[i].pos_a, measurements[i].aprim)), 2)
        end
    end
        
    if measurements[i].type == "cprect" then
        uiX, uiY, UIdist = UiWorldToPixel(measurements[i].pos_a) -- Get the position of the text in the middle of the line [for cprect or circle]
    else
        uiX, uiY, UIdist = UiWorldToPixel(VecLerp(measurements[i].pos_a, measurements[i].pos_b, 0.5)) -- Get the position of the text in the middle of the line
    end

    if measurements[i].type == "2pcircle" or measurements[i].type == "circle" then
        uiX, uiY, UIdist = UiWorldToPixel(measurements[i].center)
    end

    if measurements[i].type == "rect" then
        if measurements[i].orientation == "horizontal" then
            uiX, uiY, UIdist = UiWorldToPixel(VecLerp(measurements[i].pos_a, measurements[i].blevel, 0.5)) -- Get the position of the text in the middle of the line
        else
            uiX, uiY, UIdist = UiWorldToPixel(VecLerp(measurements[i].pos_a, measurements[i].pos_b, 0.5))
        end
    end

    if measurements[i].type == "line" then
        measurements[i].label = string.format("%.2f m", measurements[i].length)
    end

    -- DebugPrint(measurements[i].type)
    if measurements[i].type == "rect" or measurements[i].type == "cprect" then
        measurements[i].label = string.format("%.2f m x %.2f m", measurements[i].dimensionx, measurements[i].dimensiony)
    end

    if measurements[i].type == "circle" then
        measurements[i].label = string.format("%.2f m", diameter)
    end

    if measurements[i].type == "2pcircle" then
        measurements[i].label = string.format("%.2f m", diameter)
    end

    if UIdist > 0 and measurements[i].set_a and measurements[i].length < maxDist then -- Measurement length label
        if (not measurements[i].set_b and dist < maxDist) or measurements[i].set_b then
            UiPush()
                UiFont("bold.ttf", 24)
                UiAlign("center middle")
                UiTranslate(uiX, uiY-15)

                if measurements[i].set_b then
                    UiColor(1,1,1,1)
                    UiTextOutline(0,0,0,5)
                end

                if not measurements[i].set_b then
                    UiColor(1,1,1,0.3)
                end

                local showindex = config.show_index and (i .. ": " .. " ") or ("")
                UiText(showindex .. measurements[i].label)
            UiPop()
        end
    end
end