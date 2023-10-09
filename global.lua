
Global = {}

function Global:load()
    -- Import center_ptr cursor from http://www.rw-designer.com/cursor-set/comix
    cursor = love.mouse.newCursor("assets/images/cursor.png")
    -- Import new font from https://tinyworlds.itch.io/free-pixel-font-thaleah
    local fontFilePath = "assets/fonts/ThaleahFat.ttf"
    mainFont = love.graphics.newFont(fontFilePath, 50)
    largeFont = love.graphics.newFont(fontFilePath, 65)
    buttonClickSound = love.audio.newSource("assets/sfx/click.wav", "static")
    hurtSFX = love.audio.newSource("assets/sfx/hurt.wav", "static")
    -- Initialize mouse x, y position
    mouse_x, mouse_y = 0, 0
    previousState = "menu"
    currentState = "menu"
end

return Global
        




