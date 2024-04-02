-- Manage the game configuration
-- Read configuration from environment variables
-- Return a table with the configuration

local config = {}

-- dirty check if we are in the browser
function config:isBrowser()
  return os.getenv("PONG_LOCAL") == "" or os
end

if config:isBrowser()
then
  -- The color of the Ball, in the browser
  config["BALL_COLOR_RED"] = 0
  config["BALL_COLOR_GREEN"] = 1
  config["BALL_COLOR_BLUE"] = 1
  config["BALL_COLOR_ALPHA"] = 1

  -- Game is slower in the browser: increase the speed of the ball
  config.BALL_VECTOR_SPEED_X = 4
  config.BALL_VECTOR_SPEED_Y = 4
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

  config.BALL_VECTOR_SPEED_X = 2
  config.BALL_VECTOR_SPEED_Y = 2
end

-- The playground color
config["PLAYGROUND_COLOR_RED"] = 0.2
config["PLAYGROUND_COLOR_GREEN"] = 0.2
config["PLAYGROUND_COLOR_BLUE"] = 0.2
config["PLAYGROUND_COLOR_ALPHA"] = 2

-- Panel Config
config["PANEL_COLOR_RED"] = 0
config["PANEL_COLOR_GREEN"] = 0
config["PANEL_COLOR_BLUE"] = 0
config["PANEL_COLOR_ALPHA"] = 1

return config
