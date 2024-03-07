-- import the entityMovement library
EntityMovement = require("src.entities.entity_movement")

BallState = {
    START = 0,
    MOVING = 1,
    OUT = 2
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
    showMvmtVector = false, -- Show the vector of the movement (for aiming)
    state = BallState.START -- state of the ball (BallState.START, BallState.MOVING, BallState.OUT)
}

-- Common methods for Love
function Ball:load(x, y)
    self.x = x
    self.y = y
    self.max_x = love.graphics.getWidth()
    self.max_y = love.graphics.getHeight()
    self.current_movement =
        EntityMovement.new({ 0, 0, 0 }, { 0, 0, 0 })
end

function Ball:draw()
    love.graphics.setColor(self.colorR, self.colorG, self.colorB)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

--     Update the ball positions
--     @param dt: delta times
function Ball:update(dt, control_player)
    -- Ball stuck on a player racket
    if (self.state == BallState.START) then
        self.x = control_player.x + control_player.width / 2
        self.y = control_player.y - self.radius
    elseif (self.state == BallState.MOVING) then
        self:move()
    end
end

-- Helpers

-- Launch the ball from a player racket
-- @param control_player: the player that launches the ball
--
-- Set the ball position, change the ball state and apply the entity movement vector
function Ball:launched(control_player)
    self.state = BallState.START
    self.x = control_player.x + control_player.width / 2
    self.y = control_player.y - self.radius
    -- TODO: this will be the initial aiming vector
    -- for now, it is static, but it will be dynamic, using the current
    -- position of the player and the racket current movement
    local target_x = self.x + 100
    local target_y = self.y + 100
    self.current_movement.setEntityMovement({ x = self.x, y = self.y }, { x = target_x, y = target_y })
end

-- Move the ball: calculate the new position depending of the current MovementVector
function Ball:move()
    self.current_movement.moveEntity(self)
end

return Ball, BallState
