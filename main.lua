require "starfield"
require "body"

-- holds game state
local game = {
  paused = true,
  over = true
}

-- holds player state
local player = {}
native.showAlert("Yo!", "bsddssd")

local scenes = display.newGroup()

local stars = starfield:new()
