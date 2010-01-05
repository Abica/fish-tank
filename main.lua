require "starfield"
require "fish"

display.setStatusBar(display.HiddenStatusBar) 

-- holds game state
local game = {
  paused = false,
  over = true,
  level = 1
}

--media.playSound("bubbles.wav")
-- draws a layered starfield
local stars = starfield:new()

local scenes = display.newGroup()
local bg = display.newGroup()
bg:insert(display.newImage("bg.png"))
bg:insert(display.newImage("bg_dark.png"))
bg[1].isVisible = false

local player = fish.new("fish.png", "fishb.png")
player.isPlayer = true
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

local events = {
  resetGame = function()
    for i, fishy in ipairs(fishies) do
      fishy.isVisible = true
      fishy.isHitTestable = true
      if fishy.isPlayer then
        fishy.x, fishy.y = helpers.center()
        fishy.y = 0
        fishy.dy = fishy.dy * -1
        player.lives = 3
      else
        fishy.speed = 5
        fishy.x, fishy.y = helpers.outOfSightBottom(fishy)
        fishy.dy = fishy.dy * -1
        fishy.y = fishy.y + fishy.height * i * 2
        helpers.clampX(fishy)

        fish.flip(fishy)
      end
    end
  end
}

events.resetGame()

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
    else

      for i, fishy in ipairs(fishies) do
        if fishy.isPlayer then
          helpers.clamp(fishy)
        else
          helpers.move(fishy)
          if helpers.touching(player, fishy) then
            if player.lives > 0 then
              transition.to(player, {alpha=0, time=1000})
              transition.to(player, {alpha=1, delay=1000, time=1000})
              player.isHitTestable = false
              timer.performWithDelay( 2000, function()
                player.isHitTestable = true
              end)
            else
              game.paused = true
              game.over = true
              player.inTank = not player.inTank
              helpers.toggleVisibility(bg[1], bg[2])
            end
            player.lives = player.lives - 1
          end
          if not helpers.inXBounds(fishy) then
            fishy.dx = fishy.dx * -1
          end
          if not helpers.withinSightTop(fishy) then
            fishy.x, fishy.y = helpers.outOfSightBottom(fishy)
            helpers.clampX(fishy)
            game.level = game.level + 1
          end
        end
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
Runtime:addEventListener("tap", function(event)
  player.dx, player.old_dx = player.old_dx, player.dx
  player.dy, player.old_dy = player.old_dy, player.dy
  if game.paused then
    Runtime:removeEventListener("enterFrame", listeners.enterFrame)
    for i, fishy in ipairs(fishies) do
      fishy.x = fishy.old_x
      fishy.y = fishy.old_y
      fishy.dx = fishy.old_dx
      fishy.dy = fishy.old_dy
      fish.flip(fishy)
    end
  else
    Runtime:addEventListener("enterFrame", listeners.enterFrame)
    for i, fishy in ipairs(fishies) do
      fishy.old_x = fishy.x
      fishy.old_y = fishy.y
      fishy.old_dx = fishy.dx
      fishy.old_dy = fishy.dy
    end
  end
  player.inTank = not player.inTank
  game.paused = not game.paused
  helpers.toggleVisibility(bg[1], bg[2])
end)

Runtime:addEventListener("system", listeners.system) 
