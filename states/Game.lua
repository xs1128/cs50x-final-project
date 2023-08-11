local Text = require "components.Text"
local Button = require "components.Button"
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
        ended = false,
        quit = false
    }

    self.funcs = { 
        backToGame = function() changeGameState("running") end,
        settings = function() changeGameState("setting") end,
        backToMenu = function() 
            Map:clean()
            -- Reload Map entities and Player
            Map:load()
            Player:load()

            changeGameState("menu") 
        end
    }

    self.pausedButtons = {
        Button(self.funcs.backToGame, "Back to Game", "center", nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.5),
        Button(self.funcs.settings, "Settings", "center", nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.62),
        Button(self.funcs.backToMenu, "Back to Menu", "center", nil, nil, love.graphics.getWidth() / 3, 50, nil, love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.74)
    }

    Map:load()
    Player:load()
end

function Game:update(dt)
    Camera:setPosition(Player.x, 0)
    Map:update(dt)
    Player:update(dt)
    Coin:updateAll(dt)
end

function Game:runButtonFunction(clicked)
    for name, button in pairs(self.pausedButtons) do
        if button:checkHover(mouse_x, mouse_y) and clicked then
            love.audio.play(buttonClickSound)
            button:click()
        end
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
        love.graphics.setColor(1, 1, 1, 1)
        Text("Game Paused", 0, love.graphics.getHeight() * 0.3, love.graphics.getWidth(), "center", 1):draw()

        for _, button in pairs(self.pausedButtons) do
            button:draw()
        end 
    end
end

function Game:keypress(key)
    if self.state.running then
        Player:jump(key)
    end
end

return Game