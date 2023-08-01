-- temporarily not used, refer to Quit.lua for latest quit file

local Button = require "components.Button"
local Text = require "components.Text"

function Quit()
    -- Set different font sizes
    local path = "assets/fonts/ThaleahFat.ttf"
    local mainFont = love.graphics.newFont(path, 50)
    local largeFont = love.graphics.newFont(path, 60)

    -- Table for functions and buttons
    local funcs = {
        backToMenu = function()
            game:changeGameState("menu")
        end,

        quitGame = function()
            love.event.quit()
        end
    }
    local buttons = {
        -- Quit Button (color not set)
        Button(funcs.backToMenu, "Back To Menu", "center", nil, nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.60),
        Button(funcs.quitGame, "Confirm", "center", nil, nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.75)
    }

    return {
        
        run = function(self, clicked)
            for name, button in pairs(buttons) do
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
        end,

        draw = function(self)
            -- Draw a box with 2 button
            love.graphics.setFont(largeFont)
            Text("Are You Sure To Quit The Game?", 0, love.graphics.getHeight() * 0.3, nil, love.graphics.getWidth(), "center", 1):draw()
            love.graphics.setFont(mainFont)
            for _, button in pairs(buttons) do
                button:draw()
            end
            
        end
    }
end

return Quit
