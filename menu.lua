GameState = require 'gamestate'
Player = require 'player'
Particles = require 'particles'

Menu = {
   _state = "init",
   _targetLabel = "",
   _centerLabel = "",
   _rayPosition = 0,
   _rayCount = 1,
}

function Menu:reset()
   if GameState.state == "init" then
      self._state = "init"
      self._targetLabel = "ready?"
      self._centerLabel = "WASD"
      self._rayPosition = 7
      self._rayCount = 3
   else
      self._centerLabel = "GAME OVER"
      self:_setReadyState(true)
   end
end

function Menu:draw()
   love.graphics.setColor(1, 1, 1, 1)
   local centerX = GameState.viewport.width * 0.5
   local centerY = GameState.viewport.height * 0.5
   local radius = GameState:getRadius()
   
   love.graphics.push()
   love.graphics.translate(centerX, centerY)
   Player:draw(radius)

   Menu._drawRays(Menu, radius)

   love.graphics.setColor(1, 1, 1, 1)
   local labelWidth = GameState.font:getWidth(Menu._centerLabel)
   love.graphics.print(Menu._centerLabel, labelWidth * -0.5, GameState.font:getHeight() * -0.5)
   love.graphics.rotate(((math.pi * 2) / 12) * Menu._rayPosition)
   love.graphics.print(Menu._targetLabel, (radius * 1.2) + 7, -7)
   love.graphics.pop()
   
   Particles:draw()
end

function Menu:keypressed(key)
   -- check if in 'ready' -> go to start
   if self._state == "init" and self:_isPlayerMatched() then
      self:_setReadyState(false)
      Particles:greenBurst()
      Particles:playerMatched(Player.rayPosition, Player.rayCount)
   end
end

function Menu:_drawRays(radius)
   love.graphics.setColor(0, 1, 1, 1)
   local minorRadii = { inner = radius, outer = radius * 1.2 }
   local majorRadii = { inner = radius * 0.4, outer = radius * 1.2 }
   Ray.drawSet(self._rayPosition, self._rayCount, majorRadii, minorRadii, "inner")
end

function Menu:isReady()
   return (self._state == "ready" and self:_isPlayerMatched())
end

function Menu:_setReadyState(isGameOver)
   self._state = "ready"
   self._targetLabel = "start"
   self._rayCount = 1
   if isGameOver then
      self._rayPosition = (Player.rayPosition + 6) % 12
   else
      self._rayPosition = 0
   end
end

function Menu:_isPlayerMatched()
   return (Player.rayPosition == self._rayPosition and Player.rayCount == self._rayCount)
end

return Menu
