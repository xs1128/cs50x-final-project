local Button = require "components.Button"
local Text = require "components.Text"

local Quit = {}

function Quit:load()
    self:loadAssets()
    self.mainFont = love.graphics.newFont(self.fontFilePath, 50)
    self.largeFont = love.graphics.newFont(self.fontFilePath, 60)
    self.funcs = {
        backToMenu = function()
            game:changeGameState("menu")
        end,

        quitGame = function()
            love.event.quit()
        end
    }
    self.buttons = {
        -- Quit Button (color not set)
        Button(self.funcs.backToMenu, "Back To Menu", "center", nil, nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.60),
        Button(self.funcs.quitGame, "Confirm", "center", nil, nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.75)
    }    

end

function Quit:loadAssets()
    self.fontFilePath = "assets/fonts/ThaleahFat.ttf"
end

function Quit:update(dt)
    self:runButtonFunction()
end

function Quit:runButtonFunction(clicked)
    for name, button in pairs(self.buttons) do
        if button:checkHover(mouse_x, mouse_y) then
            if clicked then
                love.audio.play(buttonClickSound)
                button:click()
            end
            button:setButtonColor(0.8, 0, 0)
        else
            button:setButtonColor(0.5, 0.5, 0.5)
        end
    end
end

function Quit:draw()
    love.graphics.setFont(self.largeFont)
    Text("Are You Sure To Quit The Game?", 0, love.graphics.getHeight() * 0.3, nil, love.graphics.getWidth(), "center", 1):draw()
    love.graphics.setFont(self.mainFont)

    for _, button in pairs(self.buttons) do
        button:draw()
    end
end

return Quit