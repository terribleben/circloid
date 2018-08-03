Target = {
   centerX = 0,
   centerY = 0,
   rayPosition = 0,
   rayCount = 0,
}

function Target:reset()
   self.rayPosition = 0
   self.rayCount = 1
end

function Target:draw(radius)
   love.graphics.setColor(0, 1, 1, 1)
   for idx = 0, self.rayCount - 1 do
      local initialAngle = ((math.pi * 2) / self.rayCount) * idx
      self:_drawRay(radius, initialAngle)
   end
end

function Target:_drawRay(radius, initialAngle)
   local innerRadius, outerRadius
   innerRadius = radius * 0.4
   outerRadius = radius * 1.2
   if initialAngle ~= 0 then
      innerRadius = radius
   end
   local angle = initialAngle + (((math.pi * 2) / 12) * self.rayPosition)
   love.graphics.line(
      self.centerX + innerRadius * math.cos(angle),
      self.centerY + innerRadius * math.sin(angle),
      self.centerX + outerRadius * math.cos(angle),
      self.centerY + outerRadius * math.sin(angle)
   )
end

return Target
