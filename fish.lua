require "helpers"
fish = {
  new = function(image)
    local fishy = display.newImage(image)
    fishy.dx, fishy.dy = math.random(3), math.random(3)
    fishy.x, fishy.y = helpers.randomPos(fishy)
    helpers.clamp(fishy)
    return fishy
  end
}

