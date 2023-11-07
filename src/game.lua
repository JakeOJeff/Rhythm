local game = {}
lg = love.graphics

-- Require Files

themes = require 'src.tools.themes'
shack = require 'src.libs.shack'

require 'src.classes.hsl'
require 'src.classes.particle'
require 'src.classes.tile'

local settings = require 'src.settings'
textAnim = require 'src.libs.text'

-- Initialize Particles

if effects ~= "OFF" then
    particles = {}
    Particle.color = {1, 1, 1}
    Particle.size = math.random(1, 10)
end

-- Initialize variables

function game:load()
    love.window.setFullscreen(false)
    lume = require "src.libs.lume"
    spectrum.load()
    wH = lg.getHeight()
    wW = lg.getWidth()

    -- Diamond/Button Positions or X values + Distance between them

    diaDis = 100

    diaposX = wW / 2 - diaDis * 2
    dia1X = diaposX + 0 + diaDis / 4
    dia2X = diaposX + diaDis + diaDis / 4
    dia3X = diaposX + diaDis * 2 + diaDis / 4
    dia4X = diaposX + diaDis * 3 + diaDis / 4
    tilImg = nil

    -- Statistics loading
    misses = 0
    statText = "nil"
    tileSpeedMax = 300

    -- Consonants
    tileSpeed = tileSpeedMax
    tileTimerCons = 0.32
    tileTimer = tileTimerCons
    combo = 0

    -- Button alpha values
    alp1 = 1
    alp2 = 1
    alp3 = 1
    alp4 = 1

    -- Button fading delay
    maxDelay = 0.1
    delay = maxDelay

    state = "active"
    hue = "increase"

    tiles = {}

    -- Font/Text
    animDelay = 2
    fontSize = 25
    font = love.graphics.newFont("fonts/Sweet_Corn.ttf", fontSize)
    love.graphics.setFont(font)

    -- Background Hue
    rainH = 131
    rainS = 0.5
    rainL = 0.5
    inst = 1 -- Lines

    bgX = 0 -- Initial x-coordinate of the background
    bgSpeed = 5 -- Speed at which the background scrolls
    bgDirection = 1 -- 1 for right, -1 for left

    -- Image initialization
    dia = loadTheme("buton.png")
    tile1 = loadTheme("buton2.png")
    background = loadTheme("background.jpg")

    textAnim:load()
    saveTimer = 5 -- Savetimer delay

    -- Time generation delay
    timeDatas = {0.3, 0.28, 0.28, 0.4, 0.34, 0.46, 0.2, 0.3}
    currentTimeData = 1
end

function game:update(dt)
    -- tileTimerCons = timeDatas[currentTimeData]
    -- print(tileTimerCons)

    textAnim:update(dt)
    shack:update(dt)
    if visualizer ~= "OFF" then spectrum.update(dt) end

    if effects ~= "OFF" then
        for i, particle in ipairs(particles) do
            particle:update(dt)
            if particle.size <= 0 then table.remove(particles, i) end
        end
    end
    saveTimer = saveTimer - 1 * dt
    if saveTimer < 1 then
        saveTimer = 5
        saveGame()

    end
    if rainH < 131 then
        hue = "increase"
    elseif rainH > 180 then
        hue = "decrease"
    end

    if hue == "increase" then
        rainH = rainH + 1 * dt
    elseif hue == "decrease" then
        rainH = rainH - 1 * dt
    end

    bgX = bgX + bgSpeed * bgDirection * dt

    -- Check if the background has reached the left or right edge
    if bgDirection == 1 and bgX > 0 then
        bgX = 0 -- Reset position if it went too far to the right
        bgDirection = -1 -- Change direction to left
    elseif bgDirection == -1 and bgX < -(background:getWidth() - sWidth) then
        bgX = -(background:getWidth() - sWidth) -- Reset position if it went too far to the left
        bgDirection = 1 -- Change direction to right
    end

    if state == "active" then
        tileTimer = tileTimer - (1 * dt)
        if tileTimer < 0 and #tiles < 17 then
            --[[if currentTimeData < #timeDatas then
                currentTimeData = currentTimeData + 1
            else
                currentTimeData = 1
            end]]
            local option = math.random(1, 10)
            if option == 1 and currentlevel == 2 then ---- OPTION 1
                for i = 1, 2 do
                    randomTile = math.random(1, 32)

                    tile = {
                        x = diaposX + (math.ceil(randomTile / 8) * 100) - 100 +
                            diaDis / 4,
                        y = 800,
                        img = tile1
                    }
                    table.insert(tiles, tile)
                end
                tileTimer = tileTimerCons

            elseif option == 5 and currentlevel == 3 then
                for i = 1, 3 do
                    randomTile = math.random(1, 32)

                    tile = {
                        x = diaposX + (math.ceil(randomTile / 8) * 100) - 100 +
                            diaDis / 4,
                        y = 800,
                        img = tile1
                    }
                    table.insert(tiles, tile)
                end
                tileTimer = tileTimerCons
            else ---- OPTION 2
                randomTile = math.random(1, 32)
                tile = {
                    x = diaposX + (math.ceil(randomTile / 8) * 100) - 100 +
                        diaDis / 4,
                    y = 800,
                    img = tile1
                }
                table.insert(tiles, tile)
                tileTimer = tileTimerCons
            end
        end
    end

    -- Checking if player has hit the button while the tile has been hovered over it
    for i, tile in ipairs(tiles) do
        tile.y = tile.y - (tileSpeed * dt)
        if tile.x == dia1X and d1() then
            tilepos(tile, i)
        elseif tile.x == dia2X and d2() then
            tilepos(tile, i)
        elseif tile.x == dia3X and d3() then
            tilepos(tile, i)
        elseif tile.x == dia4X and d4() then
            tilepos(tile, i)
        elseif tile.y < 15 and tile.y > 0 then
            if effects ~= "OFF" then
                for _ = 1, 100 do
                    local particle = Particle:new(tile.x + dia:getWidth() / 2,
                                                  tile.y + 25)
                    particle.color = {1, 1, 1}
                    particle.size = math.random(1, 5)
                    table.insert(particles, particle)
                end
            end
        elseif tile.y < 0 then
            table.remove(tiles, i)
            misses = misses + 1
            combo = 0
        end
    end

    -- ==========================================================

    -- Bringing out alpha values
    if d1() then
        alp1 = 0.5
        inst = 0
    elseif d2() then
        alp2 = 0.5
        inst = 0
    elseif d3() then
        alp3 = 0.5
        inst = 0
    elseif d4() then
        alp4 = 0.5
        inst = 0
    end

    -- =======================================

    -- Change back to normal
    if alp1 < 1 and not d1() then
        delay = delay - 1 * dt
        if delay <= 0 then
            alp1 = 1
            inst = 1
            delay = maxDelay
        end
    elseif alp2 < 1 and not d2() then
        delay = delay - 1 * dt
        if delay <= 0 then
            alp2 = 1
            inst = 1
            delay = maxDelay
        end
    elseif alp3 < 1 and not d3() then
        delay = delay - 1 * dt
        if delay <= 0 then
            alp3 = 1
            inst = 1
            delay = maxDelay
        end
    elseif alp4 < 1 and not d4() then
        delay = delay - 1 * dt
        if delay <= 0 then
            alp4 = 1
            inst = 1
            delay = maxDelay
        end
    end

    -- ============================================== 

    function game:keypressed(key)
        if key == "w" then
            if currentlevel < 3 then
                currentlevel = currentlevel + 1
            else
                currentlevel = 1
            end
        elseif key == "s" then
            if currentlevel > 1 then
                currentlevel = currentlevel - 1
            else
                currentlevel = 3
            end
        end
        if key == "escape" then
            print(visualizer)
            saveGame()
            love.event.quit("restart")
        end
    end
end

function game:draw()
    lg.setBackgroundColor(HSL(rainH / 255, rainS, rainL))
    lg.setColor(1, 1, 1)
    lg.draw(background, bgX, -200)

    lg.setColor(1, 1, 1, alp1)
    lg.draw(dia, dia1X, 20)
    lg.setColor(1, 1, 1, alp2)
    lg.draw(dia, dia2X, 20)
    lg.setColor(1, 1, 1, alp3)
    lg.draw(dia, dia3X, 20)
    lg.setColor(1, 1, 1, alp4)
    lg.draw(dia, dia4X, 20)

    lg.setColor(1, 1, 1)

    for i, tile in ipairs(tiles) do lg.draw(tile.img, tile.x, tile.y) end

    lg.setFont(font)

    lg.setColor(inst, 1, inst)
    lg.rectangle("fill", 0, 10, lg.getWidth(), 5)
    lg.rectangle("fill", 0, 25 + dia:getHeight(), lg.getWidth(), 5)


    lg.setColor(1, 1, 1)
    spectrum.draw()

    lg.print(
        "Connected to user Spotify[~x~] | Level : " .. currentlevel .. " " ..
            return_shack(), 10, lg.getHeight() - 100)

    lg.print(score .. " points | " .. statText .. " | " .. misses ..
                 " misses | " .. " COMBO x" .. combo .. "\n @JakeOJeff 2022 " ..
                 tileSpeed, 10, lg.getHeight() - 70)
    lg.setColor(1, 1, 1)
    if effects ~= "OFF" then
        for _, particle in ipairs(particles) do particle:draw() end
    end
    textAnim:draw()

    shack:apply()
end

-- Change tileSpeed values
function game:wheelmoved(x, y)
    if y > 0 then
        tileSpeedMax = tileSpeedMax + 10
    elseif y < 0 then
        if tileSpeedMax > 10 then tileSpeedMax = tileSpeedMax - 10 end
    end
end
-- =========================

function saveGame()
    if not love.filesystem.getInfo("savedata.txt") then
        local title = "TWelcome"
        local message =
            "Hello! Thank you for supporting us by playing this. We hope you have a Great time!"
        local buttons = {"Thank you <3", "Help", escapebutton = 1}

        local pressedbutton = love.window
                                  .showMessageBox(title, message, buttons)
        if pressedbutton == 2 then love.system.openURL("https://wix.com") end
    end
    data = {}
    data.careerscore = careerscore
    data.careercombo = careercombo
    data.score = score
    data.combo = combo
    data.theme = selectedTheme
    data.visualizer = visualizer
    data.effects = effects

    data.currentlevel = currentlevel
    

    serialized = lume.serialize(data)
    -- The filetype actually doesn't matter, and can even be omitted.
    love.filesystem.write("savedata.txt", serialized)

        -- Image initialization
        dia = loadTheme("buton.png")
        tile1 = loadTheme("buton2.png")
        background = loadTheme("background.jpg")
end

function loadTheme(item)
    return love.graphics.newImage(
               "assets/themes/" .. themes[selectedTheme].name .. "/" .. item)
end

return game
