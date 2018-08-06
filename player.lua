GameState = require 'gamestate'
Particles = require 'particles'
Ray = require 'ray'

Player = {
   rayPosition = 0,
   rayCount = 1,
}

function Player:reset()
   -- nothing here
end

function Player:rotateClockwise()
   Particles:playerMoved(self.rayPosition, self.rayCount)
   self.rayPosition = self.rayPosition + 1
   if self.rayPosition > 11 then
      self.rayPosition = 0
   end
end

function Player:rotateCounter()
   Particles:playerMoved(self.rayPosition, self.rayCount)
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
   love.graphics.push("all")
   if GameState.vitality <= 1 and math.random() < 0.4 then
      love.graphics.setLineWidth(4)
      if math.random() < 0.8 then
         love.graphics.setColor(1, 0, 0, 1)
         love.graphics.translate(math.random(-4, 4), math.random(-4, 4))
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
   love.graphics.circle("line", 0, 0, radius)
   local minorRadii = { inner = radius * 1.2, outer = radius * 1.5 }
   local majorRadii = { inner = radius * 0.8, outer = radius * 1.6 }
   Ray.drawSet(self.rayPosition, self.rayCount, majorRadii, minorRadii, "outer");
   love.graphics.pop()
end

return Player
