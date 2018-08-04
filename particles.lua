Particle, BadParticle, BigSmokeParticle, SmallRayParticle, BigRayParticle = require 'particle' ()
GameState = require 'gamestate'

Particles = {
   _particles = {},
   _nextParticleIndex = 1
}

function Particles:addRandom(count, Kind, proto)
   proto = proto or Kind:new()
   for index = 0, count - 1 do
      self._particles[self._nextParticleIndex] = Kind:new({
            x = proto.x - 16 + math.random(0, 32),
            y = proto.y - 16 + math.random(0, 32),
            radius = proto.radius * (0.92 + math.random() * 0.16),
            lifespan = proto.lifespan * (0.92 + math.random() * 0.16),
      })
      self._nextParticleIndex = self._nextParticleIndex + 1
   end
end

function Particles:add(count, Kind, proto)
   proto = proto or Kind:new()
   for index = 0, count - 1 do
      self._particles[self._nextParticleIndex] = Kind:new(proto)
      self._nextParticleIndex = self._nextParticleIndex + 1
   end
end

function Particles:draw()
   for index, particle in pairs(self._particles) do
      particle:draw()
   end
end

function Particles:update(dt)
   for index, particle in pairs(self._particles) do
      particle:update(dt)
      if particle.ttl <= 0 then
         self._particles[index] = nil
      end
   end
end

-- specific game actions

function Particles:greenBurst()
   local proto = {
      x = GameState.viewport.width * 0.5,
      y = GameState.viewport.height * 0.5,
      radius = GameState:getRadius(),
      lifespan = 0.6
   }
   self:addRandom(3, Particle, proto)
end

function Particles:redBurst()
   local proto = {
      x = GameState.viewport.width * 0.5,
      y = GameState.viewport.height * 0.5,
      radius = GameState:getRadius(),
      lifespan = 0.6
   }
   self:addRandom(5, BigSmokeParticle, proto)
   self:addRandom(3, BadParticle, proto)
end

function Particles:playerMoved(rayPosition, rayCount)
   local proto = {
      x = GameState.viewport.width * 0.5,
      y = GameState.viewport.height * 0.5,
      radius = GameState:getRadius(),
      lifespan = 1,
      position = rayPosition,
      count = rayCount,
   }
   self:add(1, SmallRayParticle, proto)
end

function Particles:playerMatched(rayPosition, rayCount)
   local proto = {
      x = GameState.viewport.width * 0.5,
      y = GameState.viewport.height * 0.5,
      radius = GameState:getRadius(),
      lifespan = 0.3,
      position = rayPosition,
      count = rayCount,
   }
   self:add(1, BigRayParticle, proto)
end

function Particles:maybeDanger()
   if math.random() < 0.1 then
      local proto = {
         x = GameState.viewport.width * 0.5,
         y = GameState.viewport.height * 0.5,
         radius = GameState:getRadius(),
         lifespan = 0.4,
         spread = 0.5,
      }
      self:addRandom(1, BigSmokeParticle, proto)
   end
end

return Particles
