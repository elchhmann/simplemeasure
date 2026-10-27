---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global

function renderLabels(i)
    if measurements[i].type == "cprect" then
        dimensionx = VecLength(VecSub(binv, bprim))
        dimensiony = VecLength(VecSub(binv, aprim))
    else
        dimensionx = VecLength(VecSub(measurements[i].pos_a, bprim))
        dimensiony = VecLength(VecSub(measurements[i].pos_a, aprim))
    end
        
    if measurements[i].type == "cprect" then
        uiX, uiY, UIdist = UiWorldToPixel(measurements[i].pos_a) -- Get the position of the text in the middle of the line [for cprect]
    else
        uiX, uiY, UIdist = UiWorldToPixel(VecLerp(measurements[i].pos_a, measurements[i].pos_b, 0.5)) -- Get the position of the text in the middle of the line
    end

    if measurements[i].type == "rect" then
        if orientation == "horizontal" then
            uiX, uiY, UIdist = UiWorldToPixel(VecLerp(measurements[i].pos_a, blevel, 0.5)) -- Get the position of the text in the middle of the line
        else
            uiX, uiY, UIdist = UiWorldToPixel(VecLerp(measurements[i].pos_a, measurements[i].pos_b, 0.5))
        end
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

                if measurements[i].type == "line" then
                    UiText(string.format("%.2f m", measurements[i].length))  
                end

                -- DebugPrint(measurements[i].type)
                if measurements[i].type == "rect" or measurements[i].type == "cprect" then
                    UiText(string.format("%.2f m x %.2f m", dimensionx, dimensiony))
                end
            UiPop()
        end
    end
end