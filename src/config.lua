-- Manage the game configuration
-- Read configuration from environment variables
-- Return a table with the configuration

local config = {}

-- dirty check if we are in the browser
function config:isBrowser()
  return os.getenv("PONG_LOCAL") == "" or os
end

function config:getPlaygroundMaxHeigh()
  return self["PLAYGROUND_HEIGHT"] + self["PLAYGROUND_Y"]
end

function config:getPlaygroundMaxWidth()
  return self["PLAYGROUND_WIDTH"] + self["PLAYGROUND_X"]
end

if config:isBrowser()
then
  -- The color of the Ball, in the browser
  config["BALL_COLOR_RED"] = 0
  config["BALL_COLOR_GREEN"] = 1
  config["BALL_COLOR_BLUE"] = 1
  config["BALL_COLOR_ALPHA"] = 1
else
  -- The color of the Ball
  local ball_color = os.getenv("PONG_BALL_COLOR") or '1,0,0,1';
  local ball_color_array = {}
  local index = 0
  for str in string.gmatch(ball_color, "([^,]+)") do
    table.insert(ball_color_array, index, str)
    index = index + 1
  end

  config["BALL_COLOR_RED"] = ball_color_array[0]
  config["BALL_COLOR_GREEN"] = ball_color_array[1]
  config["BALL_COLOR_BLUE"] = ball_color_array[2]
  config["BALL_COLOR_ALPHA"] = ball_color_array[3]
end

-- The size of the playground
config["PLAYGROUND_WIDTH"] = 400
config["PLAYGROUND_HEIGHT"] = 400
-- The playground position
config["PLAYGROUND_X"] = 0
config["PLAYGROUND_Y"] = 0

-- The playground color
config["PLAYGROUND_COLOR_RED"] = 0
config["PLAYGROUND_COLOR_GREEN"] = 0
config["PLAYGROUND_COLOR_BLUE"] = 0
config["PLAYGROUND_COLOR_ALPHA"] = 1

return config
