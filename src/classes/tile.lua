local themes = require("src.themes")
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
        combo = combo + 1
        careerscore = careerscore + 1
        shack:shake(1)
        prepareEffect()

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
        fontSize = 40

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
        careerscore = careerscore + 50
        fontSize = 40
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
function tileOutOfBounds(val)
    for i, tile in ipairs(tiles) do
    if tiles[1].y > 50 and tiles[1].x == diaposX + diaDis * (val - 1) + diaDis / 4 then
        print("YES")
        statText = "Miss"
        table.remove(tiles, i)
        fontSize = 40
        score = score - 2

            combo = 0
        if effects ~= "OFF" then
            for _ = 1, 100 do
                local particle = Particle:new(tile.x + dia:getWidth() / 2,
                                              tile.y + 25)
                particle.color = {1,0,0}

                table.insert(particles, particle)
            end
        end
    end
end
end
function tileupdate(dt)
    create_tiles(dt)
    -- Checking if player has hit the button while the tile has been hovered over it
    for i, tile in ipairs(tiles) do
        tile.y = tile.y - (tileSpeed * dt)
        if tile.x == dia1X and d1() then
            tilepos(tile, i)
            --tileOutOfBounds(1)
        elseif tile.x == dia2X and d2() then
            tilepos(tile, i)
        elseif tile.x == dia3X and d3() then
            tilepos(tile, i)
        elseif tile.x == dia4X and d4() then
            tilepos(tile, i)
        elseif tile.y < 15 and tile.y > 0 then
            if effects ~= "OFF" then
                for _ = 1, 100 do
                    local particle = Particle:new(tile.x + dia:getWidth() / 2,
                                                  tile.y + 25)
                    particle.color = {1, 1, 1}
                    particle.size = math.random(1, 5)
                    table.insert(particles, particle)
                end
            end
        elseif tile.y < 0 then
            table.remove(tiles, i)
            misses = misses + 1
            combo = 0
        end
    end

    -- ==========================================================

    -- Bringing out alpha values
    if d1() then
        alp1 = 0.5
        inst = 0
    elseif d2() then
        alp2 = 0.5
        inst = 0
    elseif d3() then
        alp3 = 0.5
        inst = 0
    elseif d4() then
        alp4 = 0.5
        inst = 0
    end

    -- =======================================

    -- Change back to normal
    if alp1 < 1 and not d1() then
        delay = delay - 1 * dt
        if delay <= 0 then
            alp1 = 1
            inst = 1
            delay = maxDelay
        end
    elseif alp2 < 1 and not d2() then
        delay = delay - 1 * dt
        if delay <= 0 then
            alp2 = 1
            inst = 1
            delay = maxDelay
        end
    elseif alp3 < 1 and not d3() then
        delay = delay - 1 * dt
        if delay <= 0 then
            alp3 = 1
            inst = 1
            delay = maxDelay
        end
    elseif alp4 < 1 and not d4() then
        delay = delay - 1 * dt
        if delay <= 0 then
            alp4 = 1
            inst = 1
            delay = maxDelay
        end
    end

end
function alphav(alp)
    if alp > 0.5 then return true end
    return false
end
