
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
   _loadFont()
   gDrawFuncs = {
      ["init"] = Menu.draw,
      ["game"] = _drawGame,
      ["end"] = Menu.draw,
   }
   _resetGame()
end

function love.draw()
   local drawFunc = gDrawFuncs[GameState.state]
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
   end

   if GameState.state ~= "game" then
      Menu:keypressed(key)
      if Menu:isReady() then
         Particles:greenBurst()
         _restartGame()
      end
   else
      if Player.rayPosition == Target.rayPosition
      and Player.rayCount == Target.rayCount then
         _turnSucceeded()
      end
   end
end

function love.update(dt)
   Particles:update(dt)
   if GameState.state == "game" then
      if GameState.vitality < 2 then
         Particles:maybeDanger()
      end
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
   Particles:redBurst()
   if GameState.vitality <= 0 then
      if GameState.state ~= "end" then
         GameState.state = "end"
      end
      _resetGame()
   end
end

function _turnSucceeded()
   Timer:turnSucceeded()
   GameState:turnSucceeded()
   Target:permute(Player.rayPosition, Player.rayCount)
   gScale = 1.1
   Particles:greenBurst()
   Particles:playerMatched(Player.rayPosition, Player.rayCount)
end

function _drawGame()
   love.graphics.setColor(1, 1, 1, 1)
   local centerX = GameState.viewport.width * 0.5
   local centerY = GameState.viewport.height * 0.5
   local radius = Circloid._radiusToDraw
   local scoreStr = tostring(GameState.score)
   local scoreWidth = GameState.font:getWidth(scoreStr)
   love.graphics.print(scoreStr, centerX - scoreWidth * 0.5, centerY - GameState.font:getHeight() * 0.5)
   
   love.graphics.push()
   love.graphics.translate(centerX, centerY)
   love.graphics.scale(gScale, gScale)
   Player:draw(radius)
   Target:draw(radius)
   Timer:draw(radius)
   love.graphics.pop()

   love.graphics.setBlendMode("add")
   Particles:draw()
   love.graphics.setBlendMode("alpha")
end

function _resetGame()
   gScale = 1
   Menu:reset()
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

function _loadFont()
   GameState.font = love.graphics.newFont("x14y24pxHeadUpDaisy.ttf") -- can't get size to work
   love.graphics.setFont(GameState.font)
end
