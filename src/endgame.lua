local endgame = {}
local endgamebg = love.graphics.newImage("assets/menubg.png")
endgamebg:setWrap('repeat', 'clampzero')
local statuses = require 'src.tools.menustatus'
local menuengine = require 'src.libs.menuengine'

local position = 0
local endgameQ = 0
local time = 0

local displayCareer = false
local displayScore = false

local fontSize = 20
local font = love.graphics.newFont("fonts/Rimouski.otf", fontSize)
local fontB = love.graphics.newFont("fonts/Rimouski.otf",
                              fontSize + (8 / 10 * fontSize))

local function replay_game()
    songdone = true
    endgame.setScene("game")
end
local function restart_session()
    score = 0
    sound:stop()
    endgame.setScene("game")
end
local function main_menu()
    love.event.quit("restart")
end
function endgame:load()
    menuengine.disable() -- Disable every Menu...

    startingX = 0
    endgameM = menuengine.new(20, 20)
    endgameM:addEntry("Replay [LOOP]", replay_game, args, fontB, {1,1,1}, {0, 1, 0})
    endgameM:addSep()
    endgameM:addEntry("Restart Session",restart_session, args, font, {1,1,1}, {.5, .5, .5} )
    endgameM:addEntry("Menu", main_menu, args, font, {1,1,1}, {1, 0, 0})
    endgameM:setDisabled(false)
    love.mouse.setVisible(true)
    endgameM:setStatus(statuses[4])

end

function endgame:update(dt)
    menuengine.update(dt)

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
    love.graphics.setFont(font)
    sx = love.graphics:getWidth() / endgamebg:getWidth()
    sy = love.graphics:getHeight() / endgamebg:getHeight()
    love.graphics.draw(endgamebg, endgameQ, 0, 0, 0, sx, sy)
    drawRotatedRectangle("fill", -200, 300, startingX, 250, -0.3)
    love.graphics.setColor(0,0,0)
    if displayCareer then love.graphics.print("NEW SCORE", 70, 220) end
    love.graphics.setFont(fontB)
    if displayScore then  love.graphics.print(careerscore, 90, 280) love.graphics.print(((careerscore)-score).." + "..score , 90, 340) end
    love.graphics.setColor(1,1,1)
    menuengine.draw()

end

function checkTimeEvent(timePass)
    if time > timePass then
        return true
    end
    return false
end
function endgame:keypressed(key, scancode)
    menuengine.keypressed(scancode)

    if key == "escape" then
        print(visualizer)
        score = 0

        saveGame()
        love.event.quit("restart")
    end
end
function endgame:mousemoved(x, y, dx, dy, istouch)
    menuengine.mousemoved(x, y)
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
