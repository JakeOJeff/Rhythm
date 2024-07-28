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
function splitText(text)
    local before, after = string.match(text, "([^%-]*)%s-%s*(.*)")
    after = after:sub(2, #after):match("^%s*(.-)%s*$")
    return before, after
end
function GetFileExtension(url)
    local str = url
  local temp = ""
  local result = "." -- ! Remove the dot here to ONLY get the extension, eg. jpg without a dot. The dot is added because Download() expects a file type with a dot.

  for i = str:len(), 1, -1 do
    if str:sub(i,i) ~= "." then
      temp = temp..str:sub(i,i)
    else
      break
    end
  end

  -- Reverse order of full file name
  for j = temp:len(), 1, -1 do
    result = result..temp:sub(j,j)
  end

  return result
end
return util