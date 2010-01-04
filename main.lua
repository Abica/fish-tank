require "starfield"
require "fish"

display.setStatusBar(display.HiddenStatusBar) 

-- holds game state
local game = {
  paused = true,
  over = true
}

--media.playSound("bubbles.wav")
-- draws a layered starfield
local stars = starfield:new()

local scenes = display.newGroup()
local enemies = display.newGroup()
local bg = display.newImage("bg.png")
local player = fish.new("fish.png", "fishb.png")
local fishies = {
  player,
  fish.new("fish1.png", "fish1b.png"),
  fish.new("fish2.png", "fish2b.png"),
  fish.new("fish3.png", "fish3b.png"),
  fish.new("fish4.png", "fish4b.png"),
  fish.new("fish5.png", "fish5b.png"),
  fish.new("fish6.png", "fish6b.png"),
  fish.new("fish7.png", "fish7b.png"),
  fish.new("fish8.png", "fish8b.png"),
  fish.new("fish9.png", "fish9b.png")
}

Runtime:addEventListener("accelerometer", function(event)
  
end)

Runtime:addEventListener("enterFrame", function()
  for i, fishy in ipairs(fishies) do
    helpers.move(fishy)
    if not helpers.inXBounds(fishy) then
      fishy.dx = fishy.dx * -1
    end

    if not helpers.inYBounds(fishy) then
      fishy.dy = fishy.dy * -1
      fish.flip(fishy)
    end
    helpers.clamp(fishy)
  end
end)

Runtime:addEventListener("system", function(event)
  if event.type == "applicationExit" then
    stars:cleanup()
  end
end)
