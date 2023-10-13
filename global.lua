Global = {}

function Global:load()

    -- Set local and global variables for assets (cursor, font, font size)
    cursor = love.mouse.newCursor("assets/images/cursor.png")
    local fontFilePath = "assets/fonts/ThaleahFat.ttf"
    mainFont = love.graphics.newFont(fontFilePath, 50)
    largeFont = love.graphics.newFont(fontFilePath, 65)
    
    -- Audio table for assets and variables
    audio = {}
    audio.buttonClickSound = love.audio.newSource("assets/sfx/click.wav", "static")
    audio.hurtSFX = love.audio.newSource("assets/sfx/hurt.wav", "static")
    audio.bgm = love.audio.newSource("assets/sfx/Komiku_-_13_-_Good_Fellow(chosic.com).mp3", "static")
    -- Loop bgm
    audio.bgm:setLooping(true)
    -- Set default volume of game
    audio.defVol = 0.6
    -- One press mute function variables
    audio.muteStatebgm = false
    audio.muteStatesfx = false
    audio.bufferVolbgm = audio.bgm:getVolume()
    audio.bufferVolsfx = audio.hurtSFX:getVolume()
    audio.volBgm = 0
    audio.volSfx = 0
    -- Initialize mouse x, y position
    mouse_x, mouse_y = 0, 0
    previousState = "menu"
    currentState = "menu"

    -- Boolean variable for fps settings
    fpsShow = false
end

return Global
        




