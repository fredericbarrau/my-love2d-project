-- Get the game config
Config = require("src.config")

local Panel = {
  title   = "Pong",
  message = "Default message"
}

function Panel:load()
end

function Panel:draw()
  love.graphics.setColor(Config.PANEL_COLOR_RED, Config.PANEL_COLOR_GREEN, Config.PANEL_COLOR_BLUE,
    Config.PANEL_COLOR_ALPHA)
  love.graphics.rectangle("fill", Config:getPlaygroundMaxWidth() + 1, 0,
    love.graphics.getWidth() - Config:getPlaygroundMaxWidth() - 1, love.graphics.getHeight())
  -- Print the Title
  love.graphics.setColor(0.9, 0.9, 0.9, 1)
  love.graphics.print(self.title, Config:getPlaygroundMaxWidth() + 30, 10, 0, 1.2, 1.2)

  -- Print the message
  love.graphics.print(self.message, Config:getPlaygroundMaxWidth() + 20, 50, 0, 1, 1)
end

function Panel:setMessage()
  self.message = message
end

function Panel:update(dt)
end

return Panel
