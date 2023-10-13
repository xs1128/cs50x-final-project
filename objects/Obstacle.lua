local Obstacle = {image = love.graphics.newImage("assets/images/spike.png")}
local Player = require "objects.Player"
Obstacle.__index = Obstacle
Obstacle.width = Obstacle.image:getWidth()
Obstacle.height = Obstacle.image:getHeight()
local activeObstacle = {}

-- Insert new obstacle into metatable
function Obstacle:new(x, y)
    local instance = setmetatable({}, Obstacle)
    instance.x = x
    instance.y = y

    instance.damage = 1
    
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World, instance.x, instance.y, "static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
    instance.physics.fixture:setSensor(true)

    table.insert(activeObstacle, instance)
end

function Obstacle:update(dt) end

function Obstacle:updateAll()
    -- In case of additional animation or updates
    for _, instance in pairs(activeObstacle) do
        instance:update(dt)
    end
end

function Obstacle:draw()
    love.graphics.draw(self.image, self.x,self.y, 0, 1, 1, self.width / 2, self.height / 2)
end

function Obstacle:drawAll()
    -- Draw all obstacles in table
    for _, instance in pairs(activeObstacle) do
        instance:draw()
    end
end

function Obstacle:removeAll()
    -- Destroy all obstacles in level
    for _,i in pairs(activeObstacle) do
        i.physics.body:destroy()
    end

    -- Set empty obstacle table
    activeObstacle = {}
end

function Obstacle:beginContact(a, b, collision)
    for _, instance in pairs(activeObstacle) do
        if a == instance.physics.fixture or b == instance.physics.fixture then
            if a == Player.physics.fixture or b == Player.physics.fixture then
                Player:takeDamage(instance.damage)
                return true
            end
        end
    end
end

return Obstacle
