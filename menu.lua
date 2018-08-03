GameState = require 'gamestate'
Player = require 'player'

Menu = {}

function Menu:draw()
   love.graphics.setColor(1, 1, 1, 1)
   local centerX = GameState.viewport.width * 0.5
   local centerY = GameState.viewport.height * 0.5
   local radius = GameState:getRadius()
   
   love.graphics.push()
   love.graphics.translate(centerX, centerY)
   love.graphics.circle("line", 0, 0, radius)
   Player:draw(radius)

   -- draw fake target for start
   love.graphics.setColor(0, 1, 1, 1)
   love.graphics.line(-radius * 1.2, 0, -radius * 0.4, 0)

   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.print("WASD", -16, -7)
   love.graphics.print("start", -((radius * 1.2) + 34), -7)
   love.graphics.pop()
   
   Particles:draw()
end

function Menu:isReady()
   -- "start" configuration
   return (Player.rayPosition == 6 and Player.rayCount == 1)
end

return Menu
