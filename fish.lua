require "helpers"
fish = {
  new = function(imageA, imageB)
    local fishy = display.newGroup()
    local fishyLeft = display.newImage(imageA)
    local fishyRight = display.newImage(imageB)
    fishy:insert(fishyLeft)
    fishy:insert(fishyRight)

    fishy.dx = math.random(3) + 2
    fishy.dy = math.random(3) + 2
    fishy.old_dx = fishy.dx
    fishy.old_dy = fishy.dy
    fish.flip(fishy)

    fishy.x, fishy.y = helpers.randomPos(fishy)
    helpers.clamp(fishy)
    return fishy
  end,

  flip = function(o)
    if o.dy > 0 then
      o[1].isVisible = false
      o[2].isVisible = true
    else
      o[1].isVisible = true
      o[2].isVisible = false
    end
  end
}

