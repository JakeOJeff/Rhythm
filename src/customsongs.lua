local customsonglist = {}

exists = love.filesystem.getInfo( "Audios" )
if not exists then
success = love.filesystem.createDirectory( "Audios" )
end

function love.load()

    -- Get the directory items (files and subdirectories)
    local items = love.filesystem.getDirectoryItems("Audios")

    -- Print the names of the items
    for _, item in ipairs(items) do
        table.insert(customsonglist, {
            name = item:match('(.+)%.'),
            artist = "Unknown",
            audio = item
        })
    end

    -- You can use the 'items' table for further processing or display in Love2D
end


return customsonglist