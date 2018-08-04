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
   local maxNumRays, pHardMove, isHardMove
   if (GameState.numTurnsSucceeded < 4) then
      maxNumRays = 1
      pHardMove = 0
   else
      maxNumRays = math.floor(math.log(GameState.numTurnsSucceeded / 2.8), 2) + 2
      pHardMove = 0.1 * maxNumRays
   end
   maxNumRays = math.min(6, maxNumRays)
   isHardMove = (math.random() < pHardMove)
   while playerRayPosition == self.rayPosition do
      if isHardMove then
         self:_makeHardTarget(playerRayPosition, playerRayCount, maxNumRays)
      else
         self:_makeRandomTarget(maxNumRays)
      end
   end
end

function Target:draw(radius)
   love.graphics.push("all")
   love.graphics.setColor(0, 1, 1, 1)
   love.graphics.setLineWidth(3)
   local minorRadii = { inner = radius, outer = radius * 1.2 }
   local majorRadii = { inner = radius * 0.4, outer = radius * 1.2 }
   Ray.drawSet(self.rayPosition, self.rayCount, majorRadii, minorRadii, "inner")
   love.graphics.pop()
end

function Target:_makeRandomTarget(maxNumRays)
   self.rayPosition = math.random(0, 11)
   self.rayCount = math.random(1, maxNumRays)
end

function Target:_makeHardTarget(playerRayPosition, playerRayCount, maxNumRays)
   local middle = math.max(1, maxNumRays / 2)
   if playerRayCount > middle then
      self.rayCount = math.random(1, math.floor(middle))
   else
      self.rayCount = math.random(math.ceil(middle), maxNumRays)
   end
   self.rayPosition = ((playerRayPosition + 6) + math.random(-2, 2)) % 12
end

return Target
