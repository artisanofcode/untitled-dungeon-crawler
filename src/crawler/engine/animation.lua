--- @module "crawler.engine.textureatlas"

local vector2 = require("crawler.engine.vector2")

--- Animation
---
--- @class animation
--- @field atlas textureatlas
--- @field frame integer
--- @field time number
--- @field frames { index: integer, duration: number }[]
local M = {}

--- Meta-table for animation class
local MT = { __index = M }

--- Animation Factory
---
--- @param atlas textureatlas
--- @param frames { index: integer, duration: number }[]
function M.new(atlas, frames)
  local self = {
    atlas = atlas,
    frame = 1,
    time = 0,
    frames = frames
  }

  return setmetatable(self, MT)
end

--- Check Type is Animation
---
--- @param value any
---
--- @return boolean
function M.isanimation(value)
  return getmetatable(value) == MT
end

--- Update Animation
---
--- @param self animation
--- @param dt number delta time
function M.update(self, dt)
  self.time = self.time + dt

  while self.time >= self.frames[self.frame].duration do
    self.time = self.time - self.frames[self.frame].duration

    self.frame = self.frame + 1

    if self.frame > #self.frames then
      self.frame = 1
    end
  end
end

--- Draw Current Frame
---
--- @param self animation
--- @param x number
--- @param y number
--- @param r? number
--- @param sx? number
--- @param sy? number
--- @param ox? number
--- @param oy? number
function M.draw(self, x, y, r, sx, sy, ox, oy)
  self.atlas:draw(self.frames[self.frame].index, x, y, r, sx, sy, ox, oy)
end

return M
