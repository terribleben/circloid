Timer = {
   _timeRemaining = 0,
   MAX_TIME_REMAINING = 12,
}

function Timer:reset()
   self._timeRemaining = self.MAX_TIME_REMAINING
end

function Timer:addTime()
   self._timeRemaining = self._timeRemaining + (self.MAX_TIME_REMAINING * 0.1)
   if self._timeRemaining > self.MAX_TIME_REMAINING then
      self._timeRemaining = self.MAX_TIME_REMAINING
   end
end

function Timer:update(dt)
   self._timeRemaining = self._timeRemaining - dt
   if self._timeRemaining < 0 then
      self._timeRemaining = 0
   end
end

function Timer:isExpired()
   return (self._timeRemaining <= 0)
end

function Timer:draw(viewport)
   viewport = viewport or { width = 0, height = 0 }

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
