-- rmb cite the tileset https://free-game-assets.itch.io/free-swamp-2d-tileset-pixel-art

local STI = require "lib.sti"
local Player = require "objects.Player"
local Coin = require "objects.Coin"
local Obstacle = require "objects.Obstacle"

local Map = {}

function Map:load()
    self.currentLevel = 1
    self.lastLevel = 3

    World = love.physics.newWorld(0, 2000)
    World:setCallbacks(beginContact, endContact)

    self:init()
end

function Map:init()
    self.level = STI("map/"..self.currentLevel..".lua", {"box2d"})
    self.level:box2d_init(World)
    self.solidLayer = self.level.layers.solid
    self.groundLayer = self.level.layers.ground
    self.entityLayer = self.level.layers.entity

    self.solidLayer.visible = false
    self.entityLayer.visible = false
    MapWidth = self.groundLayer.width * 32

    self:spawnEntities()
end

function Map:nextLevel()
    self:clean()
    if self.currentLevel + 1 > self.lastLevel then
        -- destroy world change to congrats page
        self.currentLevel = 1
        changeGameState("menu")
    else
        self.currentLevel = self.currentLevel + 1
    end
    
    self:init()
    Player:resetPosition()
end

function Map:clean()
    self.level:box2d_removeLayer("solid")
    Coin:removeAll()
    Obstacle:removeAll()
end

function Map:update(dt)
    if Player.x > MapWidth - 64 then
        self:nextLevel()
    end
    if Player.dead then
        self:clean()
        -- Reload Map entities and Player
        self:load()
        Player:load()

        Player.dead = false
        changeGameState("menu")
    end
end

function Map:spawnEntities()
    for _, i in pairs(self.entityLayer.objects) do
        if i.type == "trap" then
            Obstacle:new(i.x + i.width / 2, i.y + i.height / 2)
        elseif i.type == "coin" then
            Coin:new(i.x, i.y)
        end
    end
end

function beginContact(a, b, collision)
    if Coin:beginContact(a, b, collision) then return end
    if Obstacle:beginContact(a, b, collision) then return end
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end

return Map