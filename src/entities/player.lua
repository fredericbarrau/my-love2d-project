-- Player entity
local Player = {
    width = 100,
    height = 12,
    colorR = 255,
    colorG = 255,
    colorB = 255,
    speed = 150,

    margin_x = 5,  -- invisible margin left and right of the pad
    margin_y = 20, -- invisible margin up and down of the pad

    key_left = "left",
    key_right = "right",

    player_num = 1,
}
-- Min & Max X position for the horizontal mouvement
Player.min_x = Player.margin_x
Player.max_x = love.graphics.getWidth() - Player.width - Player.margin_x

Player.__index = Player

-- Constructor
function Player.new(self, player_num)
    self = setmetatable({}, Player)
    self.player_num = player_num
    -- Initial x & y position
    self.x = love.graphics.getWidth() / 2 - self.width / 2 + self.margin_x
    self.y = self.margin_x + self.height / 2
    if self.player_num == 2 then
        self.y = love.graphics.getHeight() - self.height - self.margin_y
        self:setKeys("q", "s")
    end
    return self
end

-- Update player position
function Player:update(dt)
    if love.keyboard.isDown(self.key_left) then
        if self.x >= self.min_x then
            self.x = self.x - self.speed * dt
        else
            self.x = self.min_x
        end
    elseif love.keyboard.isDown(self.key_right) then
        if self.x <= self.max_x then
            self.x = self.x + self.speed * dt
        else
            self.x = self.max_x
        end
    end
end

-- Draw player
function Player:draw()
    love.graphics.setColor(self.colorR, self.colorG, self.colorB)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

-- Helpers

function Player:load()
    -- Load player assets
end

function Player:setColor(r, g, b)
    self.colorR = r
    self.colorG = g
    self.colorB = b
end

function Player:setPosition(x, y)
    self.x = x
    self.y = y
end

function Player:setKeys(left, right)
    self.key_left = left
    self.key_right = right
end

-- Return the X pos of the ball when it is attached to the player's racket
function Player:getBallStartupX(ball_radius)
    local ball_x = 0
    if self.player_num == 1 then
        ball_x = self.x + self.width + ball_radius
    else
        ball_x = self.x - ball_radius
    end
    return ball_x
end

function Player:getBallStartupY()
    return self.y + self.height / 2
end

return Player
