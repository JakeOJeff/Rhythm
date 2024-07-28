local textAnim = {}

local tween = require 'src.libs.tween'
local cron = require 'src.libs.cron'

local fontSize = 80

sWidth, sHeight = love.graphics.getWidth(), love.graphics.getHeight()
sCenterX, sCenterY = sWidth / 2, sHeight / 2
xCenter = sWidth / 2 - fontSize / 3
yCenter = sHeight / 2 - fontSize / 2

local duration = .5 -- seconds that each effect takes

local effects = {
    {name = "Fade In", start = {alpha = 0}, finish = {alpha = 255}},
    {name = "Fade Out", start = {alpha = 255}, finish = {alpha = 0}}, {
        name = "Bounce",
        start = {y = -fontSize},
        finish = {y = yCenter},
        easing = 'outBounce'
    }, {name = "Zoom Out", start = {zoom = 1}, finish = {zoom = 0}},
    {name = "Zoom In", start = {zoom = 0.5}, finish = {zoom = 1}}, {
        name = "Spin",
        start = {angle = 0},
        finish = {angle = math.pi * 4}, -- 2 turns
        easing = 'inOutBack'
    }, {
        name = "Blush",
        start = {red = 255, green = 255, blue = 255},
        finish = {red = 255, green = 0, blue = 0}
    }
}

local currentEffectIndex = 1

local values = {}
songLyrics = ""
function prepareEffect()
    local effect = effects[5]
    local start, finish = effect.start, effect.finish

    values = {}
    values.red = start.red or 255
    values.green = start.green or 255
    values.blue = start.blue or 255
    values.alpha = start.alpha or 255
    values.y = start.y or yCenter
    values.zoom = start.zoom or 1
    values.angle = start.angle or 0

    tween(duration, values, finish, effect.easing or 'linear')
end
-- Define variables
--[[local texts = {
    {text = "", timeStamp = 4.5},
    {text = "It feels like a perfect night", timeStamp = 6.4},
    {text = "To dress up like hipsters", timeStamp = 9 },
    {text = "Make fun of our exes", timeStamp = 11.5 },
    {text = "Aw Oh, Aw Oh", timeStamp = 13 },
    {text = "It feels like a perfect night", timeStamp = 15.5 },
    {text = "For breakfast at midnight", timeStamp = 18 },
    {text = "To fall in love with strangers", timeStamp = 21 },
    {text = "Aw Oh, Aw Oh", timeStamp = 23 },
    {text = "Yeahhhhhhh", timeStamp = 25 },
    {text = "We're happy, free, confused ", timeStamp = 26.5 },
    {text = "and lonely at the same time", timeStamp = 28.5 },
    {text = "It's a miserable and magical", timeStamp = 31 },
    {text = "ohh, yeahhhhhh", timeStamp = 34 },
    {text = "Tonights the night when we forget", timeStamp = 36 },
    {text = "about the deadlines", timeStamp = 38 },
}
for i = 1, #texts do
    texts[i].duration = 0
end
for i = #texts, 1, -1 do

    if i > 1 then
    texts[i].duration = texts[i].timeStamp - texts[i-1].timeStamp
    else
        texts[i].duration = texts[i].timeStamp
    end
    print(texts[i].duration)
end]]

function textAnim:load()
    self.hasLyrics = false

    prepareEffect()

    if songlist[selectedSong].lyrics then
        if selectedSong <= maxPreBuiltSongs then
            if love.filesystem.getInfo("assets/audio/songs/" ..
                                           songlist[selectedSong].lyrics ..
                                           ".lua") then
                lyrics = require("assets/audio/songs/" ..
                                     songlist[selectedSong].lyrics)
                print(songlist[selectedSong].name .. " LYRICS EXIST")
            end
        else

            if love.filesystem.getInfo("Audios/" ..
                                           songlist[selectedSong].lyrics ..
                                           ".lua") then
                lyrics = require("Audios/" .. songlist[selectedSong].lyrics)
            end
        end

    end
    if lyrics then
        if lyrics[1].timestamp ~= 0 then
            local shiftedTable = {}
            for i = 1, #lyrics do
                shiftedTable[i + 1] = {
                    timestamp = lyrics[i].timestamp,
                    text = lyrics[i].text
                }
            end
            shiftedTable[1] = { timestamp = 0, text = "" }
            lyrics = shiftedTable
        end
    end
    lastDisplayedIndex = 0
end

function textAnim:update(dt)

    tween.update(dt)
    cron.update(dt)

    --[[if data[songcurrentTime] ~= nil then
        self.hasLyrics = true
        currentIndex = songcurrentTime
        print(currentIndex)
        print(self.hasLyrics)
        print(data[currentIndex])
    end]]
    if lyrics and mode == "MUSIC" then
        if songlist[selectedSong].lyrics then
            for i = lastDisplayedIndex + 1, #lyrics do
                local lyric = lyrics[i]
                if songcurrentTime >= lyric.timestamp then
                    songLyrics = lyric.text -- Display lyric text
                    -- You can draw the lyrics on the screen here
                    lastDisplayedIndex = i -- Update the last displayed index
                    self.hasLyrics = true
                    print(lyric.text)
                else
                    break
                end
            end
        end
        if songcurrentTime < lyrics[lastDisplayedIndex].timestamp then
            lastDisplayedIndex = 0
        end
    end
end

function textAnim:draw()
    if startSong == 0 and self.hasLyrics then
        love.graphics.setColor(1, 1, 1)
        love.graphics.push()
        love.graphics.translate(sCenterX, sCenterY)
        love.graphics.scale(0.7)
        love.graphics.translate(-sCenterX, -sCenterY)

        love.graphics.printf(songLyrics, 0, values.y, sWidth, 'center')
        love.graphics.pop()
    end
    --[[if isAllPressed then
        love.graphics.setColor(math.floor(values.red), 0,0 , math.floor(values.alpha))
        love.graphics.push()
        love.graphics.translate(sCenterX, sCenterY)
        love.graphics.scale(values.zoom * 1.5)
        love.graphics.rotate(values.angle)
        love.graphics.translate(-sCenterX, -sCenterY)

        love.graphics.printf("YOU ARE PRESSING ALL KEYS ", 0, values.y, sWidth,
                             'center')

        love.graphics.pop()
    end]]
    if combo > 0 and not isAllPressed then
        love.graphics.setColor(math.floor(values.red), math.floor(values.green),
                               math.floor(values.blue), math.floor(values.alpha))
        love.graphics.push()
        love.graphics.translate(sCenterX, sCenterY)
        love.graphics.scale(values.zoom)
        love.graphics.rotate(values.angle)
        love.graphics.translate(-sCenterX, -sCenterY)

        love.graphics.printf("+" .. combo .. " COMBO", 80, lg.getHeight() - 110,
                             sWidth, 'left')

        love.graphics.pop()
    end
end

return textAnim
