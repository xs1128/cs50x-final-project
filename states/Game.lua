local Text = require "components.Text"
local Background = require "components.Background"

function Game()
    
    return {
        -- Table to store game states
        state = { 
            menu = true,
            running = false,
            paused = false,
            ended = false
        },

        -- Function to alter game state 
        changeGameState = function (self, state)
            self.state.menu = state == 'menu'
            self.state.running = state == 'running'
            self.state.paused = state == 'paused'
            self.state.ended = state == 'ended'
            self.state.quit = state == 'quit'
        end,

        draw = function(self, faded)
            if faded then
                Text("Game Paused", 0, love.graphics.getHeight() * 0.3, nil, love.graphics.getWidth(), "center", 1):draw()
            end
            -- Draw Game 

        end,

        update = function(self, dt)
        end,
 
        startNewGame = function(self) self:changeGameState("running") end
        
    }

end

return Game
