
local songlist = require 'src.songs'
local statuses = {
    -- Play menu
    { 
        "", -- Play
        "",-- SEPERATOR
        "", -- Settings
        "", -- Stats
        "" -- Quit
    },

    -- Settings menu
    {
        "Choose Game Difficulty", -- Difficulty
        "Change game theme (Changes the assetpacks 1.0.4b)", -- Theme
        "Enable Particles (Affects Performance)", -- Particles
        "Audio visualizer for better experience (BETA)", -- Visualizer
        "List of songs [ ONLY IN MUSIC MODE ]", -- Song List
        "Work in Progress", -- Graphics :
        "Memory usage by the code [Click to clear cache]", -- Memory Usage
        "Creates a report (DeV Tools)", -- System Tray
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
        "EXit to Menu" -- MENU
    }
}
--print(songlist[selectedSong].name.." - "..songlist[selectedSong].artist)

return statuses