local Button = require "components.Button"

function Menu()

    local funcs = {
        startNewGame = function()
            game:startNewGame()
        end,

        quitGame = function()
            game:changeGameState("quit")
        end
    }
    local buttons = {
        -- Quit Button (color not set)
        Button(funcs.startNewGame, "Start Game", "center", nil, nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.50),
        Button(nil, "Settings", "center", nil, nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.65),
        Button(funcs.quitGame, "Quit Game", "center", nil, nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.80)
    }
    
    return {
        -- Run the function on button if is clicked
        run = function(self, clicked)
            for name, button in pairs(buttons) do
                if button:checkHover(mouse_x, mouse_y) and clicked then
                    love.audio.play(buttonClickSound)
                    button:click()
                end
            end
        end,

        -- Draw each button
        draw = function(self)
            --Background:draw()
            for _, button in pairs(buttons) do
                button:draw()
            end   
        end
    }
end

return Menu
