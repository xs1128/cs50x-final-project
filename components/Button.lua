local Text = require "components.Text"

-- Get every properties for button
function Button(func, text, text_align, text_x, text_y, width, height, button_color, btn_x, btn_y)
    local btn_text = {}
    -- For debugging
    func = func or function() print("Non-Functional Button") end

    -- Set text position relative to button
    if text_x then 
        btn_text.x = btn_x + text_x 
    else btn_text.x = btn_x 
    end
    if text_y then 
        btn_text.y = btn_y + text_y 
    else btn_text.y = btn_y 
    end

    return {
        -- Set properties and their default if is null
        text = text or "No Text",
        text_x = text_x or btn_x or 0,
        text_y = text_y or btn_y or 0,
        width = width or 100,
        height = height or 100,
        button_color = button_color or {r= 1, g = 1, b = 1, opacity = 0.5},
        btn_x = btn_x or 0,
        btn_y = btn_y or 0,
        text_component = Text(text, btn_text.x, btn_text.y, width, text_align, 1),

        setButtonColor = function(self, red, green, blue)
            self.button_color = {r = red, g = green, b = blue}
        end,

        -- Function to check if mouse hovering on button to change color for some buttons
        checkHover = function(self, mouse_x, mouse_y)
            if (mouse_x >= self.btn_x) and (mouse_x <= self.btn_x + self.width) then
                if (mouse_y >= self.btn_y) and (mouse_y <= self.btn_y + self.height) then
                    return true
                end
            end
            return false
        end,

        -- Execute function attached to the button triggered
        click = function(self)
            func()
        end,

        draw = function(self)
            -- Draw and emphasize visually button box by controlling opacity
            love.graphics.setColor(self.button_color.r, self.button_color.g, self.button_color.b, self.button_color.opacity)
            love.graphics.rectangle("fill", self.btn_x, self.btn_y, self.width, self.height)
            love.graphics.setColor(1, 1, 1, 1)

            self.text_component:draw()
        end
    }
end

return Button
