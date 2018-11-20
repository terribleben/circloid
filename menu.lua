local GameState = require 'gamestate'
local Player = require 'player'
local Particles = require 'particles'
local Background = require 'background'
local HiScore = require 'hiscore'

local Menu = {
   _state = "init",
   _targetLabel = "",
   _centerLabel = "",
   _rayPosition = 0,
   _rayCount = 1,
   _hiscore = 0,
}

function Menu:reset()
   if GameState.state == "init" then
      self._state = "init"
      self._targetLabel = "ready?"
      self._centerLabel = "CIRCLOID"
      self._rayPosition = 7
      self._rayCount = 3
   else
      self._centerLabel = "GAME OVER"
      self:_setReadyState(true)
   end
   self._hiscore = HiScore:get()
end

function Menu:draw()
   love.graphics.setColor(1, 1, 1, 1)
   local smallFont, bigFont = GameState.font[16], GameState.font[48]
   love.graphics.setFont(smallFont)
   local centerX = GameState.viewport.width * 0.5
   local centerY = GameState.viewport.height * 0.5
   local radius = GameState:getRadius()
   
   love.graphics.push()
   love.graphics.translate(centerX, centerY)
   Player:draw(radius)

   Menu._drawRays(Menu, radius)

   love.graphics.setColor(1, 1, 1, 1)
   local labelWidth = smallFont:getWidth(Menu._centerLabel)
   love.graphics.print(Menu._centerLabel, labelWidth * -0.5, smallFont:getHeight() * -0.5)
   love.graphics.rotate(((math.pi * 2) / 12) * Menu._rayPosition)
   love.graphics.print(Menu._targetLabel, (radius * 1.2) + 7, smallFont:getHeight() * -0.5)
   love.graphics.pop()

   if Menu._hiscore then
      local hiscoreText = "HI SCORE " .. tostring(Menu._hiscore)
      love.graphics.print(
         hiscoreText,
         GameState.viewport.width - 10 - smallFont:getWidth(hiscoreText),
         GameState.viewport.height - 10 - smallFont:getHeight()
      )
   end

   if Menu._state == "init" then
      love.graphics.setFont(bigFont)
      local instructions
      if Player.rayPosition == Menu._rayPosition then
         instructions = "up/down to match"
      else
         instructions = "left/right to rotate"
      end
      love.graphics.print(
         instructions,
         GameState.viewport.width * 0.5 - bigFont:getWidth(instructions) * 0.5,
         GameState.viewport.height - 32 - bigFont:getHeight()
      )
   end
   
   Particles:draw()
end

function Menu:keypressed(key)
   -- check if in 'ready' -> go to start
   if self._state == "init" and self:_isPlayerMatched() then
      self:_setReadyState(false)
      Particles:greenBurst()
      Particles:playerMatched(Player.rayPosition, Player.rayCount)
   end
end

function Menu:_drawRays(radius)
   love.graphics.push("all")
   love.graphics.setLineWidth(3)
   love.graphics.setColor(0, 1, 1, 1)
   local minorRadii = { inner = radius * 0.75, outer = radius - 16 }
   local majorRadii = { inner = radius * 0.4, outer = radius + 16 }
   local toggleMode = Ray.TOGGLE.ALL
   if Player.rayPosition == self._rayPosition then
      toggleMode = Ray.TOGGLE.ALL_BUT_POINTER
      if Player.rayCount == self._rayCount then
         toggleMode = Ray.TOGGLE.NONE
      end
   end
   Ray.drawSet(self._rayPosition, self._rayCount, majorRadii, minorRadii, "outer", nil, toggleMode)
   love.graphics.pop()
end

function Menu:isReady()
   return (self._state == "ready" and self:_isPlayerMatched())
end

function Menu:_setReadyState(isGameOver)
   Background:setMessage("READY", { isPersistent = true, ttl = 1 })
   self._state = "ready"
   self._targetLabel = "start"
   self._rayCount = 1
   if isGameOver then
      self._rayPosition = (Player.rayPosition + 6) % 12
   else
      self._rayPosition = 0
   end
end

function Menu:_isPlayerMatched()
   return (Player.rayPosition == self._rayPosition and Player.rayCount == self._rayCount)
end

return Menu
