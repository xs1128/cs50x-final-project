local Background = {}

function Background:load()
    self:loadAssets()
    self.cloudX = 0
    self.cloudSpeed = -30
end

function Background:loadAssets()
    self.cloud = love.graphics.newImage("assets/images/2015-02-26 [DB32](Generic Platformer)(Clouds).png")
    self.mountain = love.graphics.newImage("assets/images/2015-02-26 [DB32](Generic Platformer)(Mountains).png")
end

function Background:update(dt)
    Background:movingCloud(dt)
end

function Background:movingCloud(dt)
    self.cloudX = self.cloudX + dt * self.cloudSpeed
    if self.cloudX < - love.graphics.getWidth() then
        self.cloudX = love.graphics.getWidth()
    end
end

function Background:draw()
    love.graphics.draw(self.mountain, 0, 0, 0, love.graphics.getWidth() / 256, love.graphics.getHeight() / 144)
    love.graphics.draw(self.cloud, self.cloudX, 0, 0, love.graphics.getWidth() / 256, love.graphics.getHeight() / 144)
end

return Background