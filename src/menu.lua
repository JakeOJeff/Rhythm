local menu = {}
cmath = require 'src.tools.maths'

local themes = require 'src.themes'
local songlist = require 'src.songs'
local menusonglist = require 'src.menusongs'
local sett = require 'src.settings'
local statuses = require 'src.tools.menustatus'
local palette = require 'src.classes.palette'
menuengine = require 'src.libs.menuengine'

require "src.classes.imageButton"
fontSize = 30
-- GOOD FONTS
-- Gymnastik.otf
font = love.graphics.newFont("fonts/Rimouski.otf", fontSize)
fontB = love.graphics.newFont("fonts/Rimouski.otf",
                              fontSize + (8 / 10 * fontSize))
love.graphics.setFont(font)
local position = 0
local themeSelectionI = nil

-- Menus
local mainmenu, play, settings, theme, credits, song, visuals, effectgraphics, stats, advanceddisplay,
      songmenu, quit, saveToMenu, switchmode, selectSong
local smX = 10
local smY = 20
local difficulty, switchTheme
local muted = false

local menubg = love.graphics.newImage("assets/menubg.png")
menubg:setWrap('repeat', 'clampzero')

local muteIco = love.graphics.newImage("assets/icons/mute.png")
local unmuteIco = love.graphics.newImage("assets/icons/unmute.png")
local addIco = love.graphics.newImage("assets/icons/add.png")
-- Functions to change Mode
local function menu_main()
    menuengine.disable() -- Disable every Menu...
    mainmenu:setDisabled(false) -- ...but enable Mainmenu.
    mainmenu.cursor = 1 -- reset Selection to the first Entry
end

local function reload() love.event.quit("restart") end
local function saveToMenu()
    saveGame()
    menu_main()
end

local function play()
    muted = true
    sd:stop()
    menu.setScene("game")
end

local function menu_settings()
    menuengine.disable() -- Disable every Menu...
    settings:setDisabled(false) -- ...but enable Secondmenu.
    MODE = 1
    settings.cursor = #settings.entries - 1 -- reset Selection to the first Entry
end
local function saveToSettings()
    saveGame()
    menu_settings()
end
local function menu_credits()
    menuengine.disable() -- Disable every Menu...
    credits:setDisabled(false) -- ...but enable Secondmenu.
    MODE = 1
    credits.cursor = #credits.entries -- reset Selection to the first Entry
end
local function menu_stats()
    menuengine.disable() -- Disable every Menu...
    stats:setDisabled(false) -- ...but enable Secondmenu.
    MODE = 2
    stats.cursor = #stats.entries -- reset Selection to the first Entry
end
local function menu_advanced_display()

    menuengine.disable() -- Disable every Menu...
    advanceddisplay:setDisabled(false) -- ...but enable Secondmenu.
    MODE = 1
    advanceddisplay.cursor = #advanceddisplay.entries - 1 -- reset Selection to the first Entry

end
local function songmenu()
    if mode == "MUSIC" then

        menuengine.disable() -- Disable every Menu...
        songmenu:setDisabled(false) -- ...but enable Secondmenu.
        MODE = 2
        stats.cursor = 1 -- reset Selection to the first Entry
    end
end
local function quit() love.event.quit() end
-- ==========================================================================
-- SETTINGS 

local function difficulty()
    if currentlevel < 3 then
        currentlevel = currentlevel + 1
    else
        currentlevel = 1
    end
end
local function visuals()
    if mode == "MUSIC" then
        if visualizer == "OFF" then
            visualizer = "ON"
        else
            visualizer = "OFF"
        end
    else
        visualizer = "OFF"
    end

    print(visualizer)
end
local function Tutorial()
    love.system.openURL("https://wix.com")
end
local function switchmode()
    if mode == "MUSIC" then
        mode = "DESKTOP"
        visualizer = "OFF"
    else
        mode = "MUSIC"
        visualizer = "ON"
    end
end

local function effectgraphics()
    if effects == "OFF" then
        effects = "ON"
    else
        effects = "OFF"
    end
end

local function backgroundGraphics()
    if gBG == "OFF" then
        gBG = "ON"
    else
        gBG = "OFF"
    end
end
local function beatlineGraphics()
    if beatline == "OFF" then
        beatline = "ON"
    else
        beatline = "OFF"
    end
end
local function buttonColorGraphics()
    if buttonColor == "OFF" then
        buttonColor = "ON"
    else
        buttonColor = "OFF"
    end
end
local function buttonAnimationGraphics()
    if buttonAnimation == "OFF" then
        buttonAnimation = "ON"
    else
        buttonAnimation = "OFF"
    end
end
local function gameUIGraphics()
    if gameui == "OFF" then
        gameui = "ON"
    else
        gameui = "OFF"
    end
end

local function selectSong()
    selectedSong = songmenu.cursor
    print(songmenu.cursor)
    menuengine.disable() -- Disable every Menu...
    settings:setDisabled(false) -- ...but enable Secondmenu.
    MODE = 1
    settings.cursor = 1 -- reset Selection to the first Entry
end

local function garbageCollect() collectgarbage("collect") end

local function garbageCount()
    return cmath.round((collectgarbage("count"))/(10 * 24), 2) .. " mb"
end
local function theme()
    if selectedTheme < #themes then
        selectedTheme = selectedTheme + 1
    else
        selectedTheme = 1
    end
    print(selectedTheme)
    saveGame()
end
local function song()
    if selectedSong < #songlist then
        selectedSong = selectedSong + 1
    else
        selectedSong = 1
    end
    print(selectedSong)
    saveGame()
end
-- ===================================================================================================

local function leadLink(args)
    

end
-- =========================================================================================================================================
function menu:load()
    palette:load()
    palette:enable(false)
    lume = require "src.libs.lume"
    trail:load()
    sdata = love.sound.newSoundData("assets/audio/menu/" ..
                                        menusonglist[love.math
                                            .random(1, #menusonglist)].audio ..
                                        ".mp3")
    sd = love.audio.newSource(sdata)
    muted = false
    sd:play()
    sd:setLooping(true)
    -- Set Menu-Wide Settings; every Entry will affected by this.
    if love.filesystem.getInfo("savedata.txt") then
        file = love.filesystem.read("savedata.txt")
        data = lume.deserialize(file)
    else
        data = {}
    end
    careerscore = data.careerscore or 0
    score = data.score or 0
    careercombo = data.careercombo or 0
    combo = data.combo or combo
    selectedTheme = data.theme or 1
    selectedSong = data.song or 1
    visualizer = data.visualizer or "ON"
    effects = data.effects or "ON"
    gBG = data.gBG or "ON"
    beatline = data.beatline or "ON"
    buttonColor = data.buttonColor or "ON"
    buttonAnimation = data.buttonAnimation or "ON"
    gameui = data.gameui or "ON"
    mode = data.mode or "MUSIC"
    currentlevel = data.currentlevel or 1

    spectrum = require 'src.classes.spectrum'

    mainmenu = menuengine.new(20, lg.getHeight() / 2 - fontSize * 4)
    mainmenu:addEntry("Play", play, args, fontB, colorNormal, {0, 1, 0})
    mainmenu:addSep()
    mainmenu:addEntry("Settings", menu_settings)
    mainmenu:addEntry("Credits", menu_credits)
    mainmenu:addEntry("Stats", menu_stats)
    mainmenu:addEntry("Quit", quit, args, font, colorNormal, {1, 0, 0})
    mainmenu:setStatus(statuses[1])

    settings = menuengine.new(10, 20)
    settings:addEntry("Difficulty :" .. sett.difficulty[currentlevel],
                      difficulty, args, font, {1, 1, 1}) -- 1
    settings:addEntry("Theme : " .. themes[selectedTheme].name, theme, args,
                      font, {.8, .8, .8}, themes[selectedTheme].color) -- 2
    settings:addEntry("Effects : " .. effects, effectgraphics, args, font,
                      {1, 1, 1}) -- 3
    settings:addEntry("Advanced Display Settings ", menu_advanced_display, args, font,
                      {.8, .8, .8}) -- 4
    settings:addEntry("Song : " .. songlist[selectedSong].name, songmenu, args,
                      font, {1, 1, 1}) -- 5
    settings:addEntry("Mode : " .. mode, switchmode, args, font, {.8, .8, .8}) -- 6
    settings:addEntry("Memory Usage : " .. garbageCount(), garbageCollect, args,
                      font, {1, 1, 1}) -- 7
    settings:addEntry("Tutorial ", Tutorial, args, font,
                      {.8, .8, .8}) -- 8
    settings:addSep()
    settings:addEntry("SAVE", saveToMenu, args, font, colorNormal, {0, 1, 0})
    settings:addEntry("EXIT ( UNSAVED )", menu_main, args, font, colorNormal,
                      {1, 0, 0})
    settings:setStatus(statuses[2])

    songmenu = menuengine.new(smX, smY)
    for i = 1, #songlist do
        colorNormal = {1, 1, 1}
        if i ~= selectedSong then
            if i % 2 == 0 then
                colorNormal = {.8, .8, .8}
            else
                colorNormal = {1, 1, 1}
            end
        else
            colorNormal = {0.2, 0.2, 0.2}
        end
        songmenu:addEntry(songlist[i].name, selectSong, args, font, colorNormal,
                          colorSelected, songlist[i].artist)
                          songmenu:setScissor({0,0, 400, 400})
    end

    advanceddisplay = menuengine.new(10, 20)
    advanceddisplay:addEntry("Visualizer : " .. visualizer, visuals, args, font,
    {.8, .8, .8}) -- 1
    advanceddisplay:addEntry("Effects : " .. effects, effectgraphics, args, font,
                      {1, 1, 1}) -- 2
    advanceddisplay:addEntry("Background : " .. gBG, backgroundGraphics, args, font,
                      {.8, .8, .8}) -- 3
    advanceddisplay:addEntry("Beat Line : " .. beatline, beatlineGraphics, args, font,
    {1, 1, 1}) -- 4
    advanceddisplay:addEntry("Button Color : " .. buttonColor, buttonColorGraphics, args, font,
                      {.8, .8, .8}) -- 5
    advanceddisplay:addEntry("Button Animation : " .. buttonAnimation, buttonAnimationGraphics, args, font,
    {1, 1, 1}) -- 6
    advanceddisplay:addEntry("Game UI : " .. gameui, gameUIGraphics, args, font,
                      {.8, .8, .8}) -- 7
                                                                                      
    advanceddisplay:addSep()
    advanceddisplay:addEntry("SAVE", saveToSettings, args, font, colorNormal, {0, 1, 0})
    advanceddisplay:addEntry("EXIT ( UNSAVED )", menu_settings, args, font, colorNormal,
                      {1, 0, 0})

                      advanceddisplay:setStatus(statuses[6])                 
    stats = menuengine.new(10, 20)
    stats:addEntry("Career Score : " .. (careerscore or " "), func, args, font,
                   {1, 1, 1}, {0.5, 0.5, 0.5})
    stats:addEntry("Combo : " .. (combo or " "), func, args, font, {1, 1, 1},
                   {0.5, 0.5, 0.5})
    stats:addEntry("Highest Combo : " .. (careercombo or " "), func, args, font,
                   {1, 1, 1}, {0.5, 0.5, 0.5})
    stats:addSep()
    stats:addEntry("MENU", menu_main, args, font, colorNormal,{1, 0, 0})    
    for i = 1, #stats.entries - 1 do
        stats.entries[i].symbolSelectedBegin = "<"
        stats.entries[i].symbolSelectedEnd = ">"
    end
    stats:setStatus(statuses[3])

    credits = menuengine.new(10,20)
    credits:addEntry("JakeOJeff", func, args, font, {0, .8, 0}, {0, 0.5, 0})
    credits:addSep()
    credits:addEntry("mitcheraa", func, args, font, {1, 1, 1}, {0.5, 0.5, 0.5})
    credits:addEntry("chigoz/ripm_onkey", func, args, font, {.8, .8, .8}, {0.5, 0.5, 0.5})
    credits:addEntry("DoofyMick/realmood", func, args, font, {1, 1, 1}, {0.5, 0.5, 0.5})
    credits:addEntry("Galaxy/adolf_rizz1er", func, args, font, {.8, .8, .8}, {0.5, 0.5, 0.5})
    credits:addSep()
    credits:addEntry("MENU", menu_main, args, font, colorNormal,{1, 0, 0})    

    for i = 1, #credits.entries - 1 do
        credits.entries[i].symbolSelectedBegin = "<"
        credits.entries[i].symbolSelectedEnd = ">"
    end
    credits:setStatus(statuses[5])

    -- Disable Every Menu, then activate Mainmenu
    muteButton = imgbutton:new(love.graphics.getWidth() - muteIco:getWidth() - 10,love.graphics.getHeight() - muteIco:getHeight() - 10, muteIco, unmuteIco, function()
        if muted then
            muted = false
            
            sd:play()
            sd:setLooping(true)
        else
            muted = true
            sd:stop()

        end
end
    )
    addSongButton = imgbutton:new(10,love.graphics.getHeight() - addIco:getHeight() - 10, addIco, addIco, function()
        love.system.openURL("file://"..love.filesystem.getSaveDirectory().."/Audios")
end)

    menuengine.disable()
    mainmenu:setDisabled(false)
    saveGame()
end

function menu:draw()
    love.graphics.setFont(font)
    love.graphics.clear()
    sx = love.graphics:getWidth() / menubg:getWidth()
    sy = love.graphics:getHeight() / menubg:getHeight()
    love.graphics.draw(menubg, myQuad, 0, 0, 0, sx, sy)

    if not settings.disabled then
        if settings.cursor == 2 or settings.cursor == 3 or settings.cursor == 4 then
            love.graphics.rectangle("line", settings.entries[2].x,
                                    settings.entries[2].y,
                                    math.max(
                                        math.max(#settings.entries[2].text,
                                                 #settings.entries[3].text),
                                        #settings.entries[4].text) * fontSize /
                                        2 + 35, 35 * 3)
        elseif settings.cursor == 5 then
            love.graphics.rectangle("line", settings.entries[5].x,
                                    settings.entries[5].y,
                                    math.max(#settings.entries[5].text,
                                             #settings.entries[6].text) *
                                        fontSize / 2 + 35, 35 * 2)
        elseif settings.cursor == 6 then
            love.graphics.rectangle("line", settings.entries[4].x,
                                    settings.entries[4].y,
                                    math.max(
                                        math.max(#settings.entries[5].text,
                                                 #settings.entries[6].text),
                                        #settings.entries[4].text) * fontSize /
                                        2 + 35, 35 * 3)
        end
    end
    palette:draw()
    muteButton:draw()
    if not songmenu.disabled then 
        addSongButton:draw()
    end
    menuengine.draw()
    if effects == "ON" then
        -- trail:draw()
    end
end

function menu:update(dt)
    palette:update()
    position = position - 1
    if effects == "ON" then trail:update(dt) end
    -- =================================================================
    -- UPDATION OF SETTINGS
    settings.entries[1].text = "Difficulty :" .. sett.difficulty[currentlevel]
    settings.entries[3].text = "Effects : " .. effects


    settings.entries[2].text = "Theme : " .. themes[selectedTheme].name
    settings.entries[2].colorSelected = themes[selectedTheme].color

    if mode ~= "DESKTOP" then
        advanceddisplay.entries[1].text = "Visualizer : " .. visualizer -- Advanced Display Settings
        settings.entries[5].text = "Song : " .. songlist[selectedSong].name
    else
        advanceddisplay.entries[1].text = "Visualizer - For Music Mode "  -- Advanced Display Settings
        settings.entries[5].text = "Song  - For Music Mode "
    end

    settings.entries[7].text = "Memory Usage : " .. garbageCount()
    settings.entries[6].text = "Mode : " .. mode

    -- UPDATION OF ADVANCED DISPALY SETTINGS
    advanceddisplay.entries[2].text = "Effects : " .. effects
    advanceddisplay.entries[3].text = "Background : " .. gBG
    advanceddisplay.entries[4].text = "Beat Line : " .. beatline
    advanceddisplay.entries[5].text = "Button Color : " .. buttonColor
    advanceddisplay.entries[6].text = "Button Animation : " .. buttonAnimation
    advanceddisplay.entries[7].text = "Game UI : " .. gameui
    -- =====================================================================
    myQuad = love.graphics.newQuad(-position, 0, menubg:getWidth() * 2,
                                   menubg:getHeight() * 2, menubg:getWidth(),
                                   menubg:getHeight())
    if not songmenu.disabled then songmenu:movePosition(smX, smY) end
    for i = 1, #songlist do
        colorNormal = {1, 1, 1}
        if i ~= selectedSong then
            if i % 2 == 0 then
                colorNormal = {.8, .8, .8}
            else
                colorNormal = {1, 1, 1}
            end
        else
            colorNormal = {0.2, 0.2, 0.2}
        end
        songmenu.entries[i].colorNormal = colorNormal
    end
    menuengine.update()

    update_imgbuttons()
    -- MUTING
    --[[if not menuengine.on() then
    if muted then
        sd:stop()
    else
        sd:play()
        sd:setLooping(true)
    end
end]]
end

function menu:keypressed(key, scancode, isrepeat)
    menuengine.keypressed(scancode)

    if scancode == "escape" then
        if not mainmenu.disabled then
            love.event.quit()
        elseif not settings.disabled then
            saveToMenu()
        elseif not songmenu.disabled then
            menu_settings()
        elseif not stats.disabled then
            menu_main()
        elseif not advanceddisplay.disabled then
            menu_settings()
        end

    end

    if key == "r" then
        if love.filesystem.getInfo("savedata.txt") then
            local title = "Restart"
            local message = "This will reset all your data"
            local buttons = {"Yes", "Cancel", escapebutton = 2}

            local pressedbutton = love.window.showMessageBox(title, message,
                                                             buttons)
            if pressedbutton == 1 then
                local subTitle = "Confirmation"
                local subMessage = "Are you sure you wanna \ndelete?"
                local subButtons = {
                    "I am sure",
                    "Take me back",
                    escapebutton = 2
                }

                local subPressedbutton =
                    love.window.showMessageBox(subTitle, subMessage, subButtons)
                if subPressedbutton == 1 then
                    love.filesystem.remove("savedata.txt")
                    love.event.quit("restart")
                end
            end
        end
    end
end
function menu:mousepressed(x, y, button)
    mousepressed_imgbuttons(x, y, button)
end
function menu:mousemoved(x, y, dx, dy, istouch)
    menuengine.mousemoved(x, y)
    trail:mousemoved(x, y, dx, dy, istouch)
end
function menu:wheelmoved(x, y)
    if not songmenu.disabled then
        if y > 0 then
            if smY < 20 then smY = smY + 10 end

        elseif y < 0 then
            smY = smY - 10
        end
    end

end
return menu
