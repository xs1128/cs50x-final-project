function Text(text, x, y, wrap_width, text_align, opacity)
    wrap_width = wrap_width or love.graphics.getWidth()
    text_align = text_align or "left"
    opacity = opacity or 1

    return {
        text = text,
        x = x, 
        y = y, 

        draw = function(self)
            love.graphics.printf(self.text, self.x, self.y, wrap_width, text_align)
            love.graphics.setColor(1, 1, 1, 1)
        end,
    }
end

return Text
