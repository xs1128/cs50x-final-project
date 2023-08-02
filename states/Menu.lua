local Button = require "components.Button"
local Text = require "components.Text"
local Menu = {}

function Menu:load()
    self.fontFilePath = "assets/fonts/ThaleahFat.ttf"
    self.mainFont = love.graphics.newFont(self.fontFilePath, 50)
    self.largeFont = love.graphics.newFont(self.fontFilePath, 80)
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
        Button(self.funcs.startNewGame, "Start Game", "center", nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.6),
        Button(nil, "Settings", "center", nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.72),
        Button(self.funcs.quitGame, "Quit Game", "center", nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.84)
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
    love.graphics.setFont(self.largeFont)
    love.graphics.setColor(0.4, 0.4, 0.4)
    Text("CS50 Final Project", 0, (love.graphics.getHeight() * 0.35) + 5, love.graphics.getWidth() + 5, "center", 1):draw()
    love.graphics.setColor(1, 1, 1)
    Text("CS50 Final Project", 0, love.graphics.getHeight() * 0.35, love.graphics.getWidth(), "center", 1):draw()
    love.graphics.setFont(self.mainFont)

    for _, button in pairs(self.buttons) do
        button:draw()
    end 
end

return Menu