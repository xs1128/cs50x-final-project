local Button = require "components.Button"
local Text = require "components.Text"

local End = {}

function End:load()
    self.funcs = {
        backToMenu = function() changeGameState("menu") end
    }
    self.buttons = {
        Button(self.funcs.backToMenu, "Back To Menu", "center", nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.72),
    }    

end

function End:update(dt)
    self:runButtonFunction()
end

function End:runButtonFunction(clicked)
    for name, button in pairs(self.buttons) do
        if button:checkHover(mouse_x, mouse_y) then
            if clicked then
                love.audio.play(buttonClickSound)
                button:click()
            end
            button:setButtonColor(0, 0.8, 0)
        else
            button:setButtonColor(0.5, 0.5, 0.5)
        end
    end
end

function End:draw()
    love.graphics.setFont(largeFont)
    Text("Congratulation on Passing through the Game!", 0, love.graphics.getHeight() * 0.3, love.graphics.getWidth(), "center", 1):draw()
    love.graphics.setFont(mainFont)

    for _, button in pairs(self.buttons) do
        button:draw()
    end
end

return End