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
   for idx = 0, self._rayCount - 1 do
      local initialAngle = ((math.pi * 2) / self._rayCount) * idx
      self:_drawRay(radius, initialAngle)
   end
end

function Menu:_drawRay(radius, initialAngle)
   local innerRadius, outerRadius
   innerRadius = radius * 0.4
   outerRadius = radius * 1.2
   if initialAngle ~= 0 then
      innerRadius = radius
   end
   local angle = initialAngle + (((math.pi * 2) / 12) * self._rayPosition)
   love.graphics.line(
      innerRadius * math.cos(angle),
      innerRadius * math.sin(angle),
      outerRadius * math.cos(angle),
      outerRadius * math.sin(angle)
   )
end

function Menu:isReady()
   return (self._state == "ready" and self:_isPlayerMatched())
end

function Menu:_isPlayerMatched()
   return (Player.rayPosition == self._rayPosition and Player.rayCount == self._rayCount)
end

return Menu
