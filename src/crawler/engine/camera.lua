local vector2 = require("crawler.engine.vector2")
local rect2 = require("crawler.engine.rect2")

--- @class camera
--- @field position vector2
--- @field scale number
--- @field screen vector2
--- @field offset vector2
--- @field limits rect2
local M = {}

local MT = { __index = M }

--- Camera Factory
---
--- @param scale number
--- @param limits rect2
--- @return camera
function M.new(scale, limits)
  local self = {
    scale = scale,
    screen = vector2.new(love.graphics.getDimensions()),
    position = vector2.new(0, 0),
    limits = limits
  }

  return setmetatable(self, MT)
end

--- Set Camera Position
---
--- @param self camera
--- @param position vector2
function M.setposition(self, position)
  --- get half screen size in game worlds coordinate system
  local offset = (self.screen / self.scale / 2)
  -- round position in game world coordinate system to camera coordinate system and
  -- constrain camera to be within the limits
  self.position = ((position * self.scale):rounded() / self.scale):clamped(
    self.limits.position + offset,
    self.limits:extent() - offset
  )
end

--- Set Camera Bounds Limit
---
--- @param self camera
--- @param limits rect2
function M.setlimits(self, limits)
  self.limits = limits
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
