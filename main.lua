Background = require 'background'
HiScore = require 'hiscore'
GameState = require 'gamestate'
Player = require 'player'
Target = require 'target'
Particles = require 'particles'
Timer = require 'timer'
Menu = require 'menu'
require 'TESound'

Circloid = {
   _radiusToDraw = 0,
   _cameraOffset = { x = 0, y = 0 },
   _cameraVelocity = { x = 0, y = 0 },
   _scale = 1,
}

function love.load()
  -- below 2 lines don't work. soundData loading is bugged?
  --snd_on_game_loaded = love.sound.newSoundData("on_game_loaded.mp3")
  --snd_title_screen_loop = love.sound.newSoundData("title_screen_loop.mp3")

  -- can use below sources directly if needed, but TESound doesn't allow it
  --snd_on_game_loaded = love.audio.newSource("on_game_loaded.mp3", "static")
  --snd_title_screen_loop = love.audio.newSource("title_screen_loop.mp3", "static")
  --snd_on_game_start = love.audio.newSource("on_game_start.mp3", "static")
  --snd_main_loop = love.audio.newSource("main_loop.mp3", "stream")

  --TEsound.stop("on_game_loaded")

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
   if key == "a" then
      Player:rotateCounter()
      TEsound.play("move.mp3", "static")
   elseif key == "d" then
      Player:rotateClockwise()
      TEsound.play("move.mp3", "static")
   elseif key == "w" then
      Player:addRay()
      TEsound.play("size_up.mp3", "static")
   elseif key == "s" then
      Player:subtractRay()
      TEsound.play("size_down.mp3", "static")
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
   TEsound.cleanup()
end

function _turnFailed()
   -- remove vitality
   -- check game over
   Timer:turnFailed()
   GameState:turnFailed()
   Particles:redBurst()
   Circloid:shakeCamera()
   TEsound.play("take_damage.mp3", "static")
   if GameState.vitality <= 0 then
      if GameState.state ~= "end" then
         GameState.state = "end"
         HiScore:maybeSave(GameState.score)
      end
      TEsound.play("game_over.mp3", "static")
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
   TEsound.play("zap.mp3", "static")
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
   local radius = Circloid._radiusToDraw
   local scoreStr = tostring(GameState.score)
   local scoreWidth = bigFont:getWidth(scoreStr)

   love.graphics.push()
   love.graphics.translate(centerX, centerY)
   love.graphics.print(scoreStr, -scoreWidth * 0.5, -bigFont:getHeight() * 0.5)
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

   TEsound.stop("on_game_start")
   TEsound.stop("main_loop")
   TEsound.play("on_game_loaded.mp3", "static", "on_game_loaded", 1, 1,
     function(d)
       TEsound.playLooping("title_screen_loop.mp3", "static", "title_screen_loop")
     end
   )
end

function _restartGame()
   Background:setMessage("BEGIN", { isPersistent = true, ttl = 2 })
   GameState.state = "game"
   TEsound.stop("on_game_loaded")
   TEsound.stop("title_screen_loop")
   TEsound.play("on_game_start.mp3", "static", "on_game_start", 1, 1,
     function(d)
       TEsound.playLooping("main_loop.mp3", "stream", "main_loop")
     end
   )
end

function _loadFont()
   GameState.font = {}
   for index, fontSize in pairs({ 16, 48 }) do
      GameState.font[fontSize] = love.graphics.newFont("x14y24pxHeadUpDaisy.ttf", fontSize)
   end
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
