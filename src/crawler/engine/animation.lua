local vector2 = require("crawler.engine.vector2")

--- Animation
---
--- @class animation
--- @field texture love.Texture
--- @field frame integer
--- @field time number
--- @field quads love.Quad[]
--- @field frames { index: integer, duration: number }[]
local M = {}

M.__index = M

--- Animation Factory
---
--- @param texture love.Texture
--- @param frames { index: integer, duration: number }[]
--- @param framesize? vector2
--- @param margin? vector2
--- @param spacing? vector2
function M.new(texture, frames, framesize, margin, spacing)
  local quads = {}
  local imagewidth, imageheight = texture:getDimensions()

  framesize = framesize or vector2.new(32, 32)
  margin = margin or vector2.new(0, 0)
  spacing = spacing or vector2.new(0, 0)

  local columns = math.floor(
    (imagewidth - margin.x + spacing.x) / (framesize.x + spacing.x)
  )
  local rows = math.floor(
    (imageheight - margin.y + spacing.y) / (framesize.y + spacing.y)
  )

  local self = {
    texture = texture,
    framesize = framesize,
    margin = margin,
    spacing = spacing,
    frame = 1,
    time = 0,
    quads = quads,
    frames = frames
  }

  for column = 0, columns - 1, 1 do
    for row = 0, rows - 1, 1 do
      table.insert(
        quads,
        love.graphics.newQuad(
          column * (framesize.x + spacing.x) + margin.x,
          row * (framesize.y + spacing.y) + margin.y,
          framesize.x,
          framesize.y,
          imagewidth,
          imageheight
        )
      )
    end
  end

  return setmetatable(self, M)
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
function M.draw(self, x, y)
  local frame = self.frames[self.frame]

  love.graphics.draw(self.texture, self.quads[frame.index], x, y)
end

return M
