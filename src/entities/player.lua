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
function Player.new(self, player_num)
	self = setmetatable({}, Player)
	self.player_num = player_num
	-- Min & Max X position for the horizontal mouvement
	self.min_x = self.margin_x
	self.max_x = love.graphics.getWidth() - self.width - self.margin_x
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
	elseif love.keyboard.isDown(self.key_shoot) and self.ball_launcher then
		-- Launch the ball
		-- Apply the movement vector to the ball
		
		self.ball_launcher = false
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

function Player:setKeys(left, right, shoot)
	self.key_left = left
	self.key_right = right
	self.key_shoot = shoot
end

-- Return the X pos of the ball when it is attached to the player's racket
function Player:getBallStartupY()
	return self.y + self.height / 2
end

-- Set the ball launcher attribute: if true, the ball is attached to the plauyer's racket
function Player:setBallLauncher(ball_launcher)
	self.ball_launcher = ball_launcher
	return self.ball_launcher
end

return Player
