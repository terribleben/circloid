GameState = require 'gamestate'
Player = require 'player'
Particles = require 'particles'

Menu = {
   _state = "init",
   _instructions = "ready?",
   _rayPosition = 7,
   _rayCount = 3,
}

function Menu:draw()
   love.graphics.setColor(1, 1, 1, 1)
   local centerX = GameState.viewport.width * 0.5
   local centerY = GameState.viewport.height * 0.5
   local radius = GameState:getRadius()
   
   love.graphics.push()
   love.graphics.translate(centerX, centerY)
   love.graphics.circle("line", 0, 0, radius)
   Player:draw(radius)

   Menu._drawRays(Menu, radius)

   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.print("WASD", -16, -7)
   love.graphics.rotate(((math.pi * 2) / 12) * Menu._rayPosition)
   love.graphics.print(Menu._instructions, (radius * 1.2) + 7, -7)
   love.graphics.pop()
   
   Particles:draw()
end

function Menu:keypressed(key)
   -- check if in 'ready' -> go to start
   if self._state == "init" and self:_isPlayerMatched() then
      self._state = "ready"
      self._instructions = "start"
      self._rayCount = 1
      self._rayPosition = 0
      Particles:greenBurst()
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

function Menu:_isPlayerMatched()
   return (Player.rayPosition == self._rayPosition and Player.rayCount == self._rayCount)
end

return Menu
