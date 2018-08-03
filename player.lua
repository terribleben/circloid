Ray = require 'ray'

Player = {
   rayPosition = 0,
   rayCount = 0,
}

function Player:reset()
   self.rayPosition = 0
   self.rayCount = 1
end

function Player:rotateClockwise()
   self.rayPosition = self.rayPosition + 1
   if self.rayPosition > 11 then
      self.rayPosition = 0
   end
end

function Player:rotateCounter()
   self.rayPosition = self.rayPosition - 1
   if self.rayPosition < 0 then
      self.rayPosition = 11
   end
end

function Player:addRay()
   self.rayCount = self.rayCount + 1
   if self.rayCount > 6 then
      self.rayCount = 6
   end
end

function Player:subtractRay()
   self.rayCount = self.rayCount - 1
   if self.rayCount < 1 then
      self.rayCount = 1
   end
end

function Player:draw(radius)
   love.graphics.setColor(1, 1, 1, 1)
   local minorRadii = { inner = radius * 1.2, outer = radius * 1.5 }
   local majorRadii = { inner = radius * 0.8, outer = radius * 1.6 }
   Ray.drawSet(self.rayPosition, self.rayCount, majorRadii, minorRadii, "outer");
end

return Player
