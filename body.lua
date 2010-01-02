body = {
  name = "Uber Goober",
  life = 100,
  cost = 100,
  speed = 100,
  strength = 100,
  image = nil,

  new = function(self, o)
    local o = o or {} 
    setmetatable(o, self)
    self.__index = self
--    self.image = display.newRect()
    return o
  end,

  speak = function(self)
    return self.name
  end
}
