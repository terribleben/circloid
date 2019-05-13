local HiScore = {
   _score = 0,
}

local HISCORE_STORAGE_KEY = 'hiscore'

function HiScore:load()
   network.async(function()
         local hiScore = castle.storage.get(HISCORE_STORAGE_KEY)
         if not hiScore == nil then
            self._score = hiScore
         end
   end)
end

function HiScore:get()
   return self._score
end

function HiScore:maybeSave(score)
   if self._score == nil or score > self._score then
      network.async(function()
            castle.storage.set(HISCORE_STORAGE_KEY, score)
            self._score = score
      end)
   end
end

return HiScore
