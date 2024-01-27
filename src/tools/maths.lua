local cmath = {}

function cmath.round(num, dp)
    --[[
    round a number to so-many decimal of places, which can be negative, 
    e.g. -1 places rounds to 10's,  
    
    examples
        173.2562 rounded to 0 dps is 173.0
        173.2562 rounded to 2 dps is 173.26
        173.2562 rounded to -1 dps is 170.0
    ]]--
    local mult = 10^(dp or 0)
    return math.floor(num * mult + 0.5)/mult
end
function cmath.circleDist(x1,x2,y1,y2)
    return math.sqrt((x2-x1)^2 + (y2-y1)^2)
end
return cmath