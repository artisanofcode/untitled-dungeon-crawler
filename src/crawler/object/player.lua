local vector2 = require("crawler.engine.vector2")
local animation = require("crawler.engine.animation")
local trait = require("src.crawler.trait.init")

--- @class player: animatable, controllable
local M = {}

--- Meta-table for player class
local MT = { __index = M }

--- Player Factory
---
--- @param atlas textureatlas
--- @param x number
--- @param y number
--- @return player
function M.new(atlas, x, y)
  local self = setmetatable({}, MT)

  local animation = animation.new(
    atlas,
    {
      { index = 1, duration = 0.3 },
      { index = 2, duration = 0.4 },
      { index = 1, duration = 0.2 },
      { index = 2, duration = 0.1 },
    }
  )
  local position = vector2.new(x, y)
  local velocity = vector2.new(0, 0)

  trait.animatable.apply(self, animation, position)
  trait.controllable.apply(self, position, velocity, 100)

  return self
end

--- Update
---
--- @param self player
--- @param dt number
function M.update(self, dt)
  trait.animatable.update(self, dt)
  trait.controllable.update(self, dt)
end

return M
