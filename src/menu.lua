local menu = {}
cmath = require 'src.tools.maths'
util = require 'src.tools.util'
local themes = require 'src.themes'
local songlist = require 'src.songs'
local menusonglist = require 'src.menusongs'
local sett = require 'src.settings'
local statuses = require 'src.tools.menustatus'
local palette = require 'src.classes.palette'
menuengine = require 'src.libs.menuengine'


require "src.classes.imageButton"
local fontSize = 30


-- GOOD FONTS
-- Gymnastik.otf
local font = love.graphics.newFont("fonts/Rimouski.otf", fontSize)
local fontB = love.graphics.newFont("fonts/Rimouski.otf",
                              fontSize + (8 / 10 * fontSize))
love.graphics.setFont(font)
local position = 0
local themeSelectionI = nil

-- Menus
local mainmenu, play, options, theme, credits, song, visuals, effectgraphics, stats, advanceddisplay,
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

local function menu_options()
    menuengine.disable() -- Disable every Menu...
    options:setDisabled(false) -- ...but enable Secondmenu.
    MODE = 1
    options.cursor = #options.entries - 1 -- reset Selection to the first Entry
end
local function saveToOptions()
    saveGame()
    menu_options()
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
    palette:enable(false)

end
local function saveToAdvancedDisplay()
    saveGame()
    menu_advanced_display()
end
local function menu_palette_menu()

    menuengine.disable()
    palettemenu:setDisabled(false)
    MODE = 1
    palettemenu.cursor = 1
end
local function songmenu()
    if mode == "MUSIC" then

        menuengine.disable() -- Disable every Menu...
        songmenu:setDisabled(false) -- ...but enable Secondmenu.
        MODE = 2
        songmenu.cursor = selectedSong -- reset Selection to the first Entry
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
    love.system.openURL("https://ritium-spot.glitch.me/")
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
local function timeStyleGraphics()
    if timeStyle == "LEFT" then
        timeStyle = "CURRENT"
    else
        timeStyle = "LEFT"
    end
end
local function basecolorGraphics()
        menu_palette_menu()
        palette:enable(true)

end
local function selectSong()
    
    print(songmenu.cursor)
    menuengine.disable() -- Disable every Menu...
    options:setDisabled(false) -- ...but enable Secondmenu.
    MODE = 1
    selectedSong = songmenu.cursor

    options.cursor = 1 -- reset Selection to the first Entry
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
local function song(val)
    if val <= #songlist then 
        return data.song 
    else 
        return maxPreBuiltSongs 
    end
end
-- ===================================================================================================

local function leadLink(args)
    

end
-- =========================================================================================================================================
function menu:load()
    love.mouse.setVisible(false)
    cursor = love.graphics.newImage("assets/icons/cursor.png")
    cursorTime = 0
    cursorScale = 0




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
    selectedSong =  song(2) or 1 -- Error here
    timePlayed = data.timePlayed or 0
    visualizer = data.visualizer or "ON"
    effects = data.effects or "ON"
    gBG = data.gBG or "ON"
    beatline = data.beatline or "ON"
    buttonColor = data.buttonColor or "ON"
    buttonAnimation = data.buttonAnimation or "ON"
    gameui = data.gameui or "ON"
    timeStyle = data.timeStyle or "LEFT"
    basecolor = data.basecolor or {1,1,1}
    mode = data.mode or "MUSIC"
    currentlevel = data.currentlevel or 1

    local timeStats = ""
    local timeHours = math.floor(timePlayed/3600)
    local timeMinutes = math.floor(timePlayed/60)
    timeStats = timeHours.."hrs ".. timeMinutes.. "mins "
    spectrum = require 'src.classes.spectrum'

    mainmenu = menuengine.new(20, lg.getHeight() / 2 - fontSize * 4)
    mainmenu:addEntry("Play", play, args, fontB, colorNormal, {0, 1, 0})
    mainmenu:addSep()
    mainmenu:addEntry("Options", menu_options)
    mainmenu:addEntry("Credits", menu_credits)
    mainmenu:addEntry("Stats", menu_stats)
    mainmenu:addEntry("Quit", quit, args, font, colorNormal, {1, 0, 0})
    mainmenu:setStatus(statuses[1])

    options = menuengine.new(10, 20)
    options:addEntry("Difficulty :" .. sett.difficulty[currentlevel],
                      difficulty, args, font, {1, 1, 1}) -- 1
    options:addEntry("Theme : " .. themes[selectedTheme].name, theme, args,
                      font, {.8, .8, .8}, themes[selectedTheme].color) -- 2
    options:addEntry("Effects : " .. effects, effectgraphics, args, font,
                      {1, 1, 1}) -- 3
    options:addEntry("Advanced Display Settings ", menu_advanced_display, args, font,
                      {.8, .8, .8}) -- 4
    options:addEntry("Song : " .. songlist[selectedSong].name, songmenu, args,
                      font, {1, 1, 1}) -- 5
    options:addEntry("Mode : " .. mode, switchmode, args, font, {.8, .8, .8}) -- 6
    options:addEntry("Memory Usage : " .. garbageCount(), garbageCollect, args,
                      font, {1, 1, 1}) -- 7
    options:addEntry("Tutorial ", Tutorial, args, font,
                      {.8, .8, .8}) -- 8
    options:addSep()
    options:addEntry("SAVE", saveToMenu, args, font, colorNormal, {0, 1, 0})
    options:addEntry("EXIT ( UNSAVED )", menu_main, args, font, colorNormal,
                      {1, 0, 0})
    options:setStatus(statuses[2])

    songmenu = menuengine.new(smX, smY)
    for i = 1, #songlist do
        local colorN = {1, 1, 1}
        if i ~= selectedSong then
            if i % 2 == 0 then
                colorN = {.8, .8, .8}
            else
                colorN = {1, 1, 1}
            end
        else
            colorN = {0.2, 0.2, 0.2}
        end
        songmenu:addEntry(songlist[i].name, selectSong, args, font, colorN,
                          colorSelected, songlist[i].artist)
                          songmenu:setScissor({0,0, 400, 400})
    end




    advanceddisplay = menuengine.new(10, 20)
    advanceddisplay:addEntry("Loading...", visuals, args, font,
    {.8, .8, .8}) -- 1
    advanceddisplay:addEntry("Loading...", effectgraphics, args, font,
                      {1, 1, 1}) -- 2
    advanceddisplay:addEntry("Loading...", backgroundGraphics, args, font,
                      {.8, .8, .8}) -- 3
    advanceddisplay:addEntry("Loading...", beatlineGraphics, args, font,
    {1, 1, 1}) -- 4
    advanceddisplay:addEntry("Loading...", buttonColorGraphics, args, font,
                      {.8, .8, .8}) -- 5
    advanceddisplay:addEntry("Loading...", buttonAnimationGraphics, args, font,
    {1, 1, 1}) -- 6
    advanceddisplay:addEntry("Loading...", gameUIGraphics, args, font,
                      {.8, .8, .8}) -- 7
    advanceddisplay:addEntry("Loading...", timeStyleGraphics, args, font,
                      {1, 1, 1}) -- 8          
    advanceddisplay:addEntry("Loading...", basecolorGraphics, args, font,
                      {.8, .8, .8}) -- 9                  
                      
    advanceddisplay:addSep()
    advanceddisplay:addEntry("SAVE", saveToOptions, args, font, colorNormal, {0, 1, 0})
    advanceddisplay:addEntry("EXIT ( UNSAVED )", menu_options, args, font, colorNormal,
                      {1, 0, 0})

                      advanceddisplay:setStatus(statuses[6])    
                      
    palettemenu = menuengine.new(10, 230)
    palettemenu:addEntry("Done", saveToAdvancedDisplay)


    stats = menuengine.new(10, 20)
    stats:addEntry("Career Score : " .. (careerscore or " "), func, args, font,
                   {1, 1, 1}, {0.5, 0.5, 0.5})
    stats:addEntry("Combo : " .. (combo or " "), func, args, font, {1, 1, 1},
                   {0.5, 0.5, 0.5})
    stats:addEntry("Highest Combo : " .. (careercombo or " "), func, args, font,
                   {1, 1, 1}, {0.5, 0.5, 0.5})
    stats:addEntry("Time : " .. (timeStats or " "), func, args, font,
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
    credits:addEntry("Madhav/habibi_madhav", func, args, font, {1, 1, 1}, {0.5, 0.5, 0.5})
    credits:addEntry("Maxxie/mintchococh1p", func, args, font, {.8, .8, .8}, {0.5, 0.5, 0.5})
    credits:addEntry("Ashutosh/ashtoc_46", func, args, font, {1, 1, 1}, {0.5, 0.5, 0.5})
    credits:addEntry("Leny/Lenysflora", func, args, font, {.8, .8, .8}, {0.5, 0.5, 0.5})

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

    if not options.disabled then
        if options.cursor == 2 or options.cursor == 3 or options.cursor == 4 then
            love.graphics.rectangle("line", options.entries[2].x,
            options.entries[2].y,
                                    math.max(
                                        math.max(#options.entries[2].text,
                                                 #options.entries[3].text),
                                        #options.entries[4].text) * fontSize /
                                        2 + 35, 35 * 3)
        elseif options.cursor == 5 then
            love.graphics.rectangle("line", options.entries[5].x,
            options.entries[5].y,
                                    math.max(#options.entries[5].text,
                                             #options.entries[6].text) *
                                        fontSize / 2 + 35, 35 * 2)
        elseif options.cursor == 6 then
            love.graphics.rectangle("line", options.entries[4].x,
            options.entries[4].y,
                                    math.max(
                                        math.max(#options.entries[5].text,
                                                 #options.entries[6].text),
                                        #options.entries[4].text) * fontSize /
                                        2 + 35, 35 * 3)
        end
    end
    palette:draw()
    muteButton:draw()
    if not songmenu.disabled then 
        addSongButton:draw()
    end
    -- Check if screen is on Main Menu, Display Song
    if mainmenu.disabled == false then 
        love.graphics.print(songlist[selectedSong].name)
    end
    menuengine.draw()
    if effects == "ON" then
        -- trail:draw()
    end

    -- CURSOR


    local mx, my = love.mouse.getPosition()
    love.graphics.setColor(basecolor)

    love.graphics.draw(cursor, mx, my, 0, cursorScale, cursorScale, cursor:getWidth() / 2, cursor:getHeight() / 2)

end

function menu:update(dt)
    palette:update()
    cursorTime = cursorTime + dt
    cursorScale = (math.sin(cursorTime * 2 * math.pi) + 1) / 2

    if palette.enabled then
        basecolor[1] = cmath.round(palette.selectedcolor[1], 2)
        basecolor[2] = cmath.round(palette.selectedcolor[2], 2)
        basecolor[3] = cmath.round(palette.selectedcolor[3], 2)
    end
    position = position - 1
    if effects == "ON" then trail:update(dt) end
    -- =================================================================
    -- UPDATION OF SETTINGS
    options.entries[1].text = "Difficulty :" .. sett.difficulty[currentlevel]
    options.entries[3].text = "Effects : " .. effects


    options.entries[2].text = "Theme : " .. themes[selectedTheme].name
    options.entries[2].colorSelected = themes[selectedTheme].color

    if mode ~= "DESKTOP" then
        advanceddisplay.entries[1].text = "Visualizer : " .. visualizer -- Advanced Display Settings
        options.entries[5].text = "Song : " .. songlist[selectedSong].name
    else
        advanceddisplay.entries[1].text = "Visualizer - For Music Mode "  -- Advanced Display Settings
        options.entries[5].text = "Song  - For Music Mode "
    end

    options.entries[7].text = "Memory Usage : " .. garbageCount()
    options.entries[6].text = "Mode : " .. mode

    -- UPDATION OF ADVANCED DISPALY SETTINGS
    advanceddisplay.entries[2].text = "Effects : " .. effects
    advanceddisplay.entries[3].text = "Background : " .. gBG
    advanceddisplay.entries[4].text = "Beat Line : " .. beatline
    advanceddisplay.entries[5].text = "Button Color : " .. buttonColor
    advanceddisplay.entries[6].text = "Button Animation : " .. buttonAnimation
    advanceddisplay.entries[7].text = "Game UI : " .. gameui
    advanceddisplay.entries[8].text = "Time Style : " .. timeStyle
    advanceddisplay.entries[9].text = "Base Color : " .. "("..table.concat(basecolor, ",")..")"
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
    menuengine.update(dt)

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
        elseif not options.disabled then
            saveToMenu()
        elseif not songmenu.disabled then
            menu_options()
        elseif not stats.disabled then
            menu_main()
        elseif not advanceddisplay.disabled then
            menu_options()
        elseif not palettemenu.disabled then
            menu_advanced_display()
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
