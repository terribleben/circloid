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

-- red particle

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

return function()
   return Particle, BadParticle, BigSmokeParticle
end
