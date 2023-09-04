local SceneryInit = require("scenery")
local scenery = SceneryInit(
    { path = "src.menu"; key = "menu" },
    { path = "src.game"; key = "game" },
    { path = "src.settings"; key = "settings" }
)
scenery:hook(love)