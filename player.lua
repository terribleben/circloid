local GameState = require 'gamestate'
local Particles = require 'particles'
local Ray = require 'ray'

local Player = {
   rayPosition = 0,
   rayCount = 1,
   _recoilAngle = 0,
   _recoilAngularVelocity = 0,
   _recoilRadius = 0,
   _recoilRadialVelocity = 0,
}

function Player:reset()
   self._recoilAngle = 0
   self._recoilAngularVelocity = 0
   self._recoilRadius = 0
   self._recoilRadialVelocity = 0
end

function Player:rotateClockwise()
   Particles:playerMoved(self.rayPosition, self.rayCount)
   self.rayPosition = self.rayPosition + 1
   if self.rayPosition > 11 then
      self.rayPosition = 0
   end
   self._recoilAngularVelocity = 0.015
end

function Player:rotateCounter()
   Particles:playerMoved(self.rayPosition, self.rayCount)
   self.rayPosition = self.rayPosition - 1
   if self.rayPosition < 0 then
      self.rayPosition = 11
   end
   self._recoilAngularVelocity = -0.015
end

function Player:addRay()
   self.rayCount = self.rayCount + 1
   if self.rayCount > 6 then
      self.rayCount = 6
   end
   self._recoilRadialVelocity = 0.02
end

function Player:subtractRay()
   self.rayCount = self.rayCount - 1
   if self.rayCount < 1 then
      self.rayCount = 1
   end
   self._recoilRadialVelocity = -0.02
end

function Player:update(dt)
   self._recoilAngle = self._recoilAngle + self._recoilAngularVelocity
   self._recoilAngularVelocity = self._recoilAngularVelocity + (self._recoilAngle * -0.4)
   self._recoilAngularVelocity = self._recoilAngularVelocity * 0.6
   self._recoilRadius = self._recoilRadius + self._recoilRadialVelocity
   self._recoilRadialVelocity = self._recoilRadialVelocity + (self._recoilRadius * -0.4)
   self._recoilRadialVelocity = self._recoilRadialVelocity * 0.6
end

function Player:draw(radius)
   love.graphics.push("all")
   if GameState.vitality <= 1 and math.random() < 0.4 then
      love.graphics.setLineWidth(6)
      if math.random() < 0.8 then
         love.graphics.setColor(1, 0, 0, 1)
         love.graphics.translate(math.random(-5, 5), math.random(-5, 5))
      else
         love.graphics.translate(math.random(-12, 12), math.random(-12, 12))
         love.graphics.setColor(1, 0, 0, 0.5)
         love.graphics.circle("fill", 0, 0, radius)
         love.graphics.setColor(0.5, 0.5, 0.5, 1)
      end
   else
      love.graphics.setLineWidth(2)
      love.graphics.setColor(1, 1, 0, 1)
   end
   local i = 1
   repeat
      love.graphics.push("all")
      if i > 1 then
         love.graphics.setColor(1, 1, 0, 0.6)
      end
      love.graphics.circle("line", 0, 0, radius - (16 * (i - 1)))
      i = i + 1
      love.graphics.pop()
   until i > math.floor(GameState.vitality)
   local minorRadii = { inner = radius * 1.2, outer = radius * 1.5 }
   local majorRadii = { inner = radius + 40, outer = radius * 1.8 }
   love.graphics.scale(1 + self._recoilRadius, 1 + self._recoilRadius)
   love.graphics.rotate(self._recoilAngle)
   Ray.drawSet(self.rayPosition, self.rayCount, majorRadii, minorRadii, "inner");
   love.graphics.pop()
end

return Player
