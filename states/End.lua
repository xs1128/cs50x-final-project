local Button = require "components.Button"
local Text = require "components.Text"

local End = {}

function End:load()
    self.text = "lol"
    self.funcs = {
        backToMenu = function() changeGameState("menu") end,
        retry = function() changeGameState("running") end
    }
    self.buttons = {
        Button(self.funcs.retry, "Retry Game", "center", nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.6),
        Button(self.funcs.backToMenu, "Back To Menu", "center", nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.72)
    }    
end

function End:update(dt) end

function End:runButtonFunction(clicked)
    for name, button in pairs(self.buttons) do
        if button:checkHover(mouse_x, mouse_y) then
            if clicked then
                love.audio.play(audio.buttonClickSound)
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
    Text(self.text, 0, love.graphics.getHeight() * 0.3, love.graphics.getWidth(), "center", 1):draw()
    love.graphics.setFont(mainFont)

    -- Draw all buttons
    for _, button in pairs(self.buttons) do
        button:draw()
    end
end

return End