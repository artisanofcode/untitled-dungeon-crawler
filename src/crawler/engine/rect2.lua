local vector2 = require("crawler.engine.vector2")

--- A 2D rectangle using fractional coordinates.
---
--- @class rect2
--- @field position vector2
--- @field size vector2
local M = {}

local MT = { __index = M }

--- Rectangle Factory
---
--- @param x any
--- @param y any
--- @param width any
--- @param height any
--- @return rect2
function M.new(x, y, width, height)
  local self = {
    position = vector2.new(x, y),
    size = vector2.new(width, height)
  }

  return setmetatable(self, MT)
end

--- Extent
---
--- Get the position of the opposite corner of the rectangle to position.
---
--- @param self rect2
--- @return vector2
function M.extent(self)
  return self.position + self.size
end

return M
