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
Messages:add("TARGET ACHIEVED")
Messages:add("NEXT")
Messages:add("ALIGNED")
Messages:add("ORBIT ENGAGED")
Messages:add("RESONANT VALENCE")
Messages:add("TARGET LOCK")
Messages:add("PARTIAL TARGET LOCK")
Messages:add("COMPUTE NEXT")
Messages:add("LAGRANGE PREDICTION")
Messages:add("UNLOCK")
Messages:add("TARGET UNLOCK")
Messages:add("TARGET SYNCH")
Messages:add("ORBIT SYNCH")
Messages:add("ORBIT ALIGNED")
Messages:add("RESONANT ORBIT")
Messages:add("FUNDAMENTAL ORBIT")
Messages:add("FUNDAMENTAL VALENCE")
Messages:add("ESCAPE ORBIT")
Messages:add("COMPUTE SUCCESS")
Messages:add("NEXT UNLOCK")

return Messages
   
