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
    fontSize = 30
    font = love.graphics.newFont("fonts/Sweet_Corn.ttf", fontSize)
    fontSize2 = 15
    font2 = love.graphics.newFont("fonts/Sweet_Corn.ttf", fontSize2)
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

    -- Load Song
    if mode == "MUSIC" then

    if selectedSong <= maxPreBuiltSongs then
        soundData = love.sound.newSoundData("assets/audio/"..songlist[selectedSong].audio..".mp3")
	    sound = love.audio.newSource(soundData)
    else
        soundData = love.sound.newSoundData("Audios/"..songlist[selectedSong].audio..".mp3")
        sound = love.audio.newSource(soundData, "static")
    end

    songduration = sound:getDuration("seconds")
    songcurrentTime = sound:tell("seconds")
     songtimeLeft = songduration - songcurrentTime
     songminutesLeft = math.floor(songtimeLeft / 60)
     songsecondsLeft = math.floor(songtimeLeft % 60)
    
else
    songtimeLeft = 0
    songminutesLeft = 0
    songsecondsLeft = 0

end
        -- Image initialization
        dia = loadTheme("buton.png")
        tile1 = loadTheme("buton2.png")
        background = loadTheme("background.jpg")
    startSong = 1.5 -- Seconds to start song
end

function game:update(dt)

    if mode == "MUSIC" then
    if startSong > 0 then
        startSong = startSong - 1 * dt
    else
        startSong = 0
    end
    if startSong == 0 then
        sound:play()
        sound:setLooping(true)
    end
end
    -- tileTimerCons = timeDatas[currentTimeData]
    -- print(tileTimerCons)

    if mode == "MUSIC" then
        songduration = sound:getDuration("seconds")
        songcurrentTime = sound:tell("seconds")
         songtimeLeft = songduration - songcurrentTime
         songminutesLeft = math.floor(songtimeLeft / 60)
         songsecondsLeft = math.floor(songtimeLeft % 60)
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
    tileupdate(dt)

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
            if selectedTheme < 3 then
                selectedTheme = selectedTheme + 1
            else
                selectedTheme = 1
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
    lg.setColor(1, 1, 1)
    lg.draw(background, bgX, 0)
    lg.setColor(themes[selectedTheme].color)
    spectrum.draw()
    lg.setColor(235/255, 64/255, 52/255, alp1)
    lg.draw(dia, dia1X, 20)
    lg.setColor(235/255, 171/255, 52/255, alp2)
    lg.draw(dia, dia2X, 20)
    lg.setColor(232/255, 235/255, 52/255, alp3)
    lg.draw(dia, dia3X, 20)
    lg.setColor(104/255, 235/255, 52/255, alp4)
    lg.draw(dia, dia4X, 20)

    lg.setColor(1, 1, 1)

    for i, tile in ipairs(tiles) do lg.draw(tile.img, tile.x, tile.y) end

    lg.setFont(font)

    lg.setColor(inst, 1, inst)
    lg.rectangle("fill", 0, 10, lg.getWidth(), 5)
    lg.rectangle("fill", 0, 25 + dia:getHeight(), lg.getWidth(), 5)




    lg.setColor(HSL(rainH / 255, rainS, rainL, 0.3))

    -- If you're wondering why i didn't just do bgThemeColor = themes[selectTheme].color, it is because it changes the value of the themes.color entirely instead of just a small bit
    bgThemeColor = {}
    for i = 1, #themes[selectedTheme].color do
        table.insert(bgThemeColor, themes[selectedTheme].color[i])
    end
    table.insert(bgThemeColor, 0.1) -- Alpha value for the theme color
    lg.setColor(bgThemeColor)
    lg.rectangle("fill", 0, lg.getHeight() - 80, lg.getWidth(), 60 )

    lg.setColor(1, 1, 1)
    lg.print(
        "COMBO x" .. combo ..
        " | Points "..score ..
        " | Misses "..misses, 10, lg.getHeight() - 75)

    if mode == "MUSIC" then
        lg.setColor(themes[selectedTheme].color)

        lg.rectangle("fill", 0, lg.getHeight() - 80, songcurrentTime/songduration * lg.getWidth(), 5 )
    lg.setColor(1,1,1)
    lg.setFont(font2)
    lg.print(songlist[selectedSong].name.. " - "..songlist[selectedSong].artist.. " "..songminutesLeft..":"..songsecondsLeft, 10, lg.getHeight()-40)
    end
    if effects ~= "OFF" then
        for _, particle in ipairs(particles) do particle:draw() end
    end
    lg.setFont(font)

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

function game:mousemoved( x, y, dx, dy, istouch )
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
    data.song = selectedSong
    data.visualizer = visualizer
    data.effects = effects
    data.mode = mode 

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
