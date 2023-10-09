local Text = require "components.Text"
local Button = require "components.Button"

local Setting = {}

function Setting:load()
    self.backFunc = function() changeGameState(previousState) end
    self.settingButtons = {
        Button(self.backFunc, "<<-", "center", nil, nil, love.graphics.getWidth() * 0.09, 50, nil, love.graphics.getWidth() * 0.1, love.graphics.getHeight() * 0.1),
    }
end

function Setting:update(dt)

end

function Setting:runButtonFunction(clicked)
    for name, button in pairs(self.settingButtons) do
        if button:checkHover(mouse_x, mouse_y) and clicked then
            love.audio.play(buttonClickSound)
            button:click()
        end
    end
end

function Setting:draw()
    love.graphics.setColor(0.18, 0.09, 0.20)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)

    love.graphics.setFont(largeFont)
    Text("Settings", 0, love.graphics.getHeight() * 0.15, love.graphics.getWidth(), "center", 1):draw()
    love.graphics.setFont(mainFont)

    for _, button in pairs(self.settingButtons) do
        button:draw()
    end
end

return Setting