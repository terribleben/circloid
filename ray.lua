local Circloid = require 'circloid'

local Ray = {
   TOGGLE = {
      NONE = 0,
      ALL = 1,
      ALL_BUT_POINTER = 2,
   },
}

function Ray.drawSet(position, count, majorRadii, minorRadii, pointerStyle, width, toggle)
   local isToggle = Circloid:getToggle()
   local initialAngle = ((math.pi * 2) / 12) * position
   local incrementalAngle = ((math.pi * 2) / count)
   love.graphics.push()
   love.graphics.rotate(initialAngle)
   for idx = 0, count - 1 do
      local radii
      if idx == 0 then
         radii = majorRadii
         if isToggle and toggle == Ray.TOGGLE.ALL then
            love.graphics.setColor(1, 0, 0, 1)
         end
         if pointerStyle == "outer" then
            Ray._drawOuterPointer(radii.outer)
         elseif pointerStyle == "inner" then
            Ray._drawInnerPointer(radii.inner)
         end
      else
         radii = minorRadii
         if isToggle and toggle ~= Ray.TOGGLE.NONE then
            love.graphics.setColor(1, 0, 0, 1)
         end
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
      radius, -12,
      radius, 12,
      radius + 12, 0,
   }
   love.graphics.polygon("line", vertices)
   --love.graphics.arc("line", radius + 8, 0, 8, math.pi * 0.5, math.pi * 1.5, 10)
   --love.graphics.circle("line", radius + 16, 0, 16, 10)
end

function Ray._drawInnerPointer(radius)
   local vertices = {
      radius, 12,
      radius, -12,
      radius - 12, 0,
   }
   love.graphics.polygon("line", vertices)
   --love.graphics.circle("line", radius - 16, 0, 16, 10)
end

return Ray
