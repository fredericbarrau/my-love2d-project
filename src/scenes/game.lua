-- Import the player entity
Player = require("src.entities.player")

-- import the ball entity
Ball = require("src.entities.ball")


-- Create a new game scene
Game = {}

-- Initialize the game scene
function Game:load()
    -- Create a new player
    self.player1 = Player:new()
    self.player2 = Player:new()

    self.player1:init(1)
    self.player2:init(2)

    self.current_starter = self.player1
    -- Initial setup for Player1

    -- Initial player setup
    self.player1:setBallLauncher(true)
    self.current_launcher = self.player1.player_num

    self.player2:setKeys("a", "z")

    -- Initial setup for the ball
    -- Ball:load(window_width, window_height, Player1:getBallStartupX(Ball.radius), Player1:getBallStartupY())
end

-- Update the game scene
function Game:update(dt)
    -- Update the player
    self.player1:update(dt)
    self.player2:update(dt)
end

-- Draw the game scene
function Game:draw()
    -- Draw the player
    self.player1:draw()
    self.player2:draw()
end

return Game
