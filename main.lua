require "src.lib.jsApiPlayer.js"

--  Debugging setup in visual studio code
local lldebugger = false
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
   require("lldebugger").start()
   lldebugger = true
end

local game = require("src/scenes/game")

function love.load(args)
   -- This function will run once at the beginning of the game.
   -- You can use it to load assets, initialize variables, etc.
   game:load()
   -- Test of CallJS, should only work in the HTML5 version
   JS.callJS(JS.stringFunc(
      [[
         var test = 5;
         test+= 15;
         console.log(test);
      ]]
   ))
end

function love.update(dt)
   -- This function will run every frame and is where you can update the state of the game.
   game:update(dt)
end

function love.draw()
   -- This function will also run every frame and is where you can draw things to the screen.
   -- love.graphics.print('Hello World!', 400, 300)
   game:draw()
end

-- Error management
local love_errorhandler = love.errorhandler

function love.errorhandler(msg)
   if lldebugger then
      error(msg, 2)
   else
      return love_errorhandler(msg)
   end
end
