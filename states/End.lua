local Button = require "components.Button"
local Text = require "components.Text"

local End = {}

function End:load()
    -- Initialize end text, end coins, functions for buttons and the buttons
    self.text = "404"
    self.coins = 0
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
    Text("Coins: "..self.coins.. " / 131", 0, love.graphics.getHeight() * 0.5, love.graphics.getWidth(), "center", 1):draw()

    -- Print different text according to player coins obtained
    if self.coins <= 30 then
        love.graphics.printf("Seems like you've been dodging the coins", love.graphics.getWidth() / 4, love.graphics.getHeight() * 0.4, love.graphics.getWidth(), "center", 0, 0.5)
    elseif self.coins == 131 then
        love.graphics.printf("All coins obtained", love.graphics.getWidth() / 4, love.graphics.getHeight() * 0.4, love.graphics.getWidth(), "center", 0, 0.5)
    end

    -- Draw all buttons
    for _, button in pairs(self.buttons) do
        button:draw()
    end
end

return End