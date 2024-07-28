
local songlist = require 'src.songs'
local statuses = {
    -- Play menu
    { 
        "", -- Play
        "",-- SEPERATOR
        "", -- Settings
        "", -- Credits
        "", -- Stats
        "" -- Quit
    },

    -- Settings menu
    {
        "Choose Game Difficulty", -- Difficulty
        "Change game theme (Changes the assetpacks 1.0.4b)", -- Theme
        "Enable Particles (Affects Performance)", -- Particles
        "More Display Settings", -- Advanced System Settings
        "List of songs [ ONLY IN MUSIC MODE ]", -- Song List
        "Work in Progress", -- Graphics :
        "Memory usage by the code [Click to clear cache]", -- Memory Usage
        "Provides a Tutorial", -- Tutorial
        "", -- SEPERATOR
        "Save Chosen settings", -- SAVE
        "Exit without Saving" -- EXIT ( UNSAVED )
    },
    -- Stats menu
    { 
        "", -- Career Score
        "",-- Combo
        "", -- Career Combo
        "", -- SEPERATOR
        "Exit to Menu" -- MENU
    },
    -- Endgame menu
    {
        "", -- Replay [ LOOP ]
        "", -- SEPERATOR
        "", -- Restart Session
        "", --Menu
    },
    -- Credits menu
    {
        "Developer", -- JakeOJeff
        "", -- SEPERATOR
        "Tester/ Bug Reports", -- mitcheraa
        "Tester/ Features", -- ✝chigoz👑☯/ripm_onkey
        "Tester/ Support", -- DoofyMick/realmood
        "Tester/ Features", -- Galaxy/adolf_rizz1er
        "Tester/ Support", -- Madhav/habibi_madhav
        "Tester/ Bug Reports", -- Maxxie/mintchococh1p
        "Tester/ Support", -- Ashutosh/ashtoc_46
        "Tester/ Moral Support", -- Leny/Lenysflora
        "", -- SEPERATOR
        "Exit to Menu", -- MENU
    },
    -- Advanced Settings menu
    {
        "Enable Visualizer", -- Visualizer
        "Enable Effects", -- Effects
        "Enable Background", -- Background
        "Enable Beat line", -- Beat line
        "Enable Button Color", -- Button Color
        "Enable Button Animation", -- Button Animation
        "Enable Game UI", -- Game UI
        "Time Display [ LEFT = Time Left, CURRENT = Current Time]", -- Time Style
        "", -- SEPERATOR
        "Save Chosen settings", -- SAVE
        "Exit without Saving" -- EXIT ( UNSAVED )
    }
}
--print(songlist[selectedSong].name.." - "..songlist[selectedSong].artist)

return statuses