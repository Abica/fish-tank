local seed = os.time()
math.randomseed(seed)

helpers = {
  rand = function(n)
    return math.random(n or 255)
  end,

  randomRGB = function()
    local r = helpers.rand
    return r(), r(), r()
  end,

  cleanup = function(o)
    for k, v in ipairs(o) do
      o[k] = nil
    end 

    for i=o.numChildren,1,-1 do 
      local child = o[i] 
      child.parent:remove(child) 
    end 
  end
}
