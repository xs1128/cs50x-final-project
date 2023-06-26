function Text(text, x, y, font_size, wrap_width, text_align, opacity)
    --font_size = font_size or "p"
    wrap_width = wrap_width or love.graphics.getWidth()
    text_align = text_align or "left"
    opacity = opacity or 1

    return {
        text = text,
        x = x, 
        y = y, 

        -- Initialize color table
        colors = {r = 1, g = 1, b = 1},

        -- Change text color on call function else default (1, 1, 1)
        setColor = function(self, red, green, blue)
            self.colors.r = red
            self.colors.g = green
            self.colors.b = blue
        end,

        draw = function(self)
            love.graphics.setColor(self.colors.r, self.colors.g, self.colors.b, opacity)
            love.graphics.printf(self.text, self.x, self.y, wrap_width, text_align)
            love.graphics.setColor(1, 1, 1, 1)
        end,
    }
end

return Text