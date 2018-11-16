local GameState = require 'gamestate'

local Circloid = {
   _radiusToDraw = 0,
   _cameraOffset = { x = 0, y = 0 },
   _cameraVelocity = { x = 0, y = 0 },
   _scale = 1,
   _toggle = false,
   _toggleTimer = 0.2,
   _TOGGLE_MAX_TIME = 0.2,
}

function Circloid:reset()
   self._radiusToDraw = GameState:getRadius()
   self._scale = 1
end

function Circloid:getRadius()
   return self._radiusToDraw
end

function Circloid:getScale()
   return self._scale
end

function Circloid:getToggle()
   return self._toggle
end

function Circloid:bumpScale()
   self._scale = 1.1
end

function Circloid:shakeCamera()
   local radius = 12
   local angle = math.random() * math.pi * 2
   self._cameraOffset.x = radius * math.cos(angle)
   self._cameraOffset.y = radius * math.cos(angle)
end

function Circloid:update(dt)
   if self._scale ~= 1 then
      self._scale = self._scale + (1 - self._scale) * 0.25
      if math.abs(1 - self._scale) < 0.01 then
         self._scale = 1
      end
   end
   self._toggleTimer = self._toggleTimer - dt
   if self._toggleTimer <= 0 then
      self._toggleTimer = self._TOGGLE_MAX_TIME
      self._toggle = not self._toggle
   end
   self._radiusToDraw = self._radiusToDraw + (GameState:getRadius() - self._radiusToDraw) * 0.25
   self._cameraVelocity.x = self._cameraVelocity.x + (self._cameraOffset.x * -0.91)
   self._cameraVelocity.y = self._cameraVelocity.y + (self._cameraOffset.y * -0.91)
   self._cameraOffset.x = 0.88 * (self._cameraOffset.x + self._cameraVelocity.x)
   self._cameraOffset.y = 0.88 * (self._cameraOffset.y + self._cameraVelocity.y)
end


return Circloid
