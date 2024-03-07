-- Import the player entity
Player = require("src.entities.player")

-- import the ball entity
Ball = require("src.entities.ball")


-- Create a new game scene
Game = {}

-- Initialize the game scene
function Game:load()
    -- Create a new player
    Player1 = Player:new()
    Player2 = Player:new()

    Player1:init(1)
    Player2:init(2)

    -- Who starts ?
    self.current_starter = Player1
    -- Who's the one in control of the ball ?
    self.current_launcher = self.current_starter
    -- Initial player setup
    self.current_launcher:setBallLauncher(true)

    -- Setup the keys for the players
    Player2:setKeys("a", "z")

    -- Initial setup for the ball
    local ball_initial_position = self.current_launcher:getBallCenterPosition(Ball.radius)
    Ball:load(ball_initial_position.x, ball_initial_position.y)
end

-- Update the game scene
function Game:update(dt)
    -- Update the player
    Player1:update(dt)
    Player2:update(dt)

    -- Update the ball
    Ball:update(dt, self.current_launcher)
end

-- Draw the game scene
function Game:draw()
    -- Draw the player
    Player1:draw()
    Player2:draw()
    -- Draw the ball
    Ball:draw()
end

return Game
