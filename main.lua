local Background = require 'background'
local Circloid = require 'circloid'
local HiScore = require 'hiscore'
local GameState = require 'gamestate'
local Player = require 'player'
local Target = require 'target'
local Particles = require 'particles'
local Ray = require 'ray'
local Timer = require 'timer'
local Menu = require 'menu'

function love.load()
   _loadFont()
   gDrawFuncs = {
      ["init"] = Menu.draw,
      ["game"] = _drawGame,
      ["end"] = Menu.draw,
   }
   HiScore:load()
   _resetGame()
end

function love.draw()
   Background:draw()
   local drawFunc = gDrawFuncs[GameState.state]
   drawFunc()
end

function love.keypressed(key, scancode, isrepeat)
   Background:keypressed(key)
   if key == "a" or key == "left" then
      Player:rotateCounter()
   elseif key == "d" or key == "right" then
      Player:rotateClockwise()
   elseif key == "w" or key == "up" then
      Player:addRay()
   elseif key == "s" or key == "down" then
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
   Circloid:update(dt)
   Player:update(dt)
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
         HiScore:maybeSave(GameState.score)
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
   Circloid:bumpScale()
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
   local bigFont = GameState.font[48]
   love.graphics.setFont(bigFont)
   love.graphics.translate(Circloid._cameraOffset.x, Circloid._cameraOffset.y)
   
   love.graphics.setColor(1, 1, 1, 1)
   local centerX = GameState.viewport.width * 0.5
   local centerY = GameState.viewport.height * 0.5
   local radius = Circloid:getRadius()
   local scoreStr = tostring(GameState.score)
   local scoreWidth = bigFont:getWidth(scoreStr)
   local toggleMode = Ray.TOGGLE.ALL
   local targetConfig = Target:getConfiguration()
   if Player.rayPosition == targetConfig.rayPosition then
      toggleMode = Ray.TOGGLE.ALL_BUT_POINTER
      if Player.rayCount == targetConfig.rayCount then
         toggleMode = Ray.TOGGLE.NONE
      end
   end
   
   love.graphics.push()
   love.graphics.translate(centerX, centerY)
   love.graphics.print(scoreStr, -scoreWidth * 0.5, -3 + (-bigFont:getHeight() * 0.5))
   love.graphics.scale(Circloid:getScale(), Circloid:getScale())
   Player:draw(radius)
   Target:draw(radius, toggleMode)
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
   GameState.font = {}
   for index, fontSize in pairs({ 16, 48 }) do
      GameState.font[fontSize] = love.graphics.newFont("x14y24pxHeadUpDaisy.ttf", fontSize)
   end
end
