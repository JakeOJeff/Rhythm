
local loading = {}

function loading:load()
squares = {
    {
        x = 0,
        y = 0,
        width = 0,
        height = lg.getHeight()/2,
        color = {1,1,1}
    },
    {
        x = lg.getWidth(),
        y = lg.getHeight()/2,
        width = 0,
        height = lg.getHeight()/2,
        color = {.5,.5,.5}
    }
}
    timer = 0
    loadingGame = false
    tilesalligned = false
    loadingtxt = "Loading."
    loadingTimer = 1
end

function loading:update(dt)
timer = timer + 1 * dt

if timer > 1 and timer < 2 then
    loadingGame = true
end
loadingTimer = loadingTimer + dt
if math.floor(loadingTimer) == 1 then
    loadingtxt = "Loading."
elseif math.floor(loadingTimer) == 2 then
    loadingtxt = "Loading.."
elseif math.floor(loadingTimer) == 3 then
    loadingtxt = "Loading..."
elseif math.floor(loadingTimer) == 4 then
    loadingTimer = 1
end
if loadingGame then
    if squares[1].width < lg.getWidth() then
        squares[1].width = squares[1].width + 50* dt
    end
    squares[2].width = lg.getWidth() + 300
    if squares[2].x > 0 then
        squares[2].x = squares[2].x -50* dt
    else
        squares[2].x = 0
        tilesalligned = true
    end

    if tilesalligned then
        if squares[2].y > 0 then
        squares[2].height = lg.getHeight() + 120
        squares[2].y = squares[2].y - 500 * dt
        else
            loading.setScene("menu")
        end
    end

end

end
function loading:draw()

for i = 1, #squares do
    sq = squares[i]
    lg.setColor(sq.color)
    lg.rectangle("fill", sq.x, sq.y, sq.width, sq.height)
end
lg.print(loadingtxt, 30, 30)
end


return loading
