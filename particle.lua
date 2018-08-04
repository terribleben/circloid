Ray = require 'ray'

Particle = {
   x = 0,
   y = 0,
   radius = 0,
   ttl = 0,
   lifespan = 0
}

function Particle:new(p)
   p = p or {}
   setmetatable(p, self)
   self.__index = self
   p.ttl = p.lifespan
   return p
end

function Particle:update(dt)
   self.ttl = self.ttl - dt
   if math.random() < 0.05 then
      self.x = self.x - 5 + math.random(0, 10)
      self.y = self.y - 5 + math.random(0, 10)
   end
end

function Particle:draw(dt)
   if self.ttl > 0 then
      love.graphics.setColor(0, 1, 0, (self.ttl / self.lifespan))
      love.graphics.circle("line", self.x, self.y, self.radius)
   end
end

-- bad particle

BadParticle = {
   x = 0,
   y = 0,
   radius = 0,
   ttl = 0,
   lifespan = 0,
}

function BadParticle:new(p)
   p = p or {}
   setmetatable(p, self)
   self.__index = self
   p.ttl = p.lifespan
   return p
end

function BadParticle:update(dt)
   self.ttl = self.ttl - dt
   if math.random() < 0.05 then
      self.x = self.x - 5 + math.random(0, 10)
      self.y = self.y - 5 + math.random(0, 10)
   end
end

function BadParticle:draw(dt)
   if self.ttl > 0 then
      love.graphics.setColor(1, 0, 0, 0.9 * (self.ttl / self.lifespan))
      love.graphics.circle("line", self.x, self.y, self.radius)
   end
end

-- small red particle

SmallRedParticle = {
   x = 0,
   y = 0,
   radius = 0,
   ttl = 0,
   lifespan = 0,
   velocity = { speed = 0, direction = 0 },
}

function SmallRedParticle:new(p)
   p = p or {}
   setmetatable(p, self)
   self.__index = self
   p.ttl = p.lifespan
   return p
end

function SmallRedParticle:update(dt)
   self.ttl = self.ttl - dt
   self.x = self.x + self.velocity.speed * math.cos(self.velocity.direction)
   self.y = self.y + self.velocity.speed * math.sin(self.velocity.direction)
   self.velocity.speed = self.velocity.speed * 0.96
end

function SmallRedParticle:draw(dt)
   if self.ttl > 0 then
      love.graphics.setColor(1, 0, 0, 0.9 * (self.ttl / self.lifespan))
      love.graphics.circle("line", self.x, self.y, self.radius)
   end
end

-- big smoke particle

BigSmokeParticle = {
   x = 0,
   y = 0,
   radius = 0,
   ttl = 0,
   lifespan = 0,
   spread = 1,
}

function BigSmokeParticle:new(p)
   p = p or {}
   setmetatable(p, self)
   self.__index = self
   p.ttl = p.lifespan
   return p
end

function BigSmokeParticle:update(dt)
   self.ttl = self.ttl - dt
   if math.random() < 0.1 then
      local angle = math.random() * math.pi * 2
      local delta = self.radius * (0.2 + math.random() * 0.8 *  self.spread)
      self.x = self.x + delta * math.cos(angle)
      self.y = self.y + delta * math.sin(angle)
      if math.random() < 0.5 then
         self.radius = self.radius * 0.7
      end
   end
end

function BigSmokeParticle:draw(dt)
   if self.ttl > 0 then
      love.graphics.setColor(0.85, 0.3, 0.3, 0.1);
      love.graphics.circle("fill", self.x, self.y, self.radius)
   end
end

-- small ray particle


SmallRayParticle = {
   radius = 0,
   x = 0,
   y = 0,
   position = 0,
   count = 0,
   ttl = 0,
   lifespan = 0,
}

function SmallRayParticle:new(p)
   p = p or {}
   setmetatable(p, self)
   self.__index = self
   p.ttl = p.lifespan
   return p
end

function SmallRayParticle:update(dt)
   self.ttl = self.ttl - dt
end

function SmallRayParticle:draw(dt)
   if self.ttl > 0 then
      love.graphics.setColor(1, 1, 1, 0.5 * (self.ttl / self.lifespan))
      love.graphics.push()
      love.graphics.translate(self.x, self.y)
      local radius = self.radius
      local minorRadii = { inner = radius * 1.2, outer = radius * 1.5 }
      Ray.drawSet(self.position, self.count, minorRadii, minorRadii, nil);
      love.graphics.pop()
   end
end

-- big ray particle


BigRayParticle = {
   radius = 0,
   x = 0,
   y = 0,
   position = 0,
   count = 0,
   ttl = 0,
   lifespan = 0,
}

function BigRayParticle:new(p)
   p = p or {}
   setmetatable(p, self)
   self.__index = self
   p.ttl = p.lifespan
   return p
end

function BigRayParticle:update(dt)
   self.ttl = self.ttl - dt
end

function BigRayParticle:draw(dt)
   if self.ttl > 0 then
      love.graphics.setColor(1, 1, 1, 0.6 * (self.ttl / self.lifespan))
      love.graphics.push()
      love.graphics.translate(self.x, self.y)
      local radius = self.radius
      local minorRadii = { inner = radius, outer = radius * 4 }
      Ray.drawSet(self.position, self.count, minorRadii, minorRadii, nil, 40 - (self.ttl / self.lifespan) * 36)
      love.graphics.pop()
   end
end

return function()
   return Particle, BadParticle, BigSmokeParticle, SmallRayParticle, BigRayParticle, SmallRedParticle
end
