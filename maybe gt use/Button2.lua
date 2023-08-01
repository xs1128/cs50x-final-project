local Button = {}
local Text = require "components.Text"
Button.__index = Button
local buttons = {}

function Button:new(func, text, text_align, text_color, text_x, text_y, width, height, button_color, btn_x, btn_y, state)
    local instance = setmetatable({}, Button)
    instance.btn_text = {}
    instance.func = func or function() print("Non-Functional Button") end

    -- Set text position relative to button
    if text_x then 
        instance.btn_text.x = btn_x + text_x 
    else instance.btn_text.x = btn_x 
    end
    if text_y then 
        instance.btn_text.y = btn_y + text_y 
    else instance.btn_text.y = btn_y 
    end

    instance.text = text or "No Text"
    instance.text_color = text_color or {r = 1, g = 1, b = 1}
    instance.text_x = text_x or btn_x or 0
    instance.text_y = text_y or btn_y or 0
    instance.width = width or 100
    instance.height = height or 100
    instance.button_color = button_color or {r= 1, g = 1, b = 1, opacity = 0.5}
    instance.btn_x = btn_x or 0
    instance.btn_y = btn_y or 0
    instance.text_component = Text(text, instance.btn_text.x, instance.btn_text.y, "p", width, text_align, 1)
    instance.state = state or "menu"

    table.insert(buttons, instance)
end

function Button:update(mouse_x, mouse_y, clicked)
    for _, instance in pairs(buttons) do
        if instance:checkHover(mouse_x, mouse_y) and clicked then
            love.audio.play(buttonClickSound)
            instance.func()
        end
    end
end

function Button:checkHover(mouse_x, mouse_y)
    if (mouse_x >= self.btn_x) and (mouse_x <= self.btn_x + self.width) then
        if (mouse_y >= self.btn_y) and (mouse_y <= self.btn_y + self.height) then
            return true
        end
    end
    return false
end

function Button:draw()
    for _, instance in pairs(buttons) do
        -- Draw and emphasize visually button box by controlling opacity
        love.graphics.setColor(instance.button_color.r, instance.button_color.g, instance.button_color.b, instance.button_color.opacity)
        love.graphics.rectangle("fill", instance.btn_x, instance.btn_y, instance.width, instance.height)
        love.graphics.setColor(1, 1, 1, 1)

        instance.text_component:setColor(instance.text_color["r"], instance.text_color["g"], instance.text_color["b"])
        instance.text_component:draw()
    end
end

function Button:setButtonColor(red, green, blue)
    self.button_color = {r = red, g = green, b = blue}
end

function Button:setTextColor(red, green, blue)
    self.text_color = {r = red, g = green, b = blue}
end

return Button