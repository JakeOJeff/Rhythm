-- Particle class definition
Particle = {}
Particle.__index = Particle

function Particle:new(x, y)
    local particle = setmetatable({}, self)
    particle.x = x
    particle.y = y
    particle.vx = math.random(-100, 100)
    particle.vy = math.random(-100, 100)
    particle.size = self.size
    particle.color = self.color
    return particle
end

function Particle:update(dt)
    self.x = self.x + self.vx * dt
    self.y = self.y + self.vy * dt
    self.size = self.size - dt * 10
end

function Particle:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.size)
end

