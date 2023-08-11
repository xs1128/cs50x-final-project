local Player = {}

function Player:load()
    -- Player dimension and position
    self.x = 100
    self.y = -50
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
    -- Player in-game asstes
    self.coins = 0
    self.healths = {current = 3, max = 3}

    self.color = {
        red = 1,
        green = 1,
        blue = 1,
        speed = 3
    }

    self.hurt = true
    self.grounded = false
    -- Jumpable for second jump of the double jump
    self.jumpable = true
    self.dead = false

    -- Load animation assets
    self:loadAssets()

    -- Player physics body
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.body:setGravityScale(0)
end

function Player:loadAssets()
    -- Use anim8 library to animate player
    anim8 = require "lib.anim8"
    self.spriteSheet = love.graphics.newImage('assets/images/playerSprite.png')
    self.spriteWidth = 16
    self.spriteHeight = 16
    self.animation = {
        scale_x = 3.5,
        scale_y = 3.5
    }

    -- New grid and sets of animation
    self.grid = anim8.newGrid(self.spriteWidth, self.spriteHeight, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animation.horizontal = anim8.newAnimation(self.grid('2-6', 3), 1 / 5)
    self.animation.jump = anim8.newAnimation(self.grid('2-3', 4), 1 / 3)
    self.animation.idle = anim8.newAnimation(self.grid('2-3', 2), 1 / 2)

    -- Set a variable for animation updating
    self.anim = self.animation.horizontal
end

function Player:update(dt)
    -- Player physics uupdate
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)

    -- Player update animation, color when damage taken, and when needed to respawn
    self.anim:update(dt)
    self:untint(dt)
    self:respawn()
end

function Player:syncPhysics()
    -- Update player position and speed every dt
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xvel, self.yvel)
end

function Player:move(dt)
    -- Set key to move, animation and speed changes
    if love.keyboard.isDown("right") then
        self.animation.scale_x = 3.5
        self.anim = self.animation.horizontal
        self.xvel = math.min(self.xvel + self.acceleration * dt, self.maxSpeed)
    elseif love.keyboard.isDown("left") then
        self.animation.scale_x = -3.5
        self.anim = self.animation.horizontal
        self.xvel = math.max(-self.maxSpeed, self.xvel - self.acceleration * dt)
    else
        -- If no key press, slow down player and change animation
        self.anim = self.animation.idle
        self:applyFriction(dt)  
    end
end

function Player:applyGravity(dt)
    -- Increase player vertical velocity if not on ground and show jumping animation 
    if not self.grounded then
        self.anim = self.animation.jump
        self.yvel = self.yvel + self.gravity * dt
    end
end

function Player:applyFriction(dt)
    -- Slow player horizontal speed depending on direction heading
    if self.xvel > 0 then
        self.xvel = math.max(0, self.xvel - self.friction * dt)
    elseif self.xvel < 0 then
        self.xvel = math.min(self.xvel + self.friction * dt, 0)
    end
end

function Player:beginContact(a, b, collision)
    -- Check player contact with solid layer of map
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
    -- Change player variables on landing
    self.currentGroundCollision = collision
    self.yvel = 0
    self.grounded = true
    self.jumpable = true
end

function Player:jump(key)
    -- Double jump code
    if key == "space" then
        if self.grounded then
            self.yvel = self.initialYvel
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

function Player:untint(dt)
    -- Set player colors from red to normal (1, 1, 1)
    self.color.red = math.min(self.color.red + self.color.speed * dt, 1)
    self.color.green = math.min(self.color.green + self.color.speed * dt, 1)
    self.color.blue = math.min(self.color.blue + self.color.speed * dt, 1)
end

function Player:tintRed()
    -- Remove the green and blue elements in player color to tint it red
    self.color.green = 0
    self.color.blue = 0
end

function Player:respawn()
    -- Send player back to place if hit by trap
    if not self.hurt then
        self:resetPosition()
        self.hurt = true
    end
end

function Player:takeDamage(amount)
    -- Play visual and sfx when player take damage
    self:tintRed()
    love.audio.play(hurtSFX)

    -- Check if player still have extra lives
    if self.healths.current - amount > 0 then
        self.healths.current = self.healths.current - amount
        self.hurt = false
    else
        self.dead = true
    end   
end

function Player:resetPosition()
    -- Reset player position to x and y that is set initially
    self.physics.body:setPosition(self.startX, self.startY)
end

function Player:incrementCoins()
    self.coins = self.coins + 1
end

function Player:draw()
    -- Set player color before drawing
    love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, self.animation.scale_x, self.animation.scale_y, self.spriteWidth / 2, self.spriteHeight / 2)
    love.graphics.setColor(1, 1, 1, 1)
end

return Player
