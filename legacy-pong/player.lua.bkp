Player = {
    x = 20,
    y = 40,
    width = 15,
    height = 100,
    colorR = 0,
    colorG = 0,
    colorB = 0,
    speed = 150,

    min_y = 0,
    max_y = nil,

    key_up = "up",
    key_down = "down",

    player_num = 1,
}

function Player:new(o)
    o = o or {} -- create object if user does not provide one
    setmetatable(o,self)
    self.__index = self
    return o
end

function Player:update(dt)
    if love.keyboard.isDown(self.key_up) then
        if self.y >= 0 then
            self.y = self.y - self.speed * dt
        end
    elseif love.keyboard.isDown(self.key_down) then
        if (self.y + self.height) <= self.max_y then
            self.y = self.y + self.speed * dt
        end
    end
end

function Player:draw()
    love.graphics.setColor(self.colorR,self.colorG,self.colorB)
    love.graphics.rectangle('fill',self.x, self.y,self.width,self.height)
end

-- Helpers

function Player:load(window_width, window_height,player_num)
    self.max_y = window_height -- boudaries for mouvement
    self.player_num = player_num
    if player_num == 1 then
        self:setPosition(20, window_height / 2 - self.height /2)
    else
        self:setPosition(window_width - 20, window_height / 2 - self.height /2)
        self:setColor(255,255,255)
    end
end

function Player:setColor(r,g,b)
    self.colorR = r
    self.colorG = g
    self.colorB = b
end

function Player:setPosition(x,y)
    self.x = x
    self.y = y
end

function Player:setKeys(up,down)
    self.key_up = up
    self.key_down = down
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