local vector2 = require("crawler.engine.vector2")

--- Tile Set.
---
--- @class tileset
--- @field texture love.Texture
--- @field tilesize vector2
--- @field margin vector2
--- @field spacing vector2
--- @field imagesize vector2
--- @field columns integer
--- @field quads love.Quad[]
local M = {}

M.__index = M

--- Tile Set Factory.
---
--- @param texture love.Texture texture atlas containing tiles
--- @param tilesize? vector2 size of the tiles
--- @param margin? vector2 distance of tiles from top left of image
--- @param spacing? vector2 distance between tiles
---
--- @return tileset
function M.new(texture, tilesize, margin, spacing)
  local quads = {}
  local imagewidth, imageheight = texture:getDimensions()

  tilesize = tilesize or vector2.new(32, 32)
  margin = margin or vector2.new(0, 0)
  spacing = spacing or vector2.new(0, 0)

  local columns = math.floor(
    (imagewidth - margin.x + spacing.x) / (tilesize.x + spacing.x)
  )
  local rows = math.floor(
    (imageheight - margin.y + spacing.y) / (tilesize.y + spacing.y)
  )

  local self = {
    texture = texture,
    tilesize = tilesize,
    margin = margin,
    spacing = spacing,
    imagesize = vector2.new(imagewidth, imageheight),
    columns = columns,
    quads = quads,
  }

  for column = 0, columns - 1, 1 do
    for row = 0, rows - 1, 1 do
      table.insert(
        quads,
        love.graphics.newQuad(
          column * (tilesize.x + spacing.x) + margin.x,
          row * (tilesize.y + spacing.y) + margin.y,
          tilesize.x,
          tilesize.y,
          imagewidth,
          imageheight
        )
      )
    end
  end

  return setmetatable(self, M)
end

--- Check type is Tile Set.
---
--- @param value any value to check
---
--- @return boolean
function M.istileset(value)
  return getmetatable(value) == M
end

--- Draw Tile.
---
--- @param self tileset tileset to draw
--- @param index integer tile index
--- @param x number pixel X coordinate
--- @param y number pixel Y coordinate
function M.draw(self, index, x, y)
  love.graphics.draw(self.texture, self.quads[index], x, y)
end

return M
