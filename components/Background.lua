function Background()
    local backgroundImages = {
        -- Background import from https://opengameart.org/content/generic-platformer-tileset-16x16-background
        -- Cloud is modified (given transparent background)
        cloud = love.graphics.newImage("assets/images/2015-02-26 [DB32](Generic Platformer)(Clouds).png"),
        mountain = love.graphics.newImage("assets/images/2015-02-26 [DB32](Generic Platformer)(Mountains).png")
    }

    return {
        cloud = {
            x = 0,
            speed = -30
        },

        draw = function(self)
            love.graphics.draw(backgroundImages.mountain, 0, 0, 0, love.graphics.getWidth() / 256, love.graphics.getHeight() / 144)
            love.graphics.draw(backgroundImages.cloud, self.cloud.x, self.cloud.y, 0, love.graphics.getWidth() / 256, love.graphics.getHeight() / 144)
        end,

        updateMenuBg = function(self, dt)
            self.cloud.x = self.cloud.x + dt * self.cloud.speed
            if self.cloud.x < - love.graphics.getWidth() then
                self.cloud.x = love.graphics.getWidth()
            end
        end
    }
end

return Background
