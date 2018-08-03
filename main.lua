-- steps for friday
--
-- mechanism
-- scale diff
---+ key count scales up
---- key count scales up better... 
---- key counts farther apart from prev
---- failure resets target
-- redo timer drawing to be inside circle?
-- menu: turn the key around to start
-- show timer feedback when you gain time
-- make score more obvious
-- more feedback when you move?
-- rotate circle?
-- scale circle size w/ level?
-- combos?
-- graphical polish
---- cool backgrounds
---- intensity near loss
---- intensity after loss

GameState = require 'gamestate'
Player = require 'player'
Target = require 'target'
Particles = require 'particles'
Timer = require 'timer'

Circloid = {
   _radiusToDraw = 0,
}

function love.load()
   gDrawFuncs = {
      ["init"] = _drawInit,
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
   if GameState.state == "game" then
      if key == "a" then
         Player:rotateCounter()
      elseif key == "d" then
         Player:rotateClockwise()
      elseif key == "w" then
         Player:addRay()
      elseif key == "s" then
         Player:subtractRay()
      end
   else
      if key == "space" then
         if GameState.state ~= "game" then
            _resetGame()
            _restartGame()
         end
      end
   end

   if Player.rayPosition == Target.rayPosition
      and Player.rayCount == Target.rayCount then
         _turnSucceeded()
   end
end

function love.update(dt)
   if gScale ~= 1 then
      gScale = gScale + (1 - gScale) * 0.25
      if math.abs(1 - gScale) < 0.01 then
         gScale = 1
      end
   end
   Circloid._radiusToDraw = Circloid._radiusToDraw + (GameState:getRadius() - Circloid._radiusToDraw) * 0.25
   Particles:update(dt)
   Timer:update(dt)
   if Timer:isExpired() then
      _turnFailed()
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
   Particles:add(3, {
                    x = GameState.viewport.width * 0.5,
                    y = GameState.viewport.height * 0.5,
                    radius = GameState:getRadius(),
                    lifespan = 0.6
   })
end

function _drawInit()
   love.graphics.print("WASD", GameState.viewport.width * 0.25, GameState.viewport.height * 0.5)
   love.graphics.print("<space> to start", GameState.viewport.width * 0.25, GameState.viewport.height * 0.55)
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
   love.graphics.pop()
   
   Particles:draw()
   Timer:draw()
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
