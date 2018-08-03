GameState = require 'gamestate'
Ray = require 'ray'

Player = {
   rayPosition = 0,
   rayCount = 1,
}

function Player:reset()
   -- nothing here
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
   love.graphics.push("all")
   if GameState.vitality == 1 and math.random() < 0.4 then
      love.graphics.setLineWidth(3)
      if math.random() < 0.8 then
         love.graphics.setColor(1, 0, 0, 1)
      else
         love.graphics.setColor(0.5, 0.5, 0.5, 1)
         love.graphics.translate(math.random(-7, 7), math.random(-7, 7))
      end
   else
      love.graphics.setLineWidth(2)
      love.graphics.setColor(1, 1, 1, 1)
   end
   love.graphics.circle("line", 0, 0, radius)
   local minorRadii = { inner = radius * 1.2, outer = radius * 1.5 }
   local majorRadii = { inner = radius * 0.8, outer = radius * 1.6 }
   Ray.drawSet(self.rayPosition, self.rayCount, majorRadii, minorRadii, "outer");
   love.graphics.pop()
end

return Player
