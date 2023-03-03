

local UI = {

    renderMainTitle =  function (title)
        love.graphics.setFont(gFonts['title'])
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.printf(title, 1, VIRTUAL_HEIGHT / 2 - 40 + 1, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf(title, 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')
    end,

    renderLowerTitle = function(title)
        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.printf(title, 1, VIRTUAL_HEIGHT / 2 + 17, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255, 255, 255, 255)
        love.graphics.printf(title, 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
    end
}

return UI
