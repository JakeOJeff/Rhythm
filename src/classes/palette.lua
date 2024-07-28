local palette = {
    x = 0,
    y = 0,
    cx = 0,
    cy = 0,
    px = 0,
    py = 0,
    paletteIMGD = nil,
    paletteW = 0,
    paletteH = 0,
    palletteIMG = nil,
    prevx = 0,
    istouch = false,
    enabled = false,
    selectedcolor = {1,1,1}
}
lg = love.graphics
function palette:enable(state, color)
    self.enabled = state
    self.selectedcolor = color or {1,1,1}
end
function palette:load()
    self.paletteIMGD = love.image.newImageData("assets/icons/palette.png")
    self.palletteIMG = love.graphics.newImage(self.paletteIMGD)
    self.paletteW, self.paletteH = self.paletteIMGD:getDimensions()
    self.prevx = self.paletteW + 50
    self.cx, self.cy = self.x + self.paletteW/2,self.y + self.paletteH/2
end
function palette:update(dt)

    self.paletteW, self.paletteH = self.paletteIMGD:getDimensions()
    if love.mouse.isDown(1) then
        self.istouch = true
    else
        self.istouch = nil
    end
end
function palette:draw()
    if self.enabled then
        

        self.x, self.y = love.mouse.getPosition()

        --[[touches = love.touch.getTouches()
    for i, id in ipairs(touches) do
    x, y = love.touch.getPosition(id)
    end]]
    
    local dist = cmath.circleDist(self.x, self.px + self.paletteW/2, self.y , self.py+ self.paletteH/2)
    if dist < self.paletteH/2  and self.istouch then
        self.cx, self.cy = self.x, self.y
        r, g, b = self.paletteIMGD:getPixel(self.x, self.y)
        self.selectedcolor = {r, g, b}
    end

        lg.setColor(self.selectedcolor)
        lg.rectangle("fill", self.prevx, 10, 100, 100)
        lg.rectangle("line", self.prevx, 10, 100, 100)
    
        lg.setColor(1,1,1)
        love.graphics.draw(self.palletteIMG,self.px, self.py)

        lg.circle("line", self.cx, self.cy, 20, 100)
    
        print("RGB (" .. table.concat(self.selectedcolor, ",") .. ")", self.prevx, 280)

    end

end

return palette