-- The playground entity is the playground where the game is played. It has a color and a size
-- Ball can only be within the playground

local config = require("src.config")

Playground = {
  x      = 10,
  y      = 10,
  width  = 400,
  height = 400,
  colorR = config.PLAYGROUND_COLOR_RED,
  colorG = config.PLAYGROUND_COLOR_GREEN,
  colorB = config.PLAYGROUND_COLOR_BLUE,
  colorA = config.PLAYGROUND_COLOR_ALPHA
}

function Playground:getY()
  return self.y
end

function Playground:getX()
  return self.x
end

function Playground:getMaxY()
  return self.y + self.height
end

function Playground:getMaxX()
  return self.x + self.width
end

function Playground:getHeight()
  return self.height
end

function Playground:getWidth()
  return self.width
end

return Playground
