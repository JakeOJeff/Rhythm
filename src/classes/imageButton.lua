

local class = require("src.libs.middleclass")
imgbutton = class("imgbutton")
local imgbuttons = {}

function imgbutton:initialize(x, y, img, hoverimg, code, rx, ry)

    self.x = x
    self.y = y
	self.code = code 
    self.normalimg = img
	self.img = img
    self.hoverimg = hoverimg
	self.width = img:getWidth()
	self.height = img:getHeight()
	self.rx = rx or 0
	self.ry = ry or 0

    self.hover = false
    self.clicked = false

	table.insert(imgbuttons, self)
	return self


end

function imgbutton:update()

    local x,y = love.mouse.getPosition()
    if x < self.x + self.width and x > self.x and y < self.y + self.height and y > self.y then 
        self.hover = true
    else
        self.hover = false
    end
end

function imgbutton:draw()

	love.graphics.draw(self.img, self.x, self.y)


end 
function imgbutton:mousepressed(x, y, button)
    if button == 1  then
        if self.hover then
			self.code()
            if self.img == self.normalimg then
                self.img = self.hoverimg
            else
                self.img = self.normalimg
            end
        end
    end


end
function update_imgbuttons()
	for i, v in pairs(imgbuttons) do
		v:update()
	end
end

function draw_imgbuttons()
	for i, v in pairs(imgbuttons) do
		v:draw()
	end 
end

return imgbutton