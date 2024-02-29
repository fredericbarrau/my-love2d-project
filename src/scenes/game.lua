-- Import the player entity
Player = require("src.entities.player")

-- import the ball entity
Ball = require("src.entities.ball")


-- Create a new game scene
local Game = {}

-- Initialize the game scene
function Game:load()
    -- Create a new player
    self.player1 = Player:new(1)
    self.player2 = Player:new(2)
    self.current_starter = self.player1.id
    -- Initial setup for Player1
    -- Load the player assets
    self.player1:load()
    self.player2:load()

    -- Initial player setup
    self.player1:setBallLauncher(true)
    self.current_launcher = self.player1.player_num

    -- Initial setup for the ball
    -- Ball:load(window_width, window_height, Player1:getBallStartupX(Ball.radius), Player1:getBallStartupY())
end

-- Update the game scene
function Game:update(dt)
    -- Update the player
    self.player1:update(dt)
    self.player2:update(dt, current_starter)
end

-- Draw the game scene
function Game:draw()
    -- Draw the player
    self.player1:draw()
    self.player2:draw()
end

return Game
