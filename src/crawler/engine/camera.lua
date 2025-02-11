local vector2 = require("crawler.engine.vector2")
local rect2 = require("crawler.engine.rect2")

-- the offset from 0 for the edges of the default limit rectangle
local DEFAULT_LIMIT = 1000000000
-- the fraction of the viewports width/height from position to focus the camera
local FOCUS = vector2.new(0.5, 0.5)
-- same as focus but from the perspective of the viewports extent
local INVERSE_FOCUS = vector2.new(1, 1) - FOCUS

--- @class camera
--- @field private position vector2
--- @field private angle number
--- @field private scale number
--- @field private limits rect2
--- @field private viewport rect2
--- @field private transform love.Transform
--- @field private dirty boolean
--- @field private limitmin vector2
--- @field private limitmax vector2
--- @field private scissor? [number, number, number, number]
local M = {}

local MT = { __index = M }


--- Set Limit Min/Max
---
--- Find the bounding box of the viewport in the worlds coordinate system, then use it
--- to calculate the minimum and maximum position according to limits.
---
--- @param self camera
--- @private
function M.setlimitminmax(self)
  -- use dot notation instead of colon here in-case metatable has not been set.
  M.reconfigure(self)

  local l, t, r, b = self.viewport:edges()

  local x1, y1 = self.transform:inverseTransformPoint(l, t)
  local x2, y2 = self.transform:inverseTransformPoint(r, t)
  local x3, y3 = self.transform:inverseTransformPoint(r, b)
  local x4, y4 = self.transform:inverseTransformPoint(l, b)

  local px = math.min(math.min(x1, x2), math.min(x3, x4))
  local py = math.min(math.min(y1, y2), math.min(y3, y4))

  local ex = math.max(math.max(x1, x2), math.max(x3, x4))
  local ey = math.max(math.max(y1, y2), math.max(y3, y4))

  local size = vector2.new(ex, ey) - vector2.new(px, py)

  self.limitmin = self.limits.position + size * FOCUS
  self.limitmax = self.limits:extent() - size * INVERSE_FOCUS
end

--- Reconfigure
---
--- @param self camera
--- @private
function M.reconfigure(self)
  if not self.dirty then
    return
  end

  local offset = (self.viewport.position + self.viewport.size * FOCUS):round()
  local position = self.position:rounded()

  self.transform:setTransformation(
    offset.x,
    offset.y,
    self.angle,
    self.scale,
    self.scale,
    position.x,
    position.y
  )

  self.dirty = false
end

--- Size For
---
--- Calculate ratio and viewport based on desired resolution
---
--- @param width number
--- @param height number
--- @return integer ratio, rect2 viewport
function M.sizefor(width, height)
  local sw, sh = love.graphics.getDimensions()
  local ratio = math.floor(math.min(sw / width, sh / height))
  local vw, vh = width * ratio, height * ratio

  return ratio, rect2.new(math.floor((sw - vw) / 2), math.floor((sh - vh) / 2), vw, vh)
end

--- Camera Factory
---
--- @param position? vector2
--- @param angle? number
--- @param scale? number
--- @param limits? rect2
--- @param viewport? rect2
--- @return camera
function M.new(position, angle, scale, limits, viewport, target)
  local self = {
    scale = scale or 1,
    position = position or vector2.new(0, 0),
    angle = angle,
    viewport = viewport or rect2.new(0, 0, love.graphics.getDimensions()),
    limits = limits or rect2.new(
      -DEFAULT_LIMIT,
      -DEFAULT_LIMIT,
      DEFAULT_LIMIT * 2,
      DEFAULT_LIMIT * 2
    ),
    transform = love.math.newTransform(),
    dirty = true,
    scissor = {},
  }

  M.setlimitminmax(self)

  self.position = self.position:clamped(self.limitmin, self.limitmax)

  return setmetatable(self, MT)
end

--- Set Camera Position
---
--- @param self camera
--- @param position vector2
function M.setposition(self, position)
  self.dirty = self.position ~= position or self.dirty

  self.position = position:clamped(self.limitmin, self.limitmax)
end

--- Set Camera Bounds Limit
---
--- @param self camera
--- @param limits rect2
function M.setlimits(self, limits)
  if self.limits ~= limits then
    self.limits = limits
    self:setlimitminmax()
  end
end

--- Set Camera Viewport
---
--- @param self camera
--- @param viewport rect2
function M.setviewport(self, viewport)
  if self.viewport ~= viewport then
    self.viewport = viewport
    self:setlimitminmax()
  end
end

--- Attach camera to viewport
---
--- @param self camera
function M.attach(self)
  if self.dirty then
    self:reconfigure()
  end

  self.scissor = { love.graphics.getScissor() }

  love.graphics.setScissor(self.viewport:unpack())
  love.graphics.push()
  love.graphics.replaceTransform(self.transform)
end

--- Detach camera from viewport
---
--- @param self camera
function M.detach(self)
  love.graphics.pop()

  love.graphics.setScissor(unpack(self.scissor))
end

--- Convert to World Coordinate System
---
--- Convert a position vector from the screen coordinate system into the world
--- coordinate system.
---
--- @param self camera
--- @param coords vector2 screen coordinates
--- @return vector2 # world coordinates
function M.toworld(self, coords)
  return vector2.new(self.transform:inverseTransformPoint(coords.x, coords.y))
end

--- Convert to Screen Coordinate System
---
--- Convert a position vector from the world coordinate system into the screen
--- coordinate system.
---
--- @param self camera
--- @param coords vector2 world coordinates
--- @return vector2 # screen coordinates
function M.toscreen(self, coords)
  return vector2.new(self.transform:transformPoint(coords.x, coords.y))
end

return M
