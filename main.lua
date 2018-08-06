Background = require 'background'
GameState = require 'gamestate'
Player = require 'player'
Target = require 'target'
Particles = require 'particles'
Timer = require 'timer'
Menu = require 'menu'

Circloid = {
   _radiusToDraw = 0,
   _cameraOffset = { x = 0, y = 0 },
   _cameraVelocity = { x = 0, y = 0 },
   _scale = 1,
}

function love.load()
   _loadFont()
   gDrawFuncs = {
      ["init"] = Menu.draw,
      ["game"] = _drawGame,
      ["end"] = Menu.draw,
   }
   _resetGame()
end

function love.draw()
   Background:draw()
   local drawFunc = gDrawFuncs[GameState.state]
   drawFunc()
end

function love.keypressed(key, scancode, isrepeat)
   Background:keypressed(key)
   if key == "a" then
      Player:rotateCounter()
   elseif key == "d" then
      Player:rotateClockwise()
   elseif key == "w" then
      Player:addRay()
   elseif key == "s" then
      Player:subtractRay()
   end

   if GameState.state ~= "game" then
      Menu:keypressed(key)
      if Menu:isReady() then
         Particles:greenBurst()
         Particles:playerMatched(Player.rayPosition, Player.rayCount)
         _restartGame()
      end
   else
      local target = Target:getConfiguration()
      if Player.rayPosition == target.rayPosition
      and Player.rayCount == target.rayCount then
         _turnSucceeded()
      end
   end
end

function love.update(dt)
   Background:update(dt)
   Particles:update(dt)
   if Circloid._scale ~= 1 then
      Circloid._scale = Circloid._scale + (1 - Circloid._scale) * 0.25
      if math.abs(1 - Circloid._scale) < 0.01 then
         Circloid._scale = 1
      end
   end
   Circloid:update(dt)
   if GameState.state == "game" then
      if GameState.vitality < 2 then
         Particles:maybeDanger()
      end
      Timer:update(dt)
      if Timer:isExpired() then
         _turnFailed()
      end
   end
end

function _turnFailed()
   -- remove vitality
   -- check game over
   Timer:turnFailed()
   GameState:turnFailed()
   Particles:redBurst()
   Circloid:shakeCamera()
   if GameState.vitality <= 0 then
      if GameState.state ~= "end" then
         GameState.state = "end"
      end
      _resetGame()
   elseif GameState.vitality <= 1 then
      Background:setMessage("CRITICAL", { isPersistent = true, ttl = 5 })
   elseif GameState.vitality <= 2 then
      Background:setMessage("DANGER", { isPersistent = true, ttl = 5 })
   else
      Background:setMessage("INTERFERENCE")
   end
end

function _turnSucceeded()
   Timer:turnSucceeded()
   GameState:turnSucceeded()
   Target:next()
   Circloid._scale = 1.1
   Particles:greenBurst()
   Particles:playerMatched(Player.rayPosition, Player.rayCount)
   if GameState.vitality == GameState.MAX_VITALITY then
      Background:setMessage("MAXIMUM VITALITY")
   else
      Background:randomMessage()
   end
end

function _drawGame()
   love.graphics.push()
   love.graphics.translate(Circloid._cameraOffset.x, Circloid._cameraOffset.y)
   
   love.graphics.setColor(1, 1, 1, 1)
   local centerX = GameState.viewport.width * 0.5
   local centerY = GameState.viewport.height * 0.5
   local radius = Circloid._radiusToDraw
   local scoreStr = tostring(GameState.score)
   local scoreWidth = GameState.font:getWidth(scoreStr)
   
   love.graphics.push()
   love.graphics.translate(centerX, centerY)
   love.graphics.print(scoreStr, -scoreWidth * 0.5, -GameState.font:getHeight() * 0.5)
   love.graphics.scale(Circloid._scale, Circloid._scale)
   Player:draw(radius)
   Target:draw(radius)
   Timer:draw(radius)
   love.graphics.pop()

   love.graphics.setBlendMode("add")
   Particles:draw()
   love.graphics.setBlendMode("alpha")
   love.graphics.pop()
end

function _resetGame()
   Menu:reset()
   Player:reset()
   Target:reset()
   GameState:reset()
   Timer:reset()
   Circloid:reset()
end

function _restartGame()
   Background:setMessage("BEGIN", { isPersistent = true, ttl = 2 })
   GameState.state = "game"
end

function _loadFont()
   GameState.font = love.graphics.newFont("x14y24pxHeadUpDaisy.ttf") -- can't get size to work
   love.graphics.setFont(GameState.font)
end

function Circloid:reset()
   self._radiusToDraw = GameState:getRadius()
   self._scale = 1
end

function Circloid:shakeCamera()
   local radius = 12
   local angle = math.random() * math.pi * 2
   self._cameraOffset.x = radius * math.cos(angle)
   self._cameraOffset.y = radius * math.cos(angle)
end

function Circloid:update(dt)
   self._radiusToDraw = self._radiusToDraw + (GameState:getRadius() - self._radiusToDraw) * 0.25
   self._cameraVelocity.x = self._cameraVelocity.x + (self._cameraOffset.x * -0.91)
   self._cameraVelocity.y = self._cameraVelocity.y + (self._cameraOffset.y * -0.91)
   self._cameraOffset.x = 0.88 * (self._cameraOffset.x + self._cameraVelocity.x)
   self._cameraOffset.y = 0.88 * (self._cameraOffset.y + self._cameraVelocity.y)
end
