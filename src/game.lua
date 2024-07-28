local game = {}
lg = love.graphics

-- Require Files

themes = require 'src.themes'
songlist = require 'src.songs'
shack = require 'src.libs.shack'
trail = require 'src.tools.trail'
util = require 'src.tools.util'

require 'src.classes.hsl'
require 'src.classes.particle'
require 'src.classes.tile'
require 'src.endgame'

local settings = require 'src.settings'
textAnim = require 'src.libs.text'

-- Initialize Particles

if effects ~= "OFF" then
    particles = {}
    Particle.color = {1,1,1}
    Particle.size = math.random(1, 10)
end

-- GLOBALS
songdone = false
isAllPressed = false
startSong = 2.75 -- Seconds to start song

-- Initialize variables
mobile = false
if love.system.getOS() == 'iOS' or love.system.getOS() == 'Android' then
  mobile = true
end


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

    -- Statistics loading
    misses = 0
    statText = "nil"
    tileSpeedMax = 300

    -- Consonants
    tileSpeed = tileSpeedMax
    tileTimerCons = 60/104
    tileTimer = tileTimerCons
    combo = 0
    
    

    -- Button alpha values
    alp1 = 1
    alp2 = 1
    alp3 = 1
    alp4 = 1

    -- Button fading delay
    maxDelay = 0.05
    delay = maxDelay

    state = "active"
    hue = "increase"

    tiles = {}

    -- Font/Text
    animDelay = 2
    fontSize = 25
    fontGame = love.graphics.newFont("fonts/Rimouski.otf", fontSize)
    fontSize2 = 15
    fontGame2 = love.graphics.newFont("fonts/Rimouski.otf", fontSize2)
    fontPopup = love.graphics.newFont("fonts/Salmon.ttf", fontSize2 * 1.5)
    love.graphics.setFont(fontGame)

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

    -- Load Song
    if mode == "MUSIC" then
        audioVol = 65
        changingVol = false
        changingVolTimer = 2
        if selectedSong <= maxPreBuiltSongs then
            soundData = love.sound.newSoundData("assets/audio/songs/" ..
                                                    songlist[selectedSong].audio ..
                                                    ".mp3")
            sound = love.audio.newSource(soundData)
        else
            soundData = love.sound.newSoundData("Audios/" ..
                                                    songlist[selectedSong].audio ..
                                                    ".mp3")
            sound = love.audio.newSource(soundData, "static")
        end

        songduration = sound:getDuration("seconds")
        songcurrentTime = sound:tell("seconds")
        songtimeLeft = songduration - songcurrentTime
        songminutesLeft = math.floor(songtimeLeft / 60)
        songsecondsLeft = math.floor(songtimeLeft % 60)
        soundonmute = false


    else
        songtimeLeft = 0
        songminutesLeft = 0
        songsecondsLeft = 0

    end

    -- Image initialization
    dia = loadTheme("buton.png")
    tile1 = loadTheme("buton2.png")
    background = loadTheme("background.jpg")

end

function game:update(dt)
    timePlayed = timePlayed + 1 * dt
    if mode == "MUSIC" then
        if not soundonmute then
            sound:setVolume(audioVol/100)
        end
        if startSong > 0 then
            startSong = startSong - 1 * dt
            tileupdate(dt)
        else
            startSong = 0
            if sound:isPlaying() and not soundonmute then
                tileupdate(dt)
            end
        end
        if startSong == 0 then
            sound:play()
            sound:setLooping(true)
        end

        if changingVol then
            changingVolTimer = changingVolTimer - 1 * dt
        end
        if changingVolTimer <= 0 then
            changingVol = false
            changingVolTimer = 2
        end
    else
        tileupdate(dt)
    end
    if combo > careercombo then
        careercombo = combo
        saveGame()
    end
    -- tileTimerCons = timeDatas[currentTimeData]
    -- print(tileTimerCons)

    if mode == "MUSIC" then
        songduration = sound:getDuration("seconds")
        songcurrentTime = sound:tell("seconds")
        songtimeLeft = songduration - songcurrentTime
        songminutesLeft = math.floor(songtimeLeft / 60)
        songsecondsLeft = math.floor(songtimeLeft % 60)

        local mx, my = love.mouse.getPosition()
        if my >= lg.getHeight() - 80 and my < lg.getHeight() - 75 then
            if love.mouse.isDown(1) then
                sound:setVolume(0)
                soundonmute = true
                sound:seek( mx/lg.getWidth() * songduration, "seconds")
            else 
                soundonmute = false
                sound:setVolume(audioVol/100)
            end
        end
    end
    collectgarbage("collect")
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



    -- lg.rectangle("fill", 0, lg.getHeight() - 80, songcurrentTime / songduration * lg.  etWidth(), 5)
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

        if key == "t" then
            game.setScene("menu")

        end
        if key == "escape" then
            print(visualizer)
            score = 0

            saveGame()
            love.event.quit("restart")
        end
    end

    if songtimeLeft <= 0.3 and mode ~= "DESKTOP" and songdone ~= true then
        sound:stop()
        game.setScene("endgame")
    end
end

function game:draw()
    lg.setColor(1, 1, 1)
    if gBG == "ON" then
    lg.draw(background, bgX, 0)
    else
        --lg.setBackgroundColor(HSL(rainH / 255, rainS, rainL, 0.3))

        lg.setBackgroundColor(basecolor)
    end
    lg.setColor(themes[selectedTheme].color)
    spectrum.draw()
    local y1,y2,y3,y4 = (1.5 - alp1)*25,(1.5 - alp2)*25,(1.5 - alp3)*25,(1.5 - alp4)*25
    local c1,c2,c3,c4 = {235 / 255, 64 / 255, 52 / 255, alp1},{235 / 255, 171 / 255, 52 / 255, alp2},{232 / 255, 235 / 255, 52 / 255, alp3},{104 / 255, 235 / 255, 52 / 255, alp4}

    
    if isAllPressed then
        c1,c2,c3,c4 = {1,1,1,0.2},{1,1,1,0.2},{1,1,1,0.2},{1,1,1,0.2}
        y1,y2,y3,y4 = 20,20,20,20
    else
        if buttonAnimation == "ON" then
            y1,y2,y3,y4 = (1.5 - alp1)*25,(1.5 - alp2)*25,(1.5 - alp3)*25,(1.5 - alp4)*25
        else
            y1,y2,y3,y4 = 20,20,20,20
        end
        if buttonColor == "ON" then
            c1,c2,c3,c4 = {235 / 255, 64 / 255, 52 / 255, alp1},{235 / 255, 171 / 255, 52 / 255, alp2},{232 / 255, 235 / 255, 52 / 255, alp3},{104 / 255, 235 / 255, 52 / 255, alp4}
        else
            c1,c2,c3,c4 = {1,1,1,alp1},{1,1,1,alp2},{1,1,1,alp3},{1,1,1,alp4}
        end
    end
    lg.setColor(c1)
    lg.draw(dia, dia1X, y1)
    lg.setColor(c2)
    lg.draw(dia, dia2X,  y2)
    lg.setColor(c3)
    lg.draw(dia, dia3X,  y3)
    lg.setColor(c4)
    lg.draw(dia, dia4X,  y4)

    lg.setColor(1, 1, 1)

    for i, tile in ipairs(tiles) do lg.draw(tile.img, tile.x, tile.y) end

    lg.setFont(fontGame)

    if beatline == "ON" then
    lg.setColor(inst, 1, inst)
    lg.rectangle("fill", 0, 10, lg.getWidth(), 5)
    lg.rectangle("fill", 0, 25 + dia:getHeight(), lg.getWidth(), 5)
    end

    -- If you're wondering why i didn't just do bgThemeColor = themes[selectTheme].color, it is because it changes the value of the themes.color entirely instead of just a small bit
    if gameui == "ON" then
    bgThemeColor = {}
    for i = 1, #themes[selectedTheme].color do
        table.insert(bgThemeColor, themes[selectedTheme].color[i])
    end
    table.insert(bgThemeColor, 0.3) -- Alpha value for the theme color
    lg.setColor(bgThemeColor)
    lg.rectangle("fill", 0, lg.getHeight() - 80, lg.getWidth(), 60)

    lg.setColor(1, 1, 1)
    lg.print("COMBO x" .. combo .. "| Points " .. score .. "| Misses " ..
                 misses, 10, lg.getHeight() - 75)

    if mode == "MUSIC" then
        lg.setColor(themes[selectedTheme].color)


        lg.rectangle("fill", 0, lg.getHeight() - 80,
                     songcurrentTime / songduration * lg.getWidth(), 5)
        lg.setColor(1, 1, 1)
        lg.setFont(fontGame2)
        local timeText = ""
        if timeStyle == "LEFT" then
            timeText = songminutesLeft .. ":" .. string.format("%0.2i",songsecondsLeft)
        elseif timeStyle == "CURRENT" then
            local songCurrentMinute = math.floor(songcurrentTime / 60)
            local songCurrentSecond = math.floor(songcurrentTime % 60)
            timeText = songCurrentMinute .. ":" .. string.format("%0.2i",songCurrentSecond)
        end
        lg.print(songlist[selectedSong].name .. " - " ..
                     songlist[selectedSong].artist .. " " .. songminutesLeft ..
                     ":" .. string.format("%0.2i",songsecondsLeft), 10, lg.getHeight() - 40)

        if changingVol then
            lg.print("+"..(audioVol/100 * 6.6).."db",10,  lg.getHeight() - 120)
            lg.rectangle("fill", 10, lg.getHeight() - 100, 60, 10, 5, 5)
            lg.setColor(0,1,0)
            lg.rectangle("fill", 10, lg.getHeight() - 100, audioVol/100 * 60, 10, 5, 5)
            lg.setColor(1,1,1)
        end
    end
end
    if effects ~= "OFF" then
        for _, particle in ipairs(particles) do particle:draw() end
    end
    lg.setFont(fontGame)

    if gameui == "ON" then
        lg.setFont(fontPopup)
    textAnim:draw()
    shack:apply()
    end
end

-- Change tileSpeed values
function game:wheelmoved(x, y)
    changingVol = true
    if y < 0 and audioVol > 5 then
        audioVol = audioVol - 5
    elseif y > 0 and audioVol < 100 then
        audioVol = audioVol + 5
    end

end

function game:mousemoved(x, y, dx, dy, istouch) end
-- =========================

function saveGame()
    if not love.filesystem.getInfo("savedata.txt") then
        local title = "TWelcome"
        local message =
            "Hello! Thank you for supporting us by playing this. We hope you have a Great time!"
        local buttons = {"Thank you <3", "Help", escapebutton = 1}

        local pressedbutton = love.window 
                                  .showMessageBox(title, message, buttons)
        if pressedbutton == 2 then love.system.openURL("https://ritium-spot.glitch.me/") end
    end
    data = {}
    data.careerscore = careerscore
    data.careercombo = careercombo
    data.score = score
    data.combo = combo
    data.theme = selectedTheme
    data.song = selectedSong
    data.visualizer = visualizer
    data.effects = effects
    data.gBG = gBG
    data.beatline = beatline
    data.buttonColor = buttonColor
    data.buttonAnimation = buttonAnimation
    data.gameui = gameui
    data.timeStyle = timeStyle
    data.basecolor = basecolor
    data.mode = mode
    data.timePlayed = timePlayed

    data.currentlevel = currentlevel


    serialized = lume.serialize(data)
    -- The filetype actually doesn't matter, and can even be omitted.
    love.filesystem.write("savedata.txt", serialized)

end

function loadTheme(item)
    return love.graphics.newImage(
               "assets/themes/" .. themes[selectedTheme].name .. "/" .. item)
end
return game
