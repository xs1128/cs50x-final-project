local Text = require "components.Text"
local Map = require "components.Map"
local Player = require "objects.Player"
local Camera = require "components.Camera"

local Game = {}

function Game:load()
    Map:load()
    Player:load()
    -- Table to store game states
    self.state = { 
        menu = true,
        running = false,
        paused = false,
        ended = false
    }
end

function Game:update(dt)
    Map:update(dt)
    Player:update(dt)
end

function Game:draw(faded)
    Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)

    Camera:apply()
    Player:draw()
    Camera:clear()
    
    if faded then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        Text("Game Paused", 0, love.graphics.getHeight() * 0.3, love.graphics.getWidth(), "center", 1):draw()
    end
end

return Game