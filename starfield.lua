require "helpers"

starfield = {
  numStars = 4,
  speed = 2,
  stars = nil,

  new = function(self, o)
    local o = o or {} 
    setmetatable(o, self)
    self.__index = self
    self.stars = display.newGroup()
    self:setupStars()
    return o
  end,

  makeStar = function(self)
  end,

  setupStars = function(self)
    for i=1, self.numStars do
      local star = display.newRect(0, 0, 100, 100) 
      star.x = 50
      star.y = 50
      star:setFillColor(helpers.randomRGB())

      self.stars:insert(star)
    end
  end,

  setupTimer = function(self)
    self:addEventListener("timer", function()

    end)
  end,

  cleanup = function(self)
    helpers.cleanup(self.stars)
  end
}
