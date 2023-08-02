local Text = require "components.Text"
local Background = require "components.Background"

local Game = {}

function Game:load()
    -- Table to store game states
    self.state = { 
        menu = true,
        running = false,
        paused = false,
        ended = false
    }
end

function Game:update(dt)

end

function Game:draw(faded)
    if faded then
        Text("Game Paused", 0, love.graphics.getHeight() * 0.3, nil, love.graphics.getWidth(), "center", 1):draw()
    end
end

return Game