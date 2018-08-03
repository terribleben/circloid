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

function Player:draw(radius)
   love.graphics.setColor(1, 1, 1, 1)
   for idx = 0, self.rayCount - 1 do
      local initialAngle = ((math.pi * 2) / self.rayCount) * idx
      self:_drawRay(radius, initialAngle)
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

function Player:_drawRay(radius, initialAngle)
   local innerRadius, outerRadius
   innerRadius = radius * 0.8
   outerRadius = radius * 1.6
   if initialAngle ~= 0 then
      innerRadius = radius * 1.2
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
