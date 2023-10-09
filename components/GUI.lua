local Player = require "objects.Player"
local GUI = {}

function GUI:load()
    -- Coin and heart properties shown when game running
    self.coins = {}
    self.coins.image = love.graphics.newImage("assets/images/Coin.png")
    self.coins.width = self.coins.image:getWidth()
    self.coins.height = self.coins.image:getHeight()
    self.coins.scale = 3
    self.coins.x = love.graphics.getWidth() - 200
    self.coins.y = 25

    self.hearts = {}
    self.hearts.image = love.graphics.newImage("assets/images/Heart.png")
    self.hearts.width = self.hearts.image:getWidth()
    self.hearts.height = self.hearts.image:getHeight()
    self.hearts.x = 0
    self.hearts.y = 30
    self.hearts.scale = 3
    self.hearts.spacing = self.hearts.width * self.hearts.scale + 20
end

function GUI:update(dt) end

function GUI:draw()
    -- Draw hearts and coins
    for i = 1, Player.healths.current do
        local x = self.hearts.x + self.hearts.spacing * i
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.draw(self.hearts.image, x + 2, self.hearts.y + 2, 0, self.hearts.scale, self.hearts.scale)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(self.hearts.image, x, self.hearts.y, 0, self.hearts.scale, self.hearts.scale) 
    end

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.draw(self.coins.image, self.coins.x + 2, self.coins.y + 2, 0, self.coins.scale, self.coins.scale)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.coins.image, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)

    local x = self.coins.x + self.coins.width * self.coins.scale
    local y = self.coins.y + (self.coins.height / 2) * self.coins.scale - self.coins.height * 2.3
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.print(" : " .. Player.coins, x + 2, y + 2)
    
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(" : " .. Player.coins, x, y)
end

return GUI