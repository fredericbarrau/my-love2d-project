-- The ball entity

-- The game configuration
local config = require("src.config")

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
    colorR = config.BALL_COLOR_RED,
    colorG = config.BALL_COLOR_GREEN,
    colorB = config.BALL_COLOR_BLUE,
    colorAlpha = config.BALL_COLOR_ALPHA,
    showMvmtVector = false, -- Show the vector of the movement (for aiming)
    state = BallState.START -- state of the ball (BallState.START, BallState.MOVING, BallState.OUT)
}

-- Common methods for Love
function Ball:load(x, y)
    self:setX(x):setY(y)

    self.max_x = love.graphics.getWidth()
    self.max_y = love.graphics.getHeight()
    self.current_movement =
        EntityMovement:new()
    self.current_movement:setEntityMovement({ x = 0, y = 0 })
end

function Ball:draw()
    love.graphics.setColor(self.colorR, self.colorG, self.colorB, self.colorAlpha)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

--     Update the ball positions
--     @param dt: delta times
function Ball:update(dt, control_player)
    local next_position
    -- Ball stuck on a player racket
    if (self.state == BallState.START) then
        next_position = control_player:getBallCenterPosition(self.radius)
        -- self:setX(position.x):setY(position.y)
    elseif (self.state == BallState.MOVING) then
        -- Get the hypothetical next position
        next_position = self:getNextPosition()
    end
    return next_position
end

-- Helpers

-- Launch the ball from a player racket
-- @param control_player: the player that launches the ball
--
-- Set the ball position, change the ball state and apply the entity movement vector
function Ball:launched(control_player)
    if self.state == BallState.START then
        -- TODO: this will be the initial aiming vector
        -- for now, it is static, but it will be dynamic, using the current
        -- position of the player and the racket current movement

        self.current_movement:setEntityMovement({ x = 2, y = 2 })
        self.state = BallState.MOVING
    end
end

function Ball:setX(x)
    self.x = math.floor(x)
    return self
end

function Ball:setY(y --[[number]])
    self.y = math.floor(y)
    return self
end

-- Move the ball: calculate the new position depending of the current MovementVector
function Ball:getNextPosition()
    local new_x, new_y = self.current_movement:moveEntity(self)
    return { x = new_x, y = new_y }
end

return Ball, BallState
