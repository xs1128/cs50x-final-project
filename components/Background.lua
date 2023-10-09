local Map = require "components.Map"

local Background = {}

function Background:load()
    self:loadAssets()
    self.cloudX = 0
    self.cloudSpeed = -30
end

function Background:loadAssets()
    -- Backgound image path in folder
    self.cloud = love.graphics.newImage("assets/images/2015-02-26 [DB32](Generic Platformer)(Clouds).png")
    self.mountain = love.graphics.newImage("assets/images/2015-02-26 [DB32](Generic Platformer)(Mountains).png")
end

function Background:update(dt, paused)
    -- Update cloud position for moving animation
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
    -- Draw background following the levels
    if state == "menu" then
        self:drawImage()
    elseif state == "running" then
        if Map.currentLevel == 1 then
            self:drawImage()
        elseif Map.currentLevel == 2 then
            self:drawImage()
            self:tintColor("evening0")
        elseif Map.currentLevel == 3 then
            self:drawImage()
            self:tintColor("evening1")
        end
    end
end

function Background:drawImage()
    love.graphics.draw(self.mountain, 0, 0, 0, love.graphics.getWidth() / 256, love.graphics.getHeight() / 144)
    love.graphics.draw(self.cloud, self.cloudX, 0, 0, love.graphics.getWidth() / 256, love.graphics.getHeight() / 144)
end

function Background:tintColor(time)
    -- Tint orange for evening colors
    if time == "evening0" then
        love.graphics.setColor(0.96, 0.5, 0.19, 0.1)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1 ,1)
    elseif time == "evening1" then
        love.graphics.setColor(0.96, 0.5, 0.19, 0.2)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        love.graphics.setColor(1, 1 ,1)
    else
        love.graphics.setColor(1, 1 ,1)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end
end

return Background