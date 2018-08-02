
gScreenWidth = 800
gScreenHeight = 600

gGameState = "init"

MAX_TIME_REMAINING = 1

function love.load()
   width, height, flags = love.window.getMode()
   gScreenWidth = width
   gScreenHeight = height
   gDrawFuncs = {
      ["init"] = _drawInit,
      ["game"] = _drawGame,
      ["end"] = _drawGameOver,
   }
   _restartGame()
   _computeNewTarget()
end

function love.draw()
   _step(love.timer.step())
   local drawFunc = gDrawFuncs[gGameState]
   drawFunc()
end

function love.keypressed(key, scancode, isrepeat)
   if key == "a" then
      gPlayerPosition = gPlayerPosition - 1
      if gPlayerPosition < 0 then
         gPlayerPosition = 11
      end
   elseif key == "d" then
      gPlayerPosition = gPlayerPosition + 1
      if gPlayerPosition > 11 then
         gPlayerPosition = 0
      end
   elseif key == "w" then
      gPlayerCount = gPlayerCount + 1
      if gPlayerCount > 5 then
         gPlayerCount = 5
      end
   elseif key == "s" then
      gPlayerCount = gPlayerCount - 1
      if gPlayerCount < 1 then
         gPlayerCount = 1
      end
   elseif key == "space" then
      if gGameState ~= "game" then
         gGameState = "game"
         _restartGame()
      end
   end

   if gPlayerPosition == gTargetPosition
      and gPlayerCount == gTargetCount then
         _computeNewTarget()
         gScore = gScore + 1
   end
end

function _step(dt)
   gTimeRemaining = gTimeRemaining - (dt * 1.5)
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
   _drawIndicatorSet(centerX, centerY, gPlayerPosition, gPlayerCount)
   love.graphics.setColor(1, 0, 0, 1)
   _drawIndicatorSet(centerX, centerY, gTargetPosition, gTargetCount)
   love.graphics.rectangle(
      "line",
      10, gScreenHeight - 50,
      (gScreenWidth - 20) * (gTimeRemaining / MAX_TIME_REMAINING),
      30
   )
end

function _restartGame()
   gScore = 0
   gPlayerPosition = 0
   gTargetPosition = 0
   gPlayerCount = 1
   gTargetCount = 1
   gTimeRemaining = MAX_TIME_REMAINING
end

function _computeNewTarget()
   while gPlayerPosition == gTargetPosition
   and gPlayerCount == gTargetCount do
      gTargetPosition = math.random(0, 11)
      gTargetCount = math.random(1, 3)
   end
   gTimeRemaining = gTimeRemaining + (MAX_TIME_REMAINING * 0.1)
   if gTimeRemaining > MAX_TIME_REMAINING then
      gTimeRemaining = MAX_TIME_REMAINING
   end
end

function _drawIndicatorSet(centerX, centerY, position, count)
   for idx = 0, count - 1 do
      local initialAngle = ((math.pi * 2) / count) * idx
      _drawIndicator(centerX, centerY, position, initialAngle)
   end
end

function _drawIndicator(centerX, centerY, position, initialAngle)
   local innerRadius = gScreenHeight * 0.2
   local outerRadius = gScreenHeight * 0.4
   if initialAngle ~= 0 then
      innerRadius = gScreenHeight * 0.3
   end
   local angle = initialAngle + (((math.pi * 2) / 12) * position)
   love.graphics.line(
      centerX + innerRadius * math.cos(angle),
      centerY + innerRadius * math.sin(angle),
      centerX + outerRadius * math.cos(angle),
      centerY + outerRadius * math.sin(angle)
   )
end
