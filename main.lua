
GameState = require 'gamestate'
Player = require 'player'
Target = require 'target'
Particles = require 'particles'
Timer = require 'timer'
Menu = require 'menu'

Circloid = {
   _radiusToDraw = 0,
}

function love.load()
   gDrawFuncs = {
      ["init"] = Menu.draw,
      ["game"] = _drawGame,
      ["end"] = _drawGameOver,
   }
   _resetGame()
end

function love.draw()
   local drawFunc = gDrawFuncs[GameState.state]
   drawFunc()
end

function love.keypressed(key, scancode, isrepeat)
   if GameState.state == "game" or GameState.state == "init" then
      if key == "a" then
         Player:rotateCounter()
      elseif key == "d" then
         Player:rotateClockwise()
      elseif key == "w" then
         Player:addRay()
      elseif key == "s" then
         Player:subtractRay()
      end
   end

   if GameState.state == "end" then
      if key == "space" then
         _resetGame()
         _restartGame()
      end
   end

   if GameState.state == "init" then
      Menu:keypressed(key)
      if Menu:isReady() then
         Particles:greenBurst()
         _resetGame()
         _restartGame()
      end
   end

   if GameState.state == "game" then
      if Player.rayPosition == Target.rayPosition
      and Player.rayCount == Target.rayCount then
         _turnSucceeded()
      end
   end
end

function love.update(dt)
   Particles:update(dt)
   if GameState.state == "game" then
      if gScale ~= 1 then
         gScale = gScale + (1 - gScale) * 0.25
         if math.abs(1 - gScale) < 0.01 then
            gScale = 1
         end
      end
      Circloid._radiusToDraw = Circloid._radiusToDraw + (GameState:getRadius() - Circloid._radiusToDraw) * 0.25
      Timer:update(dt)
      if Timer:isExpired() then
         _turnFailed()
      end
   end
end

function _turnFailed()
   -- remove vitality
   -- check game over
   Timer:turnFailed()
   GameState:turnFailed()
end

function _turnSucceeded()
   Timer:turnSucceeded()
   GameState:turnSucceeded()
   Target:permute(Player.rayPosition, Player.rayCount)
   gScale = 1.1
   Particles:greenBurst()
end

function _drawGameOver()
   love.graphics.print("GAME OVER", GameState.viewport.width * 0.25, GameState.viewport.height * 0.5)
   love.graphics.print("<space> to restart", GameState.viewport.width * 0.25, GameState.viewport.height * 0.55)
end

function _drawGame()
   love.graphics.setColor(1, 1, 1, 1)
   local centerX = GameState.viewport.width * 0.5
   local centerY = GameState.viewport.height * 0.5
   local radius = Circloid._radiusToDraw
   love.graphics.print(tostring(GameState.score), centerX, centerY)
   
   love.graphics.push()
   love.graphics.translate(centerX, centerY)
   love.graphics.scale(gScale, gScale)
   love.graphics.circle("line", 0, 0, radius)
   Player:draw(radius)
   Target:draw(radius)
   Timer:draw(radius)
   love.graphics.pop()
   
   Particles:draw()
end

function _resetGame()
   gScale = 1
   Player:reset()
   Target:reset()
   GameState:reset()
   Timer:reset()
   Circloid._radiusToDraw = GameState:getRadius()
end

function _restartGame()
   GameState.state = "game"
   Target:permute(Player.rayPosition, Player.rayCount)
end
