-- Get the game config
Config = require("src.config")

-- import the playground
Playground = require("src.entities.playground")

local Panel = {
  title          = "Pong",
  message        = "Welcome to Pong!\nPress space to start.",
  bottom_message = "This is Pong, dude.",
  player_1_score = 0,
  player_2_score = 0
}

function Panel:load()
end

function Panel:draw()
  love.graphics.setColor(Config.PANEL_COLOR_RED, Config.PANEL_COLOR_GREEN, Config.PANEL_COLOR_BLUE,
    Config.PANEL_COLOR_ALPHA)
  love.graphics.rectangle("fill", Playground:getMaxX() + 1, 0,
    love.graphics.getWidth() - Playground:getMaxX() - 1, love.graphics.getHeight())
  -- Print the Title
  love.graphics.setColor(0.9, 0.9, 0.9, 1)
  love.graphics.print(self.title, Playground:getMaxX() + 50, 10, 0, 1.4, 1.4)

  -- Print the message
  love.graphics.print(self.message, Playground:getMaxX() + 20, 50, 0, 1, 1)

  -- Print the score

  love.graphics.print("Player 1: " .. self.player_1_score, Playground:getMaxX() + 20, 100, 0, 1, 1)
  love.graphics.print("Player 2: " .. self.player_2_score, Playground:getMaxX() + 20, 120, 0, 1, 1)

  -- Print the bottom message
  love.graphics.setColor(0.3, 0.3, 0.3, 1)
  love.graphics.print(self.bottom_message, Playground:getMaxX() + 20, love.graphics.getHeight() - 20, 0, 1, 1)
end

function Panel:setMessage(message)
  self.message = message
end

function Panel:manageScore(player --[[Player]])
  self:setMessage("Player: " .. player.player_num .. " scored! ")
  if player.player_num == 1 then
    self.player_1_score = self.player_1_score + 1
  else
    self.player_2_score = self.player_2_score + 1
  end
end

function Panel:update(dt)
end

return Panel
