require "helpers"

starfield = {
  -- how many stars should be displayed on the screen?
  numStars = 5,
  minSpeed = 10,
  maxSpeed = 20,
  minWidth = 400,
  maxWidth = 2000,
  minHeight = 20,
  maxHeight = 100,
  minAlpha = 0.9,
  maxAlpha = 1,
  stars = nil,

  new = function(self, o)
    local o = o or self
    setmetatable(o, self)
    self.__index = self
    self.stars = display.newGroup()
    self:setupStars()
    self:setupTimer()
    return o
  end,

  -- creates numStars and puts them on the screen
  setupStars = function(self)
    for i=1, self.numStars do
      self:addStar()
    end
  end,

  -- creates a new star and places it at a random x axis just off of the top of the screen
  addStar = function(self)
    local width = math.random(self.minWidth, self.maxWidth)
    local x, y = helpers.randomPos(star)
    local star = display.newCircle(x, y, width / 2)
    --local star = display.newImage("star.png")
--    local star = display.newRect(0, 0, width, width)
    self:resetStar(star)
    self.stars:insert(star)
    return star
  end,

  -- moves star to a random x axis off of the top of the screen
  -- and randomizes it's color and alpha
  resetStar = function(self, star)
    local x, y = helpers.outOfSightTop(star)
    star.x = x
    star.y = y
    star.alpha = math.random()
    star.alpha = star.alpha < self.minAlpha and self.minAlpha or star.alpha
    star.alpha = star.alpha > self.maxAlpha and self.maxAlpha or star.alpha
    star.speed = math.random(self.minSpeed, self.maxSpeed)
    star:setFillColor(helpers.randomRGB())
    local _, endY = helpers.outOfSightBottom(star)

--[[
    transition.to(star, {
      time=helpers.height / star.speed * helpers.fps,
      y=endY,
      onComplete = function()
        self:resetStar(star) 
      end
    })
--]]
    return star
  end,

  enterFrame = function(self, event)
    for i=1, self.stars.numChildren do
      local star = self.stars[i]
      star:translate(0, star.speed)
      if not helpers.withinSight(star) then
        self:resetStar(star)
      end
    end
  end,

  setupTimer = function(self)
    Runtime:addEventListener("enterFrame", self)
    for i=1, self.stars.numChildren do
      local star = self.stars[i]
      star:translate(0, star.speed)
      if not helpers.withinSight(star) then
        self:resetStar(star)
      end
    end
  end,

  cleanup = function(self)
    Runtime:removeEventListener("enterFrame", self)
    helpers.cleanup(self.stars)
  end
}
