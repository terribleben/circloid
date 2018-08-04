Ray = {}

function Ray.drawSet(position, count, majorRadii, minorRadii, pointerStyle, width)
   local initialAngle = ((math.pi * 2) / 12) * position
   local incrementalAngle = ((math.pi * 2) / count)
   love.graphics.push()
   love.graphics.rotate(initialAngle)
   for idx = 0, count - 1 do
      local radii
      if idx == 0 then
         radii = majorRadii
         if pointerStyle == "outer" then
            Ray._drawOuterPointer(radii.outer)
         elseif pointerStyle == "inner" then
            Ray._drawInnerPointer(radii.inner)
         end
      else
         radii = minorRadii
      end
      if width ~= nil and width > 1 then
         love.graphics.rectangle("fill", radii.inner, width * -0.5, radii.outer - radii.inner, width)
      else
         love.graphics.line(radii.inner, 0, radii.outer, 0)
      end
      love.graphics.rotate(incrementalAngle)
   end
   love.graphics.pop()
end

function Ray._drawOuterPointer(radius)
   local vertices = {
      radius, -8,
      radius, 8,
      radius + 8, 0,
   }
   love.graphics.polygon("line", vertices)
end

function Ray._drawInnerPointer(radius)
   local vertices = {
      radius, 8,
      radius, -8,
      radius - 8, 0,
   }
   love.graphics.polygon("line", vertices)
end

return Ray
