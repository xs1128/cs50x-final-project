local love = require "love"
local Menu = require "states.Menu"
local Game = require "states.Game"
local Background = require "components.Background"
local Quit = require "states.Quit"

function love.load()
    -- Import cnter_ptr cursor from http://www.rw-designer.com/cursor-set/comix
    cursor = love.mouse.newCursor("assets/images/cursor.png")
    -- Import new font from https://tinyworlds.itch.io/free-pixel-font-thaleah
    mainFont = love.graphics.newFont("assets/fonts/ThaleahFat.ttf", 50)
    buttonClickSound = love.audio.newSource("assets/sfx/click.wav", "static")
    -- Prevent blurring 
    love.graphics.setDefaultFilter("nearest")
    -- Initialize mouse x, y position
    mouse_x, mouse_y = 0, 0

    Background:load()
    
    game = Game()
    menu = Menu()
    --background = Background()
    --quit = Quit() 
    Quit:load()
end

-- Detect anytime mouse is pressed
function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if game.state.menu or game.state.quit then
            mouseClick = true
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if game.state.running then
        -- Implement paused function
        if key == "escape" then game:changeGameState("paused") end 
    elseif game.state.paused then
        -- Return to game
        if key == "escape" then game:changeGameState("running") end     
    end
end

function  love.update(dt)
    -- Update mouse position every dt
    mouse_x, mouse_y = love.mouse.getPosition()

    if game.state.menu then
        Background:update(dt)
        menu:run(mouseClick)
        mouseClick = false
    elseif game.state.running then

    elseif game.state.quit then
        Quit:runButtonFunction(mouseClick)
        mouseClick = false
    end
end

function love.draw()
    love.graphics.setFont(mainFont)
    if game.state.menu then
        Background:draw()
        menu:draw()
    elseif game.state.running or game.state.paused then
        game:draw(game.state.paused)
    elseif game.state.quit then
        Quit:draw()
    end
    
    -- Show cursor if game is not running
    if not game.state.running then
        love.mouse.setCursor(cursor)
    end
    -- Display real time user FPS
    --love.graphics.print("FPS: "..love.timer.getFPS(), love.graphics.getWidth() * 0.9, love.graphics.getHeight() * 0.95)
end
