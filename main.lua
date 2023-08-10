local love = require "love"
local Menu = require "states.Menu"
local Game = require "states.Game"
local Quit = require "states.Quit"
local Background = require "components.Background"
local Player = require "objects.Player"

function love.load()
    -- Import center_ptr cursor from http://www.rw-designer.com/cursor-set/comix
    cursor = love.mouse.newCursor("assets/images/cursor.png")
    -- Import new font from https://tinyworlds.itch.io/free-pixel-font-thaleah
    mainFont = love.graphics.newFont("assets/fonts/ThaleahFat.ttf", 50)
    buttonClickSound = love.audio.newSource("assets/sfx/click.wav", "static")
    -- Prevent blurring 
    love.graphics.setDefaultFilter("nearest")
    -- Initialize mouse x, y position
    mouse_x, mouse_y = 0, 0

    Background:load()
    Game:load()
    Menu:load()
    Quit:load()    
end

function  love.update(dt)
    -- Update mouse position every dt
    mouse_x, mouse_y = love.mouse.getPosition()

    if Game.state.menu then
        Background:update(dt, Game.state.paused)
        Menu:runButtonFunction(mouseClick)
        mouseClick = false
    elseif Game.state.running then
        Game:update(dt)
        Background:update(dt, Game.state.paused)
        World:update(dt)
    elseif Game.state.quit then
        Quit:runButtonFunction(mouseClick)
        mouseClick = false
    end
end

function love.draw()
    love.graphics.setFont(mainFont)
    if Game.state.menu then
        Background:draw("menu")
        Menu:draw()
    elseif Game.state.running or Game.state.paused then
        Background:draw("running")        
        Game:draw(Game.state.paused)
    elseif Game.state.quit then
        Quit:draw()
    end
    
    -- Show cursor if game is not running
    if not Game.state.running then
        love.mouse.setVisible(true)
        love.mouse.setCursor(cursor)
    else
        love.mouse.setVisible(false)
    end
    -- Display real time user FPS
    --love.graphics.print("FPS: "..love.timer.getFPS(), love.graphics.getWidth() * 0.9, love.graphics.getHeight() * 0.95)
end

function beginContact(a, b, collision)
    --if Coin:beginContact(a, b, collision) then return end
    --if Obstacle:beginContact(a, b, collision) then return end
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end

-- Detect anytime mouse is pressed
function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if Game.state.menu or Game.state.quit then
            mouseClick = true
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if Game.state.running then
        -- Implement paused function
        if key == "p" then changeGameState("paused") end
        Player:jump(key) 
    elseif Game.state.paused then
        -- Return to game
        if key == "p" then changeGameState("running") end     
    end
end

--global function
    function changeGameState(state)
        Game.state.menu = state == 'menu'
        Game.state.running = state == 'running'
        Game.state.paused = state == 'paused'
        Game.state.ended = state == 'ended'
        Game.state.quit = state == 'quit'
    end
    