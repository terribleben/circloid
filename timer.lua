GameState = require 'gamestate'

Timer = {
   _timeRemaining = 0,
   _timeScale = 1,

   MAX_TIME_REMAINING = 4,
}

function Timer:reset()
   self._timeRemaining = self.MAX_TIME_REMAINING
   self._timeScale = 1
end

function Timer:turnSucceeded()
   self._timeRemaining = self.MAX_TIME_REMAINING
   self._timeScale = 1 + (0.0275 * GameState.numTurnsSucceeded)
end

function Timer:turnFailed()
   self._timeRemaining = self.MAX_TIME_REMAINING
end

function Timer:update(dt)
   self._timeRemaining = self._timeRemaining - (dt * self._timeScale)
   if self._timeRemaining < 0 then
      self._timeRemaining = 0
   end
end

function Timer:isExpired()
   return (self._timeRemaining <= 0)
end

function Timer:draw(radius)
   local maxRadius = radius * 0.95

   local maxNumUnits = 7
   local numUnits = math.ceil((1 - (self._timeRemaining / self.MAX_TIME_REMAINING)) * maxNumUnits)

   love.graphics.setColor(1, 1, 1, 0.5)

   local radiusIncrement = maxRadius / (maxNumUnits + 1)
   for index = numUnits, 1, -1 do
      love.graphics.circle("line", 0, 0, maxRadius - (radiusIncrement * index))
   end
end

-- unused
function Timer:drawSimple()
   local viewport = GameState.viewport or { width = 0, height = 0 }

   local maxNumUnits = 20
   local numUnits = math.ceil((self._timeRemaining / self.MAX_TIME_REMAINING) * maxNumUnits)

   if numUnits > maxNumUnits / 3 then
      love.graphics.setColor(1, 1, 1, 1)
   else
      love.graphics.setColor(1, 0, 0, 1)
   end
   
   local padding = 10
   local unitSpacing = (viewport.width - padding - padding) / maxNumUnits
   local unitWidth = unitSpacing - padding
   for index = 0, numUnits - 1 do
      local x = index * unitSpacing
      love.graphics.rectangle(
         "line",
         padding + x, viewport.height - 50,
         unitWidth, 30
      )
   end
end

return Timer
