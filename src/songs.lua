local songlist = {}
exists = love.filesystem.getInfo("Audios")
if not exists then success = love.filesystem.createDirectory("Audios") end
local items = love.filesystem.getDirectoryItems("Audios")
local mainitems = love.filesystem.getDirectoryItems("assets/audio/songs")

-- PREBUILT SONGS
for i = 1, #mainitems do
    local item = mainitems[i]
    if love.filesystem.getInfo("assets/audio/songs/" .. item, 'directory') then
        if love.filesystem.getInfo("assets/audio/songs/" .. item .. '/index.mp3', 'file') then
            print(item)

            local hasHyphen = item:find(" - ")
            if hasHyphen then
                internalartist, internalname = splitText(item)
            else
                internalname = item
                internalartist = "Unknown"
            end
            local song = {
                name = internalname,
                artist = internalartist,
                audio = item .. "/index"
            }
            if love.filesystem.getInfo("assets/audio/songs/"..item.."/lyrics.lua", 'file') then
                song["lyrics"] = item.."/lyrics"
            end
            print(song["lyrics"])
            table.insert(songlist, song)
        end
    end
end
maxPreBuiltSongs = #songlist

-- CUSTOM SONGS

for i = 1, #items do
    local item = items[i]
    if love.filesystem.getInfo("Audios/" .. item, 'directory') then
        if love.filesystem.getInfo("Audios/" .. item .. '/index.mp3', 'file') then
            print(item)

            local hasHyphen = item:find(" - ")
            if hasHyphen then
                internalartist, internalname = splitText(item)
            else
                internalname = item
                internalartist = "Unknown"
            end
            local song = {
                name = "[C] "..internalname,
                artist = internalartist,
                audio = item .. "/index"
            }
            if love.filesystem.getInfo("Audios/"..item.."/lyrics.lua", 'file') then
                song["lyrics"] = item.."/lyrics"
            end
            print(song["lyrics"])
            table.insert(songlist, song)
        end
    end
end
return songlist
