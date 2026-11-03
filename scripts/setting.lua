---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
---@diagnostic disable : exp-in-action

function setting(row, text, param)
    bool = config[param] and "media/setting_true.png" or "media/setting_false.png"

    UiPush()
        UiTranslate(0 , (row-1)*(config.SETTING_SPACING*2 + config.SETTING_SIZE))
        if UiImageButton(bool) then
            config[param] = not config[param]
        end
        UiPush()
            UiTranslate(100, 1)
            UiTextAlignment("left")
            UiText(text)
        UiPop()
    UiPop()
end