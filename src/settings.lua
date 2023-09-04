local game = {}
lg = love.graphics


function game.load()

end

function game.update(dt)

end

function game.draw()
    
end

function import(location)
    return require('src.'..location)
end
return game