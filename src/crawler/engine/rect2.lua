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
--- @param x number
--- @param y number
--- @param width number
--- @param height number
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
--- @nodiscard
function M.extent(self)
  return self.position + self.size
end

--- Edges
---
--- Get the edges of the rectangle.
---
--- @param self rect2
--- @return number left, number top, number right, number bottom
--- @nodiscard
function M.edges(self)
  local l, t = self.position:unpack()
  local r, b = self:extent():unpack()

  return l, t, r, b
end

function MT.__eq(a, b)
  return a.position == b.position and a.size == b.size
end

return M
