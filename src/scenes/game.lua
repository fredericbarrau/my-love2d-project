-- Import the configuration
Config = require("src.config")

-- Import the player entity
Player = require("src.entities.player")

-- import the ball entity
Ball = require("src.entities.ball")

-- Import the panel entity
Playground = require("src.entities.playground")

-- import the score panel entity
Panel = require("src.entities.score_panel")

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
    self.current_ball_owner = self.current_starter
    -- Initial player setup
    self.current_ball_owner:setBallLauncher(true)

    -- Setup the keys for the players
    Player2:setKeys("a", "z", "lshift")

    -- Initial setup for the ball
    local ball_initial_position = self.current_ball_owner:getBallCenterPosition(Ball.radius)
    Ball:load(ball_initial_position.x, ball_initial_position.y)

    -- Define new event
    love.handlers.scored = function(player)
        Panel:manageScore(player)
    end
end

-- Update the game scene
function Game:update(dt)
    -- Update the player
    Player1:update(dt, Ball)
    Player2:update(dt, Ball)

    -- Update the ball, return the next ball position
    local next_position = Ball:update(dt, self.current_ball_owner)
    if Ball.state == BallState.START then
        -- The ball is stuck on a player racket
        -- set the ball position
        Ball:setX(next_position.x):setY(next_position.y)
    elseif Ball.state == BallState.MOVING then
        -- The ball is moving

        -- Check the collision with the player 1
        if Player1:hasCollision(next_position, Ball) then
            -- Bounce the ball
            local bounced_position_x, bounced_position_y = Ball.current_movement:bounceY(Ball)
            Ball:setX(bounced_position_x)
            -- the y position is restrained by the racket (we don't want to go through the racket)
            if next_position.y < Player1.y then
                Ball:setY(Player1:getBallCenterPosition(Ball.radius).y)
            else
                Ball:setY(bounced_position_y)
            end

            -- Check the collision with the player 2
        elseif Player2:hasCollision(next_position, Ball) then
            -- Bounce the ball
            local bounced_position_x, bounced_position_y = Ball.current_movement:bounceY(Ball)
            Ball:setX(bounced_position_x)

            -- the y position is restrained by the racket (we don't want to go through the racket)
            if next_position.y > Player2.y then
                Ball:setY(Player2:getBallCenterPosition(Ball.radius).y)
            else
                Ball:setY(bounced_position_y)
            end
            -- Check the colision with the left and right of the allowed position of the ball
        elseif next_position.x < Ball.min_x or next_position.x > Ball.max_x then
            -- Bounce the ball
            local bounced_position_x, bounced_position_y = Ball.current_movement:bounceX(Ball)
            Ball:setX(bounced_position_x):setY(bounced_position_y)
            -- Check the colision with the top and bottom of the screen
        elseif next_position.y < Ball.min_y then
            -- Trigger the event to update the score
            love.event.push("scored", Player2)

            Ball.state = BallState.START
            -- Who's the one in control of the ball now ?
            self.current_ball_owner = Player1
            -- Initial player setup
            self.current_ball_owner:setBallLauncher(true)
        elseif next_position.y > Ball.max_y then
            -- Trigger the event to update the score
            love.event.push("scored", Player1)

            Ball.state = BallState.START
            -- Who's the one in control of the ball ?
            self.current_ball_owner = Player2
            -- Initial player setup
            self.current_ball_owner:setBallLauncher(true)
        else
            -- Set the next position of the ball
            Ball:setX(next_position.x):setY(next_position.y)
        end
    end
    -- Update the panel
    -- Panel:update(dt)
end

-- Draw the game scene
function Game:draw()
    -- Draw the playground
    love.graphics.setColor(Playground.colorR, Playground.colorG, Playground.colorB, Playground.colorA)
    love.graphics.rectangle('fill', Playground:getX(), Playground:getY(), Playground:getWidth(),
        Playground:getHeight())

    -- Draw the player
    Player1:draw()
    Player2:draw()
    -- Draw the ball
    Ball:draw()
    -- Draw the panel
    Panel:draw()
end

return Game
