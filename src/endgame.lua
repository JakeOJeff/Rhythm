local endgame = {}
local endgamebg = love.graphics.newImage("assets/menubg.png")
endgamebg:setWrap('repeat', 'clampzero')

local position = 0
local endgameQ = 0
local time = 0

local displayCareer = false
local displayScore = false
fontS = love.graphics.newFont("fonts/Rimouski.otf",
                              fontSize + (5 / 10 * fontSize))
function endgame:load()
    startingX = 0
end

function endgame:update(dt)

    if startingX < 900 then
        startingX = startingX + 40
    else -- WRITE ALL EVENTS AFTER THIS IN THIS ELSE STATEMENT
        time = time + 1 * dt

        if checkTimeEvent(2) then
            displayCareer = true
        end
        if checkTimeEvent(4) then
            displayScore = true
        end


    end
    position = position - 1

    endgameQ = love.graphics.newQuad(-position, 0, endgamebg:getWidth() * 2,
                                     endgamebg:getHeight() * 2,
                                     endgamebg:getWidth(), endgamebg:getHeight())
end

function endgame:draw()
    love.graphics.setFont(fontB)
    sx = love.graphics:getWidth() / endgamebg:getWidth()
    sy = love.graphics:getHeight() / endgamebg:getHeight()
    love.graphics.draw(endgamebg, endgameQ, 0, 0, 0, sx, sy)
    drawRotatedRectangle("fill", -200, 300, startingX, 250, -0.3)
    love.graphics.setColor(0,0,0)
    if displayCareer then love.graphics.print("NEW SCORE", 70, 220) end
    love.graphics.setFont(fontS)
    if displayScore then  love.graphics.print(careerscore, 90, 280) love.graphics.print(((careerscore)-score).." + "..score , 90, 340) end
    love.graphics.setColor(1,1,1)

end

function checkTimeEvent(timePass)
    if time > timePass then
        return true
    end
    return false
end
function endgame:keypressed(key)
    if key == "escape" then
        print(visualizer)
        score = 0

        saveGame()
        love.event.quit("restart")
    end
end
function drawRotatedRectangle(mode, x, y, width, height, angle)
    -- We cannot rotate the rectangle directly, but we
    -- can move and rotate the coordinate system.
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(angle)
    love.graphics.rectangle(mode, 0, 0, width, height) -- origin in the top left corner
    --	love.graphics.rectangle(mode, -width/2, -height/2, width, height) -- origin in the middle
    love.graphics.pop()
end
return endgame
