local textAnim = {}

local tween = require 'src.libs.tween'
local cron  = require 'src.libs.cron'

local fontSize = 80

sWidth, sHeight = love.graphics.getWidth(), love.graphics.getHeight()
sCenterX, sCenterY = sWidth/2, sHeight/2
xCenter = sWidth/2 - fontSize/3
yCenter = sHeight/2 - fontSize/2

local duration = .5 -- seconds that each effect takes

local effects = {
  { name     = "Fade In",
    start    = {alpha=0},
    finish   = {alpha=255}
  },
  { name     = "Fade Out",
    start    = {alpha=255},
    finish   = {alpha=0}
  },
  { name     = "Bounce",
    start    = {y = -fontSize},
    finish   = {y = yCenter},
    easing   = 'outBounce'
  },
  { name     = "Zoom Out",
    start    = {zoom=1},
    finish   = {zoom=0},
  },
  { name     = "Zoom In",
    start    = {zoom=0.5},
    finish   = {zoom=1},
  },
  { name     = "Spin",
    start    = {angle=0},
    finish   = {angle=math.pi*4}, -- 2 turns
    easing   = 'inOutBack'
  },
  { name     = "Blush",
    start    = {red=255,green=255,blue=255},
    finish   = {red=255,green=0  ,blue=0}
  }
}

local currentEffectIndex = 1

local values = {}

function prepareEffect()
  local effect = effects[5]
  local start, finish = effect.start, effect.finish

  values = {}
  values.red   = start.red   or 255
  values.green = start.green or 255
  values.blue  = start.blue  or 255
  values.alpha = start.alpha or 255
  values.y     = start.y     or yCenter
  values.zoom  = start.zoom  or 1
  values.angle = start.angle or 0

  tween(duration, values, finish, effect.easing or 'linear')
end

function textAnim:load()

  prepareEffect()
end

function textAnim:update(dt)
  tween.update(dt)
  cron.update(dt)
end

function textAnim:draw()
    if combo > 0 then
  love.graphics.setColor(math.floor(values.red),
                         math.floor(values.green),
                         math.floor(values.blue),
                         math.floor(values.alpha))
  love.graphics.push()
  love.graphics.translate(sCenterX, sCenterY)
  love.graphics.scale(values.zoom)
  love.graphics.rotate(values.angle)
  love.graphics.translate(-sCenterX, -sCenterY)

  love.graphics.printf("COMBO x"..combo, 0, values.y, sWidth, 'center')

  love.graphics.pop()
    end
end

function return_shack()
  return "JAKEOJEFF"
end


return textAnim