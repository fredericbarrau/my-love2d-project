-- Player entity
local Player = {
	width = 100,
	height = 12,
	colorR = 255,
	colorG = 255,
	colorB = 255,
	speed = 150,

	margin_x = 5, -- invisible margin left and right of the pad
	margin_y = 20, -- invisible margin up and down of the pad

	key_left = "left",
	key_right = "right",
	key_shoot = "space",

	player_num = 1,

	ball_launcher = false
}

-- Constructor
function Player:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Player:init(player_num)
	-- Player number
	self.player_num = player_num
	-- Min & Max X position for the horizontal mouvement
	self.min_x      = self.margin_x
	self.max_x      = love.graphics:getWidth() - self.width - self.margin_x
	-- Initial x & y position
	self.x          = love.graphics:getWidth() / 2 - self.width / 2 + self.margin_x
	self.y          = self.margin_x + self.height / 2
	if self.player_num == 2 then
		self.y = love.graphics:getHeight() - self.height - self.margin_y
		self:setKeys("q", "s")
	end
end

-- Update player position
function Player:update(dt, ball)
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
	elseif love.keyboard.isDown(self.key_shoot) and self.ball_launcher then
		-- Launch the ball
		-- Apply the movement vector to the ball

		self.ball_launcher = false

		-- Default vector 100 px / update timestep
		ball:launched(self)
	end
end

-- Draw player
function Player:draw()
	love.graphics.setColor(self.colorR, self.colorG, self.colorB)
	love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

-- Helpers

function Player:setColor(r, g, b)
	self.colorR = r
	self.colorG = g
	self.colorB = b
end

function Player:setPosition(x, y)
	self.x = x
	self.y = y
end

function Player:setKeys(left, right, shoot)
	self.key_left = left
	self.key_right = right
	self.key_shoot = shoot
end

-- Return the X and Y pos of the racket
function Player:getRacketHookPosition()
	-- adding a 1 pixel to the y position to avoid
	-- a collision detection
	if self.player_num == 1 then
		return { x = self.x + self.width / 2, y = self.y + self.height + 1 }
	else
		return { x = self.x + self.width / 2, y = self.y - 1 }
	end
end

function Player:getBallCenterPosition(radius)
	local center = self:getRacketHookPosition()
	if self.player_num == 1 then
		return { x = center.x, y = center.y + radius }
	end
	return { x = center.x, y = center.y - radius }
end

-- Set the ball launcher attribute: if true, the ball is attached to the plauyer's racket
function Player:setBallLauncher(ball_launcher)
	self.ball_launcher = ball_launcher
	return self.ball_launcher
end

-- Check if the ball has a collision with the player's racket
function Player:hasCollision(next_position, ball)
	-- Check the collision with the player 1
	if self.player_num == 2 then
		if next_position.y + ball.radius >= self.y then
			if next_position.x >= self.x and next_position.x <= self.x + self.width then
				return true
			end
		end
	else
		if next_position.y - ball.radius <= self.y + self.height then
			if next_position.x >= self.x and next_position.x <= self.x + self.width then
				return true
			end
		end
	end
	return false
end

return Player
