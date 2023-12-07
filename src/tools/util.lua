local util = {}

function util.oprint( text, x, y, r, sx, sy, ox, oy, kx, ky )
    love.graphics.setColor(0,0,0)
    love.graphics.print( text, x+1, y, r, sx, sy, ox, oy, kx, ky )
    love.graphics.print( text, x-1, y, r, sx, sy, ox, oy, kx, ky )
    love.graphics.print( text, x, y+1, r, sx, sy, ox, oy, kx, ky )
    love.graphics.print( text, x, y-1, r, sx, sy, ox, oy, kx, ky )
    love.graphics.setColor(1,1,1)
    love.graphics.print( text, x, y, r, sx, sy, ox, oy, kx, ky )

end

return util