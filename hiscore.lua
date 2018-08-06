HiScore = {
   _score = 0,
}

function HiScore:load()
   local hiScore = 0
   local scoresFile = self:getFilePathAndCreateDirectory()
   info = love.filesystem.getInfo(scoresFile)
   if info == nil then
      -- print("no hiscore file exists")
   else
      -- print("scores file exists", info.type)
      local contents, size = love.filesystem.read(scoresFile)
      if size > 0 then
         -- print("file contents:", contents)
         hiScore = tonumber(contents)
         -- print("parsed hi score:", hiScore)
      else
         -- print("unable to read file")
      end
   end
   self._score = hiScore
end

function HiScore:get()
   return self._score
end

function HiScore:maybeSave(score)
   if self._score == nil or score > self._score then
      local scoresFile = self:getFilePathAndCreateDirectory()
      local success, message = love.filesystem.write(scoresFile, tostring(score))
      if success then
         -- print("wrote scores file")
         self._score = score
      else
         print("unable to write scores file:", message)
      end
   end
end

function HiScore:getFilePathAndCreateDirectory()
   local saveDirectory = love.filesystem.getSaveDirectory()
   local scoresDirectory = saveDirectory .. "/circloid/scores"
   local info = love.filesystem.getInfo(scoresDirectory)
   -- print("scores directory path is", scoresDirectory)
   if info == nil then
      -- print("path does not exist, creating")
      local success = love.filesystem.createDirectory(scoresDirectory)
      if success == false then
         print("unable to create scores save path")
      end
   end
   local scoresFilePath = scoresDirectory .. "/hiscore.dat"
   return scoresFilePath
end

return HiScore
