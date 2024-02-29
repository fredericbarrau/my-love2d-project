-- import the entityMovement library
EntityMovement = require("src.entities.movement_vector")

BallState = {
    START = 0,
    MOVING = 1
}

Ball = {
    x = 0,
    y = 0,
    max_x = 0,
    max_y = 0,
    radius = 5,
    colorR = 255,
    colorG = 0,
    colorB = 0,
    showMvmtVector = false,
    state = BallState.START
}

-- Common methods for Love
function Ball:load(x, y)
    self.x = x
    self.y = y
    self.max_x = love.graphics.getWidth()
    self.max_y = love.graphics.getHeight()
    self.current_movement = { 0, 0, 0 }
    
end

function Ball:draw()
    love.graphics.setColor(self.colorR, self.colorG, self.colorB)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

--     Update the ball positions
--     @param dt: delta times
function Ball:update(dt, control_player)
    if (control_player ~= nil) then
        if (self.state == BallState.START) then
            self:move(MovementVector)
        end
    end
end

-- Helpers
-- Move the ball: calculate the new position depending of the current MovementVector
function Ball:moveTo(MovementVector)
    self.x = self.x + MovementVector.x
    self.y = self.y + MovementVector.y
end

return Ball, BallState, MovementVector
