local Text = require "components.Text"
local Button = require "components.Button"
-- Import a slider module 
require "lib.simple-slider"

local Setting = {}

function Setting:load()

    -- Initialize mute and fps display variables
    self.bgmMute = ""
    self.sfxMute = ""
    self.fpsShow = ""

    -- Insert sliders in sliders table
    self.volSlider = {
        bgmVolSlider = newSlider(love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.425, 200, audio.defVol, 0, 1, function (v) if not audio.muteStatebgm then audio.bgm:setVolume(v) end 
        end),
        sfxVolSlider = newSlider(love.graphics.getWidth() * 0.5, love.graphics.getHeight() * 0.625, 200, audio.defVol, 0, 1, function (v) if not audio.muteStatesfx then audio.hurtSFX:setVolume(v) audio.buttonClickSound:setVolume(v) end end),
    }
    
    -- Inert function and details for buttons
    self.func = {
        back = function() changeGameState(previousState) end,
        muteBGM = function()
            if not audio.muteStatebgm then
                audio.bufferVolbgm = audio.bgm:getVolume()
                audio.bgm:setVolume(0)
                audio.muteStatebgm = true
            else
                audio.bgm:setVolume(audio.bufferVolbgm)
                audio.muteStatebgm = false
            end
        end,
        muteSFX = function()
            if not audio.muteStatesfx then
                audio.bufferVolsfx = audio.hurtSFX:getVolume()
                audio.buttonClickSound:setVolume(0)
                audio.hurtSFX:setVolume(0)
                audio.muteStatesfx = true
            else
                audio.buttonClickSound:setVolume(audio.bufferVolsfx)
                audio.hurtSFX:setVolume(audio.bufferVolsfx)
                audio.muteStatesfx = false
            end
        end,
        displayFPS = function()
            if fpsShow then
                fpsShow = false
            else
                fpsShow = true
            end
        end
    }
    
    self.settingButtons = {
        Button(self.func.back, "<<-", "center", nil, nil, love.graphics.getWidth() * 0.09, 50, nil, love.graphics.getWidth() * 0.1, love.graphics.getHeight() * 0.1),
        Button(self.func.muteBGM, "", "center", nil, nil, 30, 30, nil, love.graphics.getWidth() * 0.3, love.graphics.getHeight() * 0.4),
        Button(self.func.muteSFX, "", "center", nil, nil, 30, 30, nil, love.graphics.getWidth() * 0.3, love.graphics.getHeight() * 0.6),
        Button(self.func.displayFPS, "", "center", nil, nil, 30, 30, nil, love.graphics.getWidth() * 0.3, love.graphics.getHeight() * 0.8)
    }
end

function Setting:update(dt) 
    
    -- Update current volume for each components
    audio.volBgm = math.floor(audio.bgm:getVolume()* 100)
    audio.volSfx = math.floor((audio.hurtSFX:getVolume() + audio.buttonClickSound:getVolume()) / 2 * 100)

    -- Update every sliders in table
    for _, slider in pairs(self.volSlider) do
        slider:update()
    end

    -- Update both mute states for display purpose
    if audio.muteStatebgm then
        self.bgmMute = "0"
    elseif not audio.muteStatebgm then
        self.bgmMute = "1"
    end

    if audio.muteStatesfx then
        self.sfxMute = "0"
    elseif not audio.muteStatesfx then
        self.sfxMute = "1"
    end

    -- Update FPS display states.Quit
    if fpsShow then self.fpsShow = "1" else self.fpsShow = "0" end
end

function Setting:runButtonFunction(clicked)
    for name, button in pairs(self.settingButtons) do
        if button:checkHover(mouse_x, mouse_y) and clicked then
            love.audio.play(audio.buttonClickSound)
            button:click()
        end
    end
end

function Setting:draw()
    -- Background color
    love.graphics.setColor(0.18, 0.09, 0.20)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)

    -- Print text
    love.graphics.setFont(largeFont)
    love.graphics.setColor(0.4, 0.4, 0.4)
    Text("Settings", 0, love.graphics.getHeight() * 0.15 + 5, love.graphics.getWidth() + 5, "center", 1):draw()
    love.graphics.setColor(1, 1, 1)
    Text("Settings", 0, love.graphics.getHeight() * 0.15, love.graphics.getWidth(), "center", 1):draw()
    love.graphics.setFont(mainFont)

    -- Draw every button
    for _, button in pairs(self.settingButtons) do
        button:draw()
    end

    -- Print on/off for each functions
    love.graphics.print(self.bgmMute, love.graphics.getWidth() * 0.307, love.graphics.getHeight() * 0.395, 0, 0.8)
    love.graphics.print(self.sfxMute, love.graphics.getWidth() * 0.307, love.graphics.getHeight() * 0.595, 0, 0.8)
    love.graphics.print(self.fpsShow, love.graphics.getWidth() * 0.307, love.graphics.getHeight() * 0.795, 0, 0.8)

    love.graphics.print("BGM VOLUME: "..audio.volBgm .."%", love.graphics.getWidth() * 0.36, love.graphics.getHeight() * 0.3, 0, 0.8)
    love.graphics.print("SFX VOLUME: "..audio.volSfx .."%", love.graphics.getWidth() * 0.36, love.graphics.getHeight() * 0.5, 0, 0.8)
    love.graphics.print("DISPLAY FPS", love.graphics.getWidth() * 0.4, love.graphics.getHeight() * 0.795, 0, 0.8)

    -- Draw every slider
    for _, slider in pairs(self.volSlider) do
        slider:draw()
    end
end

return Setting