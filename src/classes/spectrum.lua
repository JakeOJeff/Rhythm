require "src.libs.luafft"
themes = require("src.themes")
local spectrum = {}
local tileSpectrum = {}

abs = math.abs
new = complex.new
UpdateSpectrum = false

wave_size = 1
types = 1
color = themes[selectedTheme].color

Size = 1024
Frequency = 44100
length = Size / Frequency
spectrumDir = 1 -- -1 for up

debounceTime = 0

function devide(list, factor)
    for i, v in ipairs(list) do list[i] = list[i] * factor end
end

function spectro_up(obj, sdata)

    ScreenSizeW = love.graphics.getWidth()
    ScreenSizeH = love.graphics.getHeight()
    spectrumY = ScreenSizeH / 2 -- ScreenSizeH

    local MusicPos = obj:tell("samples")
    local MusicSize = sdata:getSampleCount()

    local List = {}
    for i = MusicPos, MusicPos + (Size - 1) do
        CopyPos = i
        if i + 2048 > MusicSize then i = MusicSize / 2 end

        if sdata:getChannelCount() == 1 then
            List[#List + 1] = new(sdata:getSample(i), 0)
        else
            List[#List + 1] = new(sdata:getSample(i * 2), 0)
        end

    end
    spectrum = fft(List, false)
    devide(spectrum, wave_size)

    local SampleRate = 44100 -- Assuming a sample rate of 44100 Hz
    local SecondsAhead = 2.75 -- Change this to 3 for 3 seconds ahead
    local NewMusicPos = MusicPos + (SecondsAhead * SampleRate)

    if NewMusicPos > MusicSize then NewMusicPos = MusicSize - (Size - 1) end

    local ListBeat = {}
    for i = NewMusicPos, NewMusicPos + (Size - 1) do
        CopyPos = i
        if i + 2048 > MusicSize then i = MusicSize / 2 end

        if sdata:getChannelCount() == 1 then
            ListBeat[#ListBeat + 1] = new(sdata:getSample(i), 0)
        else
            ListBeat[#ListBeat + 1] = new(sdata:getSample(i * 2), 0)
        end
    end

    spectrumBeatmap = fft(ListBeat, false)
    devide(spectrumBeatmap, wave_size)

    UpdateSpectrum = true
    tileSpeedMax = 300 * avg(table)
    --[[or i = 1, #spectrum do
        -- WINDOW RESIZING
        if spectrum[i]:abs() > 100 then
            love.window.setMode(405 + spectrum[i]:abs(), 720 + spectrum[i]:abs())
        end
    end]]
end
function create_tiles(dt)

    local state = false
    if mode == "MUSIC" then
        if songminutesLeft == 0 and songsecondsLeft > 3 then
            state = true
        elseif songminutesLeft > 0 then
            state = true
        else
            state = false
        end
    else
        state = true
    end
    --[[
    tileTimer = tileTimer - (1 * dt)
    if tileTimer < 0 and #tiles < 15 and state then
        -if currentTimeData < #timeDatas then
            currentTimeData = currentTimeData + 1
        else
            currentTimeData = 1
        end
        local option = math.random(1, 10)
        if option == 1 and (currentlevel == 2 or currentlevel == 3) then ---- OPTION 1
            for i = 1, 2 do
                randomTile = math.random(1, 32)

                tile = {
                    x = diaposX + (math.ceil(randomTile / 8) * 100) - 100 + diaDis / 4,
                    y = 800,
                    img = tile1
                }
                table.insert(tiles, tile)
            end
            tileTimer = tileTimerCons

        elseif option == 5 and currentlevel == 3 then
            for i = 1, 3 do
                randomTile = math.random(1, 32)

                tile = {
                    x = diaposX + (math.ceil(randomTile / 8) * 100) - 100 + diaDis / 4,
                    y = 800,
                    img = tile1
                }
                table.insert(tiles, tile)
            end
            tileTimer = tileTimerCons
            -- elseif option == 7 then
            -- tileTimer = tileTimerCons
        else
            randomTile = math.random(1, 32)
            tile = {
                x = diaposX + (math.ceil(randomTile / 8) * 100) - 100 + diaDis / 4,
                y = 800,
                img = tile1
            }
            table.insert(tiles, tile)
            tileTimer = tileTimerCons
        end
    end]]
    if UpdateSpectrum and debounceTime <= 0 then
        for i = 1, 10 do
            if spectrumBeatmap[i]:abs() < 30 and spectrumBeatmap[i]:abs() > 10 then
                randomTile = math.random(1, 32)
                tile = {
                    x = diaposX + (math.ceil(randomTile / 8) * 100) - 100 +
                        diaDis / 4,
                    y = 800,
                    img = tile1
                }
                table.insert(tiles, tile)
                debounceTime = .5
                break
            elseif spectrumBeatmap[i]:abs() < 120 and spectrumBeatmap[i]:abs() >
                30 then
                randomTile = math.random(1, 32)
                tile = {
                    x = diaposX + (math.ceil(randomTile / 8) * 100) - 100 +
                        diaDis / 4,
                    y = 800,
                    img = tile1
                }
                table.insert(tiles, tile)
                debounceTime = .2
                break
            end
        end
        for i = 1, #spectrumBeatmap do
            if spectrumBeatmap[i]:abs() < 200 and spectrumBeatmap[i]:abs() > 120 then
                randomTile = math.random(1, 32)
                tile = {
                    x = diaposX + (math.ceil(randomTile / 8) * 100) - 100 +
                        diaDis / 4,
                    y = 800,
                    img = tile1
                }
                table.insert(tiles, tile)
                debounceTime = 0
            end
        end
    elseif debounceTime > 0 then
        debounceTime = debounceTime - 1 * dt

    end
end

function spectro_show(dir)

    love.graphics.setColor(color)

    if UpdateSpectrum then
        for i = 1, #spectrum do
            if types == 1 then
                love.graphics.rectangle("line", i * 7, spectrumY, 7,
                                        dir * wave_size * (spectrum[i]:abs()))
            elseif types == 2 then
                love.graphics.ellipse("line", i * 7, spectrumY, 7,
                                      dir * wave_size * (spectrum[i]:abs()))
            elseif types == 3 then
                love.graphics.rectangle("line", i * 7, spectrumY, 7,
                                        dir * wave_size * (spectrum[i]:abs()))
                love.graphics.rectangle("fill", i * 7, spectrumY, 7,
                                        dir * wave_size * (spectrum[i]:abs()))
            elseif types == 4 then
                love.graphics.ellipse("fill", i * 7, spectrumY, 7,
                                      dir * wave_size * (spectrum[i]:abs()))
            elseif types == 5 then
                love.graphics.ellipse("line", i * 7, spectrumY, 7,
                                      dir * wave_size * (spectrum[i]:abs()))
            end
        end
    end
end

function avg(table)
    local sum = 0
    for i = 1, #table do sum = sum + table[i]:abs() end
    return sum / #table
end
function spectrum.load()
    -- soundData = love.sound.newSoundData("assets/audio/TS22.mp3")
    -- sound = love.audio.newSource(soundData)
    -- sound:play()
    love.mouse.setVisible(true)
end

time = 0
mtime = 0

function spectrum.keyreleased(key) if key == "escape" then love.event.quit() end end

function spectrum.update(dt)
    color = themes[selectedTheme].color
    time = time + dt
    mtime = mtime + dt

    if math.floor(time) >= 10 then
        types = math.random(1, 5)
        time = 0
    end

    spectro_up(sound, soundData)
end

function spectrum.draw()
    spectro_show(-spectrumDir)
    spectro_show(spectrumDir)
end

return spectrum

