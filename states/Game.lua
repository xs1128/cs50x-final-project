local Text = require "components.Text"
local Map = require "components.Map"
local Player = require "objects.Player"
local Camera = require "components.Camera"
local Coin = require "objects.Coin"
local Obstacle = require "objects.Obstacle"

local Game = {}

function Game:load()
    self.state = { 
        menu = true,
        running = false,
        paused = false,
        ended = false
    }

    Map:load()
    Player:load()
end

function Game:update(dt)
    Camera:setPosition(Player.x, 0)
    Map:update(dt)
    Player:update(dt)
    Coin:updateAll(dt)
    if self.state.menu then
        Map:update(dt)
    end
end

function Game:draw(faded)
    Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)

    Camera:apply()
    Coin:drawAll()
    Obstacle:drawAll()
    Player:draw()
    Camera:clear()
    
    if faded then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1, 1)
        Text("Game Paused", 0, love.graphics.getHeight() * 0.3, love.graphics.getWidth(), "center", 1):draw()
    end
end

function Game:keypress(key)
    if self.state.running then
        Player:jump(key)
    end
end

return Game