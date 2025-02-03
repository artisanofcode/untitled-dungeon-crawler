local vector2 = require("crawler.engine.vector2")

--- @class camera
--- @field position vector2
--- @field scale number
--- @field screen vector2
--- @field offset vector2
--- @field limits { left?: number, top?: number, right?: number, bottom?: number}
local M = {}

local MT = { __index = M }

--- Camera Factory
---
--- @param scale number
--- @return camera
function M.new(scale)
  local self = {
    scale = scale,
    screen = vector2.new(love.graphics.getDimensions()),
    limits = { left = nil, top = nil, right = nil, bottom = nil }
  }

  M.setposition(self, vector2.new(0, 0))

  return setmetatable(self, MT)
end

--- Set Camera Position
---
--- @param self camera
--- @param position vector2
function M.setposition(self, position)
  local ox, oy = (self.screen / self.scale / 2):unpack()
  local x, y = position:unpack()

  if self.limits.left then
    x = math.max(self.limits.left + ox, x)
  end

  if self.limits.top then
    y = math.max(self.limits.top + oy, y)
  end

  if self.limits.right then
    x = math.min(self.limits.right - ox, x)
  end

  if self.limits.bottom then
    y = math.min(self.limits.bottom - oy, y)
  end

  self.position = vector2.new(x, y)
end

--- Set Camera Bounds Limit
---
--- @param self camera
--- @param left any
--- @param top any
--- @param right any
--- @param bottom any
function M.setlimits(self, left, top, right, bottom)
  self.limits.left = left
  self.limits.top = top
  self.limits.right = right
  self.limits.bottom = bottom
end

--- Attach camera to screen
---
--- @param self camera
function M.attach(self)
  love.graphics.push()
  love.graphics.translate(self.screen.x / 2, self.screen.y / 2)
  love.graphics.scale(self.scale)
  love.graphics.translate(-self.position.x, -self.position.y)
end

--- Detach camera from screen
---
--- @param self camera
function M.detach(self)
  love.graphics.pop()
end

return M
