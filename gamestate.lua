GameState = {
   vitality = 0,
   score = 0,
   state = "init",
   viewport = { width = 0, height = 0 },
   numTurns = 0,
   numTurnsSucceeded = 0,

   _screenRadius = 0,
   
   DEFAULT_VITALITY = 3,
   MAX_VITALITY = 6,
}

function GameState:reset()
   self.score = 0
   self.numTurns = 0
   self.numTurnsSucceeded = 0
   self.vitality = self.DEFAULT_VITALITY
   local width, height, flags = love.window.getMode()
   self.viewport.width = width
   self.viewport.height = height
   self._screenRadius = math.min(width, height)
end

function GameState:turnSucceeded()
   self.numTurns = self.numTurns + 1
   self.numTurnsSucceeded = self.numTurnsSucceeded + 1
   self.score = self.score + 1
   self.vitality = self.vitality + 0.2
   if self.vitality > self.MAX_VITALITY then
      self.vitality = self.MAX_VITALITY
   end
end

function GameState:turnFailed()
   self.numTurns = self.numTurns + 1
   
   -- allow people to hang on at near-death
   if self.vitality < 2 and self.vitality > 1 then
      self.vitality = 1
   else
      self.vitality = self.vitality - 1
   end

   if self.vitality <= 0 then
      self.vitality = 0
   end
end

function GameState:getRadius()
   local scale = 0.15 + (0.18 * (self.vitality / self.MAX_VITALITY))
   return self._screenRadius * scale
end

return GameState
