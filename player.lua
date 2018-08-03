Player = {
   centerX = 0,
   centerY = 0,
   rayPosition = 0,
   rayCount = 0,
}

function Player:reset()
   self.rayPosition = 0
   self.rayCount = 1
end

function Player:draw(maxRadius)
   love.graphics.setColor(1, 1, 1, 1)
   for idx = 0, self.rayCount - 1 do
      local initialAngle = ((math.pi * 2) / self.rayCount) * idx
      self:_drawRay(maxRadius, initialAngle)
   end
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
   if self.rayCount > 5 then
      self.rayCount = 5
   end
end

function Player:subtractRay()
   self.rayCount = self.rayCount - 1
   if self.rayCount < 1 then
      self.rayCount = 1
   end
end

function Player:_drawRay(maxRadius, initialAngle)
   local innerRadius, outerRadius
   innerRadius = maxRadius * 0.2
   outerRadius = maxRadius * 0.4
   if initialAngle ~= 0 then
      innerRadius = maxRadius * 0.3
   end
   local angle = initialAngle + (((math.pi * 2) / 12) * self.rayPosition)
   love.graphics.line(
      self.centerX + innerRadius * math.cos(angle),
      self.centerY + innerRadius * math.sin(angle),
      self.centerX + outerRadius * math.cos(angle),
      self.centerY + outerRadius * math.sin(angle)
   )
end

return Player
