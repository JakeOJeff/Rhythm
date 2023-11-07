local menu = {}
local themes = require 'src.tools.themes'
local menuengine = require 'src.libs.menuengine'
local sett = require 'src.settings'
local cmath = require 'src.tools.maths'
local statuses = require 'src.tools.menustatus'

fontSize = 30
font = love.graphics.newFont("fonts/Salmon.ttf", fontSize)
fontB = love.graphics
            .newFont("fonts/Salmon.ttf", fontSize + (8 / 10 * fontSize))
love.graphics.setFont(font)
local position = 0
local themeSelectionI = nil

-- Menus
local mainmenu, play, settings, theme, visuals, effectgraphics, stats, quit, saveToMenu, switchmode
local difficulty, switchTheme

local menubg = love.graphics.newImage("assets/menubg.png")
menubg:setWrap('repeat', 'clampzero')
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
local function play() menu.setScene("game") end

local function settings()
    menuengine.disable() -- Disable every Menu...
    settings:setDisabled(false) -- ...but enable Secondmenu.
    MODE = 1
    settings.cursor = 1 -- reset Selection to the first Entry
end

local function stats()
    menuengine.disable() -- Disable every Menu...
    stats:setDisabled(false) -- ...but enable Secondmenu.
    MODE = 2
    stats.cursor = 1 -- reset Selection to the first Entry
end
local function quit() love.event.quit() end

local function difficulty()
    if currentlevel < 3 then
        currentlevel = currentlevel + 1
    else
        currentlevel = 1
    end
end
local function visuals()
    if visualizer == "OFF" then
        visualizer = "ON"
    else
        visualizer = "OFF"
    end
    print(visualizer)
end
local function switchmode()
    if mode == "MUSIC" then
        mode = "DESKTOP"
    else
        mode = "MUSIC"
    end
end

local function effectgraphics()
    if effects == "OFF" then
        effects = "ON"
    else
        effects = "OFF"
    end
end
local function garbageCollect() collectgarbage("collect") end

local function garbageCount()
    return cmath.round((collectgarbage("count") / 1024), 2) .. " mb"
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

function menu:load()
    lume = require "src.libs.lume"
    -- Set Menu-Wide Settings; every Entry will affected by this.
    if love.filesystem.getInfo("savedata.txt") then
        file = love.filesystem.read("savedata.txt")
        data = lume.deserialize(file)
    else
        data = {}
    end
    careerscore = data.careerscore or careerscore
    score = data.score or 0
    careercombo = data.careercombo or careercombo
    combo = data.combo or combo
    selectedTheme = data.theme or 1
    visualizer = data.visualizer or "OFF"
    effects = data.effects or "OFF"
    mode = data.mode or "DESKTOP"

    currentlevel = data.currentlevel or 1

    spectrum = require 'src.classes.spectrum'

    mainmenu = menuengine.new(20, 20)
    mainmenu:addEntry("Play", play, args, fontB, colorNormal, {0, 1, 0})
    mainmenu:addSep()
    mainmenu:addEntry("Settings", settings)
    mainmenu:addEntry("Stats", stats)
    mainmenu:addEntry("Quit", quit, args, font, colorNormal, {1, 0, 0})
    mainmenu:setStatus(statuses[1])



    settings = menuengine.new(10, 20)
    settings:addEntry("Difficulty :" .. sett.difficulty[currentlevel],
                      difficulty)
    settings:addEntry("Visualizer : " .. visualizer, visuals)
    settings:addEntry("Effects : " .. effects, effectgraphics)
    settings:addEntry("Theme : " .. themes[selectedTheme].name, theme, args,
                      font, colorNormal, themes[selectedTheme].color)
    settings:addEntry("Memory Usage : " .. garbageCount(), garbageCollect)
    settings:addEntry("System Tray ", writeSystemReport)
    settings:addEntry("Mode : "..mode, switchmode)
    settings:addSep()
    settings:addEntry("SAVE", saveToMenu, args, font, colorNormal, {0, 1, 0})
    settings:addEntry("EXIT ( UNSAVED )", menu_main, args, font, colorNormal,
                      {1, 0, 0})
    settings:setStatus(statuses[2])

    stats = menuengine.new(10, 20)
    stats:addEntry("Career Score : " .. (careerscore or " "), func, args, font,
                   colorNormal, {0.5, 0.5, 0.5})
    stats:addEntry("Combo : " .. (combo or " "), func, args, font, colorNormal,
                   {0.5, 0.5, 0.5})
    stats:addEntry("Career Combo : " .. (careercombo or " "), func, args, font,
                   colorNormal, {0.5, 0.5, 0.5})
    stats:addSep()
    stats:addEntry("MENU", menu_main, args, font, colorNormal, {1, 0, 0})
    for i = 1, #stats.entries - 1 do
        stats.entries[i].symbolSelectedBegin = "<"
        stats.entries[i].symbolSelectedEnd = ">"
    end
    -- Disable Every Menu, then activate Mainmenu
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

    menuengine.draw()
end

function menu:update(dt)
    position = position - 1

    -- UPDATION OF SETTINGS
    settings.entries[1].text = "Difficulty :" .. sett.difficulty[currentlevel]
    settings.entries[2].text = "Visualizer : " .. visualizer
    settings.entries[3].text = "Effects : " .. effects

    settings.entries[4].text = "Theme : " .. themes[selectedTheme].name
    settings.entries[4].colorSelected = themes[selectedTheme].color

    settings.entries[5].text = "Memory Usage : " .. garbageCount()
    settings.entries[7].text = "Mode : "..mode
    myQuad = love.graphics.newQuad(-position, 0, menubg:getWidth() * 2,
                                   menubg:getHeight() * 2, menubg:getWidth(),
                                   menubg:getHeight())
    menuengine.update()
end

function menu:keypressed(key, scancode, isrepeat)
    menuengine.keypressed(scancode)

    if scancode == "escape" then love.event.quit() end

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

function menu:mousemoved(x, y, dx, dy, istouch) menuengine.mousemoved(x, y) end
return menu
