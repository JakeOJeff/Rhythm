local menu = {}
local menuengine = require "src.libs.menuengine"

-- Menus
local mainmenu, play, settings, quit


-- Functions to change Mode
local function menu_main()
    menuengine.disable()  -- Disable every Menu...
    mainmenu:setDisabled(false)  -- ...but enable Mainmenu.
    mainmenu.cursor = 1  -- reset Selection to the first Entry
end

local function play()
    menu.setScene("game")
end

local function settings()
    menuengine.disable()  -- Disable every Menu...
    menu_two:setDisabled(false)  -- ...but enable Secondmenu.
    MODE = 2
    menu_two.cursor = 1  -- reset Selection to the first Entry
end

local function quit()
    love.event.quit()
end

function menu:load()
    love.window.setMode(600,400)
    love.graphics.setFont(love.graphics.newFont(20))

    -- Set Menu-Wide Settings; every Entry will affected by this.

    mainmenu = menuengine.new(200,100)
    mainmenu:addEntry("Play", play)
    mainmenu:addEntry("Settings", settings)
    mainmenu:addEntry("Quit", quit)

    settings = menuengine.new(200,100)
    settings:addEntry("Entry One of Sub-Menu Two")
    settings:addEntry("Entry Two of Sub-Menu Two")
    settings:addEntry("Entry Three of Sub-Menu Two")
    settings:addEntry("<-- Go back to Mainmenu", menu_main)
    
    -- Disable Every Menu, then activate Mainmenu
    menuengine.disable()
    mainmenu:setDisabled(false)
end

function menu:draw()
    love.graphics.clear()
    menuengine.draw()
end

function menu:update(dt)

    menuengine.update()
end

function menu:keypressed(key, scancode, isrepeat)
    menuengine.keypressed(scancode)

    if scancode == "escape" then
        love.event.quit()
    end
end


function menu:mousemoved(x, y, dx, dy, istouch)
    menuengine.mousemoved(x, y)
end
return menu