function love.load(args)
    andromeda = require 'andromeda'

    assetdb = andromeda.newDB()
    assetdb:queueLoad("assets/images")
    assetdb:queueLoad("assets/sounds")
    
    assetdb:initialize()
end

function love.draw()
    love.graphics.print("All assets loaded", 90, 90)
end

function love.update(elapsed)
    
end