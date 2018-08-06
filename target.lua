GameState = require 'gamestate'
Ray = require 'ray'

Target = {
   NEXT_CONFIG_BUFFER = 4,
   _nextConfigIndex = 0,
   _lastConfigIndex = 0,
   _configurations = {},
}

function Target:reset()
   local defaultConfig = { rayPosition = 0, rayCount = 1 }
   self._nextConfigIndex = 1
   self._lastConfigIndex = 1
   self._configurations = {}
   self._configurations[self._lastConfigIndex] = self:_makeConfiguration(defaultConfig)
   repeat
      self:_pushNewConfig()
   until self._lastConfigIndex == self.NEXT_CONFIG_BUFFER
end

function Target:next()
   self:_pushNewConfig()
   self:_popConfig()
end

function Target:getConfiguration()
   return self._configurations[self._nextConfigIndex]
end

function Target:draw(radius)
   love.graphics.push("all")

   for index, configuration in pairs(self._configurations) do
      local majorRadii, minorRadii, pointerStyle
      if index == self._nextConfigIndex then
         love.graphics.setLineWidth(3)
         love.graphics.setColor(0, 1, 1, 1)
         minorRadii = { inner = radius, outer = radius * 1.2 }
         majorRadii = { inner = radius * 0.4, outer = radius * 1.2 }
         pointerStyle = "inner"
      else
         local orbit = (index - self._nextConfigIndex + 1)
         local maxOrbit = (self._lastConfigIndex - self._nextConfigIndex + 1)
         local ratio = orbit / maxOrbit
         local color = 0.7 * (1 - ratio)
         love.graphics.setColor(0, color, color, 1)
         love.graphics.setLineWidth(1)
         minorRadii = {
            inner = radius * orbit * 0.62,
            outer = radius * orbit * 0.82,
         }
         majorRadii = minorRadii
         pointerStyle = nil
         love.graphics.circle("line", 0, 0, minorRadii.outer)
      end
      Ray.drawSet(configuration.rayPosition, configuration.rayCount, majorRadii, minorRadii, pointerStyle)
   end
   love.graphics.pop()
end

function Target:_popConfig()
   self._configurations[self._nextConfigIndex] = nil
   self._nextConfigIndex = self._nextConfigIndex + 1
end

function Target:_pushNewConfig()
   local lastConfig = self._configurations[self._lastConfigIndex]
   local nextConfig = self:_makeConfiguration(lastConfig)
   self._lastConfigIndex = self._lastConfigIndex + 1
   self._configurations[self._lastConfigIndex] = nextConfig
end

function Target:_makeConfiguration(prevConfiguration)
   -- (linear: local maxNumRays = 1 + math.floor(GameState.numTurnsSucceeded / 4))
   local maxNumRays, pHardMove, isHardMove
   if (GameState.numTurnsSucceeded < 4) then
      maxNumRays = 1
      pHardMove = 0
   else
      maxNumRays = math.floor(math.log(GameState.numTurnsSucceeded / 2.5), 2) + 2
      pHardMove = 0.1 * maxNumRays
   end
   maxNumRays = math.min(6, maxNumRays)
   isHardMove = (math.random() < pHardMove)
   local nextConfiguration
   repeat
      if isHardMove then
         nextConfiguration = self:_makeHardTarget(prevConfiguration, maxNumRays)
      else
         nextConfiguration = self:_makeRandomTarget(maxNumRays)
      end
   until nextConfiguration.rayPosition ~= prevConfiguration.rayPosition
   
   return nextConfiguration
end

function Target:_makeRandomTarget(maxNumRays)
   return { rayPosition = math.random(0, 11), rayCount = math.random(1, maxNumRays) }
end

function Target:_makeHardTarget(prevConfiguration, maxNumRays)
   local middle = math.max(1, maxNumRays / 2)
   local rayCount, rayPosition
   if prevConfiguration.rayCount > middle then
      rayCount = math.random(1, math.floor(middle))
   else
      rayCount = math.random(math.ceil(middle), maxNumRays)
   end
   rayPosition = ((prevConfiguration.rayPosition + 6) + math.random(-2, 2)) % 12
   return { rayPosition = rayPosition, rayCount = rayCount }
end

return Target
