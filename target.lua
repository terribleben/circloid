GameState = require 'gamestate'
Ray = require 'ray'

Target = {
   rayPosition = 0,
   rayCount = 0,
}

function Target:reset()
   self.rayPosition = 0
   self.rayCount = 1
end

function Target:permute(playerRayPosition, playerRayCount)
   -- (linear: local maxNumRays = 1 + math.floor(GameState.numTurnsSucceeded / 4))
   local maxNumRays
   if (GameState.numTurnsSucceeded < 5) then
      maxNumRays = 1
   else
      maxNumRays = math.floor(math.log(GameState.numTurnsSucceeded / 5), 2) + 2
   end
   maxNumRays = math.min(6, maxNumRays)
   while playerRayPosition == self.rayPosition
   and playerRayCount == self.rayCount do
      self.rayPosition = math.random(0, 11)
      self.rayCount = math.random(1, maxNumRays)
   end
end

function Target:draw(radius)
   love.graphics.setColor(0, 1, 1, 1)
   local minorRadii = { inner = radius, outer = radius * 1.2 }
   local majorRadii = { inner = radius * 0.4, outer = radius * 1.2 }
   Ray.drawSet(self.rayPosition, self.rayCount, majorRadii, minorRadii, "inner")
end

return Target
