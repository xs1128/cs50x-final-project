local love = require "love"
local Global = require "global"
local Menu = require "states.Menu"
local Game = require "states.Game"
local Setting = require "states.Setting"
local End = require "states.End"
local Quit = require "states.Quit"
local GUI = require "components.GUI"
local Background = require "components.Background"

function love.load()
    Global:load()
    -- Prevent blurring 
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Set default volume settings
    audio.bgm:setVolume(audio.defVol)
    audio.buttonClickSound:setVolume(audio.defVol)
    audio.hurtSFX:setVolume(audio.defVol)
    audio.bgm:play()
    
    Background:load()
    Game:load()
    GUI:load()
    Menu:load()
    Setting:load()
    End:load()
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
    elseif Game.state.paused then
        Game:runButtonFunction(mouseClick)
        mouseClick = false
    elseif Game.state.setting then
        Setting:runButtonFunction(mouseClick)
        Setting:update()
        mouseClick = false
    elseif Game.state.ended then
        End:runButtonFunction(mouseClick)
        mouseClick = false
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
        GUI:draw()
    elseif Game.state.setting then
        Setting:draw()
    elseif Game.state.ended then
        End:draw()
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
    if fpsShow then
        love.graphics.print(love.timer.getFPS(), love.graphics.getWidth() * 0.9, love.graphics.getHeight() * 0.9, 0, 0.9)
    end
end

-- Detect anytime mouse is pressed
function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if not Game.state.running then
            mouseClick = true
        end
    end
end

function love.keypressed(key, scancode, isrepeat)
    if Game.state.running then
        Game:keypress(key) 
        -- Implement pause function
        if key == "p" or key == "escape" then changeGameState("paused") end
    elseif Game.state.paused then
        -- Return to game
        if key == "p" or key == "escape" then changeGameState("running") end     
    end
end

-- Global function to change game state
function changeGameState(state)
    -- Keep track of coming from which state
    previousState = currentState
    currentState = state
    
    Game.state.menu = state == 'menu'
    Game.state.running = state == 'running'
    Game.state.paused = state == 'paused'
    Game.state.setting = state == 'setting'
    Game.state.ended = state == 'ended'
    Game.state.quit = state == 'quit'
end