Player = require 'player'
Target = require 'target'

gScreenWidth = 800
gScreenHeight = 600

gGameState = "init"

MAX_TIME_REMAINING = 10

function love.load()
   width, height, flags = love.window.getMode()
   gScreenWidth = width
   gScreenHeight = height
   Player.centerX = gScreenWidth * 0.5
   Player.centerY = gScreenHeight * 0.5
   Target.centerX = gScreenWidth * 0.5
   Target.centerY = gScreenHeight * 0.5
   gDrawFuncs = {
      ["init"] = _drawInit,
      ["game"] = _drawGame,
      ["end"] = _drawGameOver,
   }
   _restartGame()
end

function love.draw()
   local drawFunc = gDrawFuncs[gGameState]
   drawFunc()
end

function love.keypressed(key, scancode, isrepeat)
   if key == "a" then
      Player:rotateCounter()
   elseif key == "d" then
      Player:rotateClockwise()
   elseif key == "w" then
      Player:addRay()
   elseif key == "s" then
      Player:subtractRay()
   elseif key == "space" then
      if gGameState ~= "game" then
         gGameState = "game"
         _restartGame()
      end
   end

   if Player.rayPosition == Target.rayPosition
      and Player.rayCount == Target.rayCount then
         _computeNewTarget()
         gScore = gScore + 1
   end
end

function love.update(dt)
   gTimeRemaining = gTimeRemaining - dt
   if gTimeRemaining < 0 then
      gTimeRemaining = 0
      if gGameState ~= "end" then
         gGameState = "end"
      end
   end
end

function _drawInit()
   love.graphics.print("WASD", gScreenWidth * 0.25, gScreenHeight * 0.5)
   love.graphics.print("<space> to start", gScreenWidth * 0.25, gScreenHeight * 0.55)
end

function _drawGameOver()
   love.graphics.print("GAME OVER", gScreenWidth * 0.25, gScreenHeight * 0.5)
   love.graphics.print("<space> to restart", gScreenWidth * 0.25, gScreenHeight * 0.55)
end

function _drawGame()
   love.graphics.setColor(1, 1, 1, 1)
   local centerX = gScreenWidth * 0.5
   local centerY = gScreenHeight * 0.5
   love.graphics.print(tostring(gScore), centerX, centerY)
   love.graphics.circle("line", centerX, centerY, gScreenHeight * 0.25)
   Player:draw(gScreenHeight)
   Target:draw(gScreenHeight)
   love.graphics.rectangle(
      "line",
      10, gScreenHeight - 50,
      (gScreenWidth - 20) * (gTimeRemaining / MAX_TIME_REMAINING),
      30
   )
end

function _restartGame()
   gScore = 0
   Player:reset()
   Target:reset()
   gTimeRemaining = MAX_TIME_REMAINING
   _computeNewTarget()
end

function _computeNewTarget()
   while Player.rayPosition == Target.rayPosition
   and Player.rayCount == Target.rayCount do
      Target.rayPosition = math.random(0, 11)
      Target.rayCount = math.random(1, 3)
   end
   gTimeRemaining = gTimeRemaining + (MAX_TIME_REMAINING * 0.1)
   if gTimeRemaining > MAX_TIME_REMAINING then
      gTimeRemaining = MAX_TIME_REMAINING
   end
end
