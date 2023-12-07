-- License CC0 (Creative Commons license) (c) darkfrei, 2022
local trail = {}
function trail:load()
	maxTrailLength = 5 -- segments
	trailDuration = 0.03 -- seconds
	trailTimer = 0 -- seconds
	trailMaxWidth = 10 -- pixels
end

 
function trail:update(dt)
	if #trail > 2 then
		trailTimer = trailTimer + dt
		while trailTimer > trailDuration do
			trailTimer = trailTimer - trailDuration
			-- remove two last coordinates:
			trail[#trail] = nil
			trail[#trail] = nil
		end
	end
end

function getTrailWidth (i)
	-- custom formula
	return (#trail-(i+1))/#trail
end

function trail:draw()
	love.graphics.setColor(1,1,1)
	if trail[1] then
		local w = trailMaxWidth * getTrailWidth (1)
		love.graphics.circle ('fill', trail[1], trail[2], w/2)
	end
	for i = #trail-1, 3, -2 do -- backwards for color trail
		local c = getTrailWidth (i) -- value of color
		local w = trailMaxWidth * c
		love.graphics.setLineWidth (w)
		love.graphics.setColor (1,1,1,c)
		love.graphics.line (trail[i-2], trail[i-1], trail[i], trail[i+1])
		love.graphics.circle ('fill', trail[i], trail[i+1], w/2)
		love.graphics.setColor(1,1,1) -- THIS LINE MAKES THE GAME BOLD

	end
end

function trail:mousemoved( x, y, dx, dy, istouch )
	table.insert (trail, 1, y)
	table.insert (trail, 1, x)
	if #trail > maxTrailLength*2 then
		for i = #trail, maxTrailLength*2+1, -1 do -- backwards
			trail[i] = nil
		end
	end
end

return trail