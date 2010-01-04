require "starfield"
require "fish"

display.setStatusBar(display.HiddenStatusBar) 

-- holds game state
local game = {
  paused = false,
  over = true
}

--media.playSound("bubbles.wav")
-- draws a layered starfield
local stars = starfield:new()

local scenes = display.newGroup()
local enemies = display.newGroup()
local bg = display.newGroup()
bg:insert(display.newImage("bg.png"))
bg:insert(display.newImage("bg_dark.png"))
bg[1].isVisible = false

local player = fish.new("fish.png", "fishb.png")
local fishies = {
  player,
--  fish.new("fish1.png", "fish1b.png"),
  --fish.new("fish2.png", "fish2b.png"),
  fish.new("fish3.png", "fish3b.png"),
  fish.new("fish4.png", "fish4b.png"),
  fish.new("fish5.png", "fish5b.png"),
  fish.new("fish6.png", "fish6b.png"),
  fish.new("fish7.png", "fish7b.png"),
  fish.new("fish8.png", "fish8b.png"),
--  fish.new("fish9.png", "fish9b.png")
}

local listeners = {
  accelerometer = function(event)
    if not game.paused then
      local filter = 50
      local x = (event.xGravity + event.xInstant) * filter
      local y = -(event.yGravity + event.yInstant) * filter
      player.dx = event.xInstant 
      player.dy = -event.yInstant 
      fish.flip(player)
      player:translate(x, y)
      helpers.clamp(player)
    end
  end,
  enterFrame = function(event)
    if game.paused then
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
    end
  end,
  system = function(event)
    if event.type == "applicationExit" then
      helpers.cleanup(fishies)
      stars:cleanup()
    end
  end
}

Runtime:addEventListener("accelerometer", listeners.accelerometer)
Runtime:addEventListener("enterFrame", listeners.enterFrame)
local positions = {}
Runtime:addEventListener("tap", function(event)
  player.dx, player.old_dx = player.old_dx, player.dx
  player.dy, player.old_dy = player.old_dy, player.dy
  if game.paused then
    Runtime:removeEventListener("enterFrame", listeners.enterFrame)
  else
    Runtime:addEventListener("enterFrame", listeners.enterFrame)
  end
  player.inTank = not player.inTank
  game.paused = not game.paused
  helpers.toggleVisibility(bg[1], bg[2])
end)

Runtime:addEventListener("system", listeners.system) 
