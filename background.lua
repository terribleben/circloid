Messages = require 'messages'

Background = {
   _scrollIndex = 0,
   _scrollIndexTarget = 0,
   _scrollIndexVelocity = 0,
   _message = "",
   _isMessagePersistent = false,
   _messageTTL = 0,
   
   _messageVariants = { "", "", "", "" }
}

function Background:keypressed(key)
   if key == "a" then
      self._scrollIndexTarget = self._scrollIndexTarget - 1
   elseif key == "d" then
      self._scrollIndexTarget = self._scrollIndexTarget + 1
   end
end

function Background:update(dt)
   self._scrollIndexVelocity = (self._scrollIndexTarget - self._scrollIndex) * 0.11
   self._scrollIndex = self._scrollIndex + self._scrollIndexVelocity
   local pFlicker
   if math.abs(self._scrollIndexVelocity) < 0.01 then
      pFlicker = 0.01
   else
      pFlicker = 0.1
   end
   if self._message ~= nil then
      for i = 1, 4 do
         if self._messageVariants[i] == self._message and math.random() < pFlicker then
            self._messageVariants[i] = ""
         elseif self._messageVariants[i] ~= self._message and math.random() < pFlicker * 2 then
            self._messageVariants[i] = self._message
         end
      end
   end
   if self._isMessagePersistent and self._messageTTL > 0 then
      self._messageTTL = self._messageTTL - dt
      if self._messageTTL <= 0 then
         self._messageTTL = 0
         self._isMessagePersistent = false
      end
   end
end

function Background:setMessage(message, options)
   options = options or {}
   setmetatable(options, { __index = { isImportant = true, isPersistent = false, ttl = 0, } })

   if self._isMessagePersistent and options.isPersistent == false then
      return
   end
   if options.isPersistent then
      self._isMessagePersistent = true
      self._messageTTL = options.ttl
   end
   
   self._message = message
   if options.isImportant then
      for index = 1, 4 do
         self._messageVariants[index] = message
      end
      if math.random() < 0.5 then
         self._scrollIndexTarget = self._scrollIndexTarget + 15
      else
         self._scrollIndexTarget = self._scrollIndexTarget - 15
      end
   end
end

function Background:randomMessage()
   self:setMessage(Messages:random(), { isImportant = (math.random() < 0.3) })
end

function Background:draw()
   local spacing = GameState.viewport.height * 0.14
   local y = self._scrollIndex * spacing
   local height = spacing * 0.9
   local index = 0
   while y < -spacing do
      y = y + spacing
   end
   while y > 0 do
      y = y - spacing
   end
   love.graphics.setColor(0.7, 0.7, 0.7, 1)
   while y < GameState.viewport.height do
      self:_drawBox(index, y, height)
      y = y + spacing
      index = index + 1
   end
end

function Background:_drawBox(index, y, height)
   love.graphics.rectangle("line", 10, y, GameState.viewport.width * 0.18, height)
   if self._message ~= "" then
      local messageToPrint
      if math.abs(self._scrollIndexVelocity) < 0.1 then
         messageToPrint = self._messageVariants[1 + (index % 4)]
      else
         messageToPrint = "?????"
      end
      love.graphics.print(messageToPrint, 22, y + height * 0.5 - GameState.font:getHeight() * 0.5)
   end
end

return Background
