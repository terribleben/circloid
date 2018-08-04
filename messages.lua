Messages = {
   _messages = {},
   _count = 0,
}

function Messages:add(message)
   self._count = self._count + 1
   self._messages[self._count] = message
end

function Messages:random()
   return self._messages[math.random(1, self._count)]
end

Messages:add("MATCH")
Messages:add("SUCCESS")
Messages:add("ACCURATE")

return Messages
   
