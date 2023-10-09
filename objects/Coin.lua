local Coin = {}
local Player = require "objects.Player"
Coin.__index = Coin
local activeCoins = {}

function Coin:new(x, y)
    local instance = setmetatable({}, Coin)
    instance.x = x
    instance.y = y
    instance.width = 30
    instance.height = 30
    instance.scaleX = 2
    instance.toBeRemoved = false

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)

    -- Coin spritesheet and animation
    anim8 = require "lib.anim8"
    instance.spriteSheet = love.graphics.newImage("assets/images/free-swamp-game-tileset-pixel-art/4 Animated objects/Coin.png")
    instance.spriteWidth = 10
    instance.spriteHeight = 10
    instance.animation = {
        scale_x = 3,
        scale_y = 3
    }

    instance.grid = anim8.newGrid(instance.spriteWidth, instance.spriteHeight, instance.spriteSheet:getWidth(), instance.spriteSheet:getHeight())
    instance.animation.spin = anim8.newAnimation(instance.grid('1-4', 1), 1 / 3)
    instance.anim = instance.animation.spin

    table.insert(activeCoins, instance)
end

function Coin:update(dt)
    self.anim:update(dt)
    self:checkRemove()
end

function Coin:updateAll(dt)
    for _, instance in pairs(activeCoins) do
        instance:update(dt)
    end
end

function Coin:checkRemove()
    if self.toBeRemoved then
        self:remove()
    end
end

function Coin:draw()
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, self.animation.scale_x, self.animation.scale_y, self.spriteWidth / 2, self.spriteHeight / 2)
end

function Coin:drawAll()
    for _, instance in pairs(activeCoins) do
        instance:draw()
    end
end

function Coin:remove()
    for _, instance in pairs(activeCoins) do
        if instance == self then
            self.physics.body:destroy()
            table.remove(activeCoins, _)
            Player:incrementCoins()
        end
    end
end

function Coin:removeAll()
    for _,i in pairs(activeCoins) do
        i.physics.body:destroy()
    end

    activeCoins = {}
end

function Coin:beginContact(a, b, collision)
    for _, instance in pairs(activeCoins) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                instance.toBeRemoved = true
                return true
            end
        end
    end
end

return Coin