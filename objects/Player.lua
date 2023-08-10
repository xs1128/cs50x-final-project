local Player = {}

function Player:load()
    self.x = 100
    self.y = 100
    self.startX = self.x
    self.startY = self.y
    self.width = 20
    self.height = 50
    -- Horizontal movement
    self.xvel = 0
    self.yvel = 100
    self.maxSpeed = 300
    self.acceleration =  3000
    self.friction = 3500
    --Vertical movement
    self.gravity = 1000
    self.initialYvel = -600
    self.coins = 0
    self.healths = {current = 3, max = 3}

    self.color = {
        red = 1,
        green = 1,
        blue = 1,
        speed = 3
    }

    self.graceTime = 0
    self.graceDur = 0.1

    self.alive = true
    self.grounded = false
    self.jumpable = true

    -- load animation assets
    self:loadAssets()

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.body:setGravityScale(0)
end

function Player:loadAssets()
    anim8 = require "lib.anim8"
    self.spriteSheet = love.graphics.newImage('assets/images/playerSprite.png')
    self.spriteWidth = 16
    self.spriteHeight = 16
    self.animation = {
        scale_x = 3.5,
        scale_y = 3.5
    }

    self.grid = anim8.newGrid(self.spriteWidth, self.spriteHeight, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animation.horizontal = anim8.newAnimation(self.grid('2-6', 3), 1 / 5)
    self.animation.jump = anim8.newAnimation(self.grid('2-3', 4), 1 / 3)
    self.animation.idle = anim8.newAnimation(self.grid('2-3', 2), 1 / 2)

    self.anim = self.animation.horizontal
end

function Player:takeDamage(amount)
    self:tintRed()
    if self.healths.current - amount > 0 then
        self.healths.current = self.healths.current - amount
    else
        self.healths.current = 0
        self:die()
        self.alive = false
    end
    print("Player health left: " .. self.healths.current)
end

function Player:die()
    changeGameState("menu")
end

function Player:ressurect()
    if not self.alive then
        self:resetPosition()
        self.healths.current = self.healths.max
        self.alive = true
    end
end

function Player:resetPosition()
    self.physics.body:setPosition(self.startX, self.startY)
end

function Player:tintRed()
    self.color.green = 0
    self.color.blue = 0
end

function Player:incrementCoins()
    self.coins = self.coins + 1
end

function Player:untint(dt)
    self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
    self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end

function Player:update(dt)
    self:untint(dt)
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
    --self:decreaseGraceTime(dt)
    self.anim:update(dt)
    self:ressurect()
end

function Player:move(dt)
    if love.keyboard.isDown("right") then
        self.animation.scale_x = 3.5
        self.anim = self.animation.horizontal
        self.xvel = math.min(self.xvel + self.acceleration * dt, self.maxSpeed)

    elseif love.keyboard.isDown("left") then
        self.animation.scale_x = -3.5
        self.anim = self.animation.horizontal
        self.xvel = math.max(-self.maxSpeed, self.xvel - self.acceleration * dt)
    else
        self.anim = self.animation.idle
        self:applyFriction(dt)  
    end
end

function Player:applyFriction(dt)
    if self.xvel > 0 then
        self.xvel = math.max(0, self.xvel - self.friction * dt)
    elseif self.xvel < 0 then
        self.xvel = math.min(self.xvel + self.friction * dt, 0)
    end
end

function Player:applyGravity(dt)
    if not self.grounded then
        self.anim = self.animation.jump
        self.yvel = self.yvel + self.gravity * dt
    end
end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xvel, self.yvel)
end

function Player:beginContact(a, b, collision)
    if self.grounded then return end
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        elseif ny < 0 then
            self.yvel = 0
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        elseif ny > 0 then
            self.yvel = 0
        end
    end
end

function Player:land(collision)
    self.currentGroundCollision = collision
    self.yvel = 0
    self.grounded = true
    self.jumpable = true
    self.graceTime = self.graceDur
end

function Player:jump(key)
    if key == 'space' then 
        if self.grounded or self.graceTime > 0 then
            self.yvel = self.initialYvel
            self.graceTime = 0
        elseif not self.grounded and self.jumpable then
            self.yvel = self.initialYvel * 0.7
            self.jumpable = false
        end
    end
end

function Player:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.grounded = false
        end
    end
end

function Player:draw()
    love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, self.animation.scale_x, self.animation.scale_y, self.spriteWidth / 2, self.spriteHeight / 2)
    love.graphics.setColor(1, 1, 1, 1)
end

return Player
