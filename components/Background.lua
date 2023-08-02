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

function Background:update(dt, paused)
    self:movingCloud(dt, paused)
end

function Background:movingCloud(dt, paused)
    if not paused then
        self.cloudX = self.cloudX + dt * self.cloudSpeed
        if self.cloudX < - love.graphics.getWidth() then
            self.cloudX = love.graphics.getWidth()
        end
    end
end

function Background:draw(state)
    if state == "menu" then
        love.graphics.draw(self.mountain, 0, 0, 0, love.graphics.getWidth() / 256, love.graphics.getHeight() / 144)
        love.graphics.draw(self.cloud, self.cloudX, 0, 0, love.graphics.getWidth() / 256, love.graphics.getHeight() / 144)
    elseif state == "running" then
        love.graphics.draw(self.mountain, 0, 0, 0, love.graphics.getWidth() / 256, love.graphics.getHeight() / 144)
        love.graphics.draw(self.cloud, self.cloudX, 0, 0, love.graphics.getWidth() / 256, love.graphics.getHeight() / 144)
    end
    
end

return Background