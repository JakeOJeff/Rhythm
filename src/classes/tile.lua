local themes = require("src.tools.themes")
local settings = require("src.settings")

function d1() return love.keyboard.isDown(settings.keybinds[1]) end
function d2() return love.keyboard.isDown(settings.keybinds[2]) end
function d3() return love.keyboard.isDown(settings.keybinds[3]) end
function d4() return love.keyboard.isDown(settings.keybinds[4]) end

function mse() return love.mouse.isDown(1) end

function tilepos(tile, i)
    if tile.y > 35 and tile.y < 45 then
        statText = "Good"
        table.remove(tiles, i)
        fontSize = 40
        score = score + 1
        careerscore = careerscore + 1
        combo = combo + 1
        careercombo = careercombo + 1
        shack:shake(1)
        prepareEffect()
        image = cool
        imageX = tile.x
        imageY = tile.y + 25
        imgVisible = true
        if effects ~= "OFF" then
            for _ = 1, 100 do
                local particle = Particle:new(tile.x + dia:getWidth() / 2,
                                              tile.y + 25)
                particle.color = themes[selectedTheme].color
                table.insert(particles, particle)
            end
        end
    elseif tile.y > 25 and tile.y < 35 then
        statText = "HOT"
        table.remove(tiles, i)
        score = score + 100
        careerscore = careerscore + 100
        shack:shake(500)
        combo = combo + 1
        careercombo = careercombo + 1
        fontSize = 40
        image = hot
        imageX = tile.x
        imageY = tile.y + 25
        imgVisible = true
        if effects ~= "OFF" then
            for _ = 1, 100 do
                local particle = Particle:new(tile.x + dia:getWidth() / 2,
                                              tile.y + 25)
                particle.color = themes[selectedTheme].color

                table.insert(particles, particle)
            end
        end
    elseif tile.y < 25 and tile.y > 15 then
        statText = "NICE"
        table.remove(tiles, i)
        score = score + 50
        shack:shake(100)
        combo = combo + 1
        careercombo = careercombo + 1
        careerscore = careerscore + 50
        fontSize = 40
        image = nice
        imageX = tile.x
        imageY = tile.y + 25
        imgVisible = true
        if effects ~= "OFF" then
            for _ = 1, 100 do
                local particle = Particle:new(tile.x + dia:getWidth() / 2,
                                              tile.y + 25)
                particle.color = themes[selectedTheme].color

                table.insert(particles, particle)
            end
        end
    end

end

function alphav(alp)
    if alp > 0.5 then return true end
    return false
end
