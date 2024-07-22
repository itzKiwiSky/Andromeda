return { 
    create = function(path)
        androLogo = love.graphics.newImage(path .. "/Assets/andromeda_logo.png")
        androFont = love.graphics.newFont(30)
    end,
    present = function(progress, max)
        love.graphics.draw(androLogo, love.graphics.getWidth() / 2, 200, 0, 0.88, 0.88, androLogo:getWidth() / 2, androLogo:getHeight() / 2)
        love.graphics.rectangle("line", love.graphics.getWidth() / 2 - (256 / 2), 400, 256, 32, 5)
        love.graphics.rectangle("fill", love.graphics.getWidth() / 2 - (256 / 2), 400, math.floor(256 * (progress / max)), 32, 5)

        love.graphics.printf(string.format("Loading assets: %s%%", math.floor((progress / max) * 100 + 0.5)), androFont, 0, 450, love.graphics.getWidth(), "center")
    end
}