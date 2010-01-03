require "starfield"
require "fish"

display.setStatusBar(display.HiddenStatusBar) 

-- holds game state
local game = {
  paused = true,
  over = true
}

--media.playSound("bg.mp3")
-- draws a layered starfield
local stars = starfield:new({numStars = 4})

local scenes = display.newGroup()
local enemies = display.newGroup()
local bg = display.newImage("bg.png")
local player = fish.new("fish.png")
local fishies = {
  player,
  fish.new("fish1.png"),
  fish.new("fish2.png"),
  fish.new("fish3.png"),
  fish.new("fish4.png"),
  fish.new("fish5.png"),
  fish.new("fish6.png"),
  fish.new("fish7.png"),
  fish.new("fish8.png"),
  fish.new("fish9.png")
}

Runtime:addEventListener("enterFrame", function()
  for i, fishy in ipairs(fishies) do
    helpers.move(fishy)
    if not helpers.inXBounds(fishy) then
      fishy.dx = fishy.dx * -1
    end

    if not helpers.inYBounds(fishy) then
      fishy.dy = fishy.dy * -1
    end
    helpers.clamp(fishy)
  end
end)

Runtime:addEventListener("system", function(event)
  if event.type == "applicationExit" then
    stars:cleanup()
  end
end)
