local Button = require "components.Button"
local Menu = {}

function Menu:load()
    self.funcs = { 
        startNewGame = function()
            changeGameState("running")
        end,

        quitGame = function()
            changeGameState("quit")
        end
    }
    self.buttons = {
        -- Quit Button (color not set)
        Button(self.funcs.startNewGame, "Start Game", "center", nil, nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.50),
        Button(nil, "Settings", "center", nil, nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.65),
        Button(self.funcs.quitGame, "Quit Game", "center", nil, nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.80)
    }
end

function Menu:update(dt)

end

function Menu:runButtonFunction(clicked)
    for name, button in pairs(self.buttons) do
        if button:checkHover(mouse_x, mouse_y) and clicked then
            love.audio.play(buttonClickSound)
            button:click()
        end
    end
end

function Menu:draw()
    for _, button in pairs(self.buttons) do
        button:draw()
    end 
end

return Menu