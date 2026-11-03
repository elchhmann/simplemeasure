---@diagnostic disable : undefined-global
---@diagnostic disable : lowercase-global
---@diagnostic disable : exp-in-action

function button(row, column, filepath, text, text2, action)
    UiPush()
        UiTranslate((column-1)*(config.BUTTON_SIZE + config.BUTTON_SPACING_HORIZONTAL), (row-1)*(config.BUTTON_SPACING_VERTICAL*2 + config.BUTTON_SIZE))
        if UiImageButton(filepath) then
            action()
        end
        UiPush()
            UiTranslate(0, 80)
            UiText(text)
            UiTranslate(0, 25)
            UiText(text2)
        UiPop()
    UiPop()
end