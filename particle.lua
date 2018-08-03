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

return Particle
