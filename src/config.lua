-- Manage the game configuration
-- Read configuration from environment variables
-- Return a table with the configuration


local config = {}

-- The color of the Ball
local ball_color = os.getenv("PONG_BALL_COLOR") or '255,0,0,1';
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

return config
