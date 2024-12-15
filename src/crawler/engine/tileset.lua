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
--- @field terrains table<string, integer>
local M = {}

M.__index = M

--- Tile Set Factory.
---
--- @param texture love.Texture texture atlas containing tiles
--- @param tilesize? vector2 size of the tiles
--- @param margin? vector2 distance of tiles from top left of image
--- @param spacing? vector2 distance between tiles
--- @param terrains? table<string, integer> mapping of terrain patterns to tile indices
---
--- @return tileset
function M.new(texture, tilesize, margin, spacing, terrains)
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
    terrains = terrains or {}
  }

  for column = 0, columns - 1, 1 do
    for row = 0, rows - 1, 1 do
      table.insert(
        quads,
        love.graphics.newQuad(
          row * (tilesize.y + spacing.y) + margin.y,
          column * (tilesize.x + spacing.x) + margin.x,
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
function M.draw(self, tl, tr, br, bl, x, y)
  local index = self.terrains[tl .. ":" .. tr .. ":" .. br .. ":" .. bl]

  love.graphics.draw(self.texture, self.quads[index], x, y)
end

return M
