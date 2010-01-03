helpers = {
  fps = 30,
  width = display.stageWidth,
  height = display.stageHeight,
  top = 0,
  left = 0,

  rand = function(n)
    return math.random(n or 255)
  end,

  randomRGB = function()
    local r = helpers.rand
    return r(), r(), r()
  end,

  -- returns a random x position within screen bounds
  randomX = function()
    return helpers.rand(helpers.width)
  end,

  -- returns a random y position within screen bounds
  randomY = function()
    return helpers.rand(helpers.height)
  end,

  -- generates a random position clamped to o
  randomPos = function()
    return helpers.randomX(), helpers.randomY()
  end,

  -- center of the screen
  center = function()
    return helpers.width / 2, helpers.height / 2
  end,

  -- locks object into viewport
  -- TODO: this should take a bounding box to clamp to
  clamp = function(o)
    local h = helpers
    local top = h.top
    local left = h.left
    local right = h.width - o.width / 2
    local down = h.height - o.height / 2

    if o.y < top then
      o.y = top
    end

    if o.y > down then
      o.y = down
    end

    if o.x < left then
      o.x = left
    end

    if o.x > right then
      o.x = right
    end
  end,

  inXBounds = function(o)
    local h = helpers
    local width = o.width / 2
    local left = h.left + width
    local right = h.width - width

    return( o.x >= left and o.x <= right  ) 
  end,

  inYBounds = function(o)
    local h = helpers
    local height = o.height / 2
    local top = h.top + height
    local down = h.height - height

    return( o.y >= top and o.y <= down )
  end,

  -- returns a random x and a y just off the top of the screen
  outOfSightTop = function(o)
    local x = helpers.randomX()
    local y = helpers.top - o.height
    return x, y
  end,

  -- returns a random x and a y just off the bottom of the screen
  outOfSightBottom = function(o)
    local x = helpers.randomX()
    local y = helpers.height + o.height
    return x, y
  end,

  -- has o fallen off of the bottom of the screen?
  withinSight = function(o)
    return o.y - o.height < helpers.height
  end,

  -- try to run a function if it exists
  try = function(...)
    for i, v in pairs(arg) do
      if type(v) == "function" then
        v()
      end
    end
  end,

  move = function(o)
    o:translate(o.dx, o.dy)
    return o
  end,

  -- nils out all attributes and removes them from the display hierarchy 
  cleanup = function(o)
    for k, v in ipairs(o) do
      o[k] = nil
    end 

    for i=o.numChildren, 1, -1 do 
      local child = o[i] 
      helpers.try(child.cleanup)
      child.parent:remove(child) 
    end 
  end
}
