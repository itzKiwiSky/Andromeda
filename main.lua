function love.load(args)
    inspect = require 'inspect'
    andromeda = require 'andromeda'

    assetdb = andromeda.newDB()
    assetdb:queueLoad("images", "assets/images")
    assetdb:queueLoad("audios", "assets/sounds")
    
    assetdb:initialize()
end

function love.draw()
    love.graphics.print("All assets loaded", 90, 90)
end

function love.update(elapsed)
    
end