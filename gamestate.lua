GameState = {
   vitality = 0,
   score = 0,
   state = "init",
   viewport = { width = 0, height = 0 },

   _screenRadius = 0,
   
   DEFAULT_VITALITY = 3,
   MAX_VITALITY = 6,
}

function GameState:reset()
   self.score = 0
   self.vitality = self.DEFAULT_VITALITY
   local width, height, flags = love.window.getMode()
   self.viewport.width = width
   self.viewport.height = height
   self._screenRadius = math.min(width, height)
end

function GameState:turnSucceeded()
   self.score = self.score + 1
   self.vitality = self.vitality + 0.25
   if self.vitality > self.MAX_VITALITY then
      self.vitality = self.MAX_VITALITY
   end
end

function GameState:turnFailed()
   -- TODO: not sure if I want to keep this logic
   if math.floor(self.vitality) == self.vitality then
      self.vitality = self.vitality - 1
   else
      self.vitality = math.floor(self.vitality)
   end

   if self.vitality <= 0 then
      self.vitality = 0
      if self.state ~= "end" then
         self.state = "end"
      end
   end
end

function GameState:getRadius()
   -- default: 0.25, max: 0.35, min: 0.15
   local scale = 0.15 + (0.2 * (self.vitality / self.MAX_VITALITY))
   return self._screenRadius * scale
end

return GameState
