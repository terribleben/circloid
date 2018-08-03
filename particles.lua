Particle = require 'particle'

Particles = {
   _particles = {},
   _nextParticleIndex = 1
}

function Particles:add(count, proto)
   proto = proto or Particle:new()
   for index = 0, count - 1 do
      self._particles[self._nextParticleIndex] = Particle:new({
            x = proto.x - 16 + math.random(0, 32),
            y = proto.y - 16 + math.random(0, 32),
            radius = proto.radius * (0.92 + math.random() * 0.16),
            lifespan = proto.lifespan * (0.92 + math.random() * 0.16),
      })
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

return Particles
