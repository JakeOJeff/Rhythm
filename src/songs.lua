local songlist = {

}
exists = love.filesystem.getInfo( "Audios" )
if not exists then
success = love.filesystem.createDirectory( "Audios" )
end
local items = love.filesystem.getDirectoryItems("Audios")

table.insert(songlist, {
    name = "22",
    artist = "Taylor Swift",
    audio = "TS22"
})
table.insert(songlist, {
    name = "Let Her Go",
    artist = "Passenger",
    audio = "PRLetHerGo"
})
table.insert(songlist, {
    name = "I Lived",
    artist = "OneRepublic",
    audio = "ORILived"
})
table.insert(songlist, {
    name = "Ho Hey",
    artist = "The Lumineers",
    audio = "TLHoHey"
})
table.insert(songlist, {
    name = "When I Was Your Man",
    artist = "Bruno Mars",
    audio = "BMWhenIWasYourMan"
})

table.insert(songlist, {
    name = "Careless Whisper",
    artist = "George Michael",
    audio = "GMCarelessWhisper"
})
table.insert(songlist, {
    name = "Never Gonna Give You Up",
    artist = "Rick Astley",
    audio = "RANeverGonnaGiveYouUp"
})
table.insert(songlist, {
    name = "Call Me Maybe",
    artist = "Carly Rae Jepsen",
    audio = "CRJCallMeMaybe"
})
table.insert(songlist, {
    name = "This Town",
    artist = "Niall Horan",
    audio = "NHThisTown"
})
maxPreBuiltSongs = #songlist
function splitText(text)
    local before, after = string.match(text, "([^%-]*)%s-%s*(.*)")
    after = after:sub(2, #after):match("^%s*(.-)%s*$")
    return before, after
end
for _, item in ipairs(items) do
    local hasHyphen = item:match("(.+)%..+$"):find(" - ")
    if hasHyphen then
        internalartist, internalname = splitText(item:match("(.+)%..+$"))
    else
        internalname = item:match("(.+)%..+$")
        internalartist = "Unknown"
    end
    
    table.insert(songlist, {
        name = internalname,
        artist = internalartist,
        audio = item:match("(.+)%..+$")
    })
end
return songlist