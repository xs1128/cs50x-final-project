local Camera = {
    x = 0,
    y = 0,
    scale = 1
}

-- Functions to apply camer view on and pop off when needed
function Camera:apply()
    love.graphics.push()
    love.graphics.scale(self.scale, self.scale)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:clear()
    love.graphics.pop() 
end

function Camera:setPosition(x, y)
    -- Camera following player movement
    self.x = x - love.graphics.getWidth() / 2 / self.scale
    self.y = y
    local RS = self.x + love.graphics.getWidth() / 2

    -- Limit camera if map is reaching end
    if self.x < 0 then
        self.x = 0
    elseif RS > MapWidth - love.graphics.getWidth() / 2 then
        self.x = MapWidth - love.graphics.getWidth()
    end
end

return Camera