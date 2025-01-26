local vector2 = require("crawler.engine.vector2")
local animation = require("crawler.engine.animation")
local trait = require("src.crawler.trait.init")

--- @class slime: animatable, moveable
local M = {}

--- Meta-table for slime class
local MT = { __index = M }

--- Slime Factory
---
--- @param atlas textureatlas
--- @param x number
--- @param y number
--- @return slime
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
  local velocity = vector2.new(50, 50)

  trait.animatable.apply(self, animation, position)
  trait.moveable.apply(self, position, velocity)

  return self
end

--- Update
---
--- @param self slime
--- @param dt any
function M.update(self, dt)
  trait.animatable.update(self, dt)
  trait.moveable.update(self, dt)
end

return M
