---@diagnostic disable: lowercase-global

function displayPresets()

    local i = 0
    local x = 40 -- size of the buttons
    local y = x * 1.5 -- spacing

    for k, v in ipairs(colorPreset) do
        if i % 3 == 0 then
            UiTranslate(-3 * y, y)
        end

        UiColor(unpack(v))

        UiRect(x, x)

        if UiBlankButton(x,x) then
            slider_red = v[1] * 255
            slider_green = v[2] * 255
            slider_blue = v[3] * 255
        end

        UiTranslate(y, 0)

        i = i + 1
    end
end