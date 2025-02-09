--- Tile Layer
---
--- @class tilelayer
--- @field data number[]
--- @field layersize vector2
--- @field tilesize vector2
--- @field offset vector2
--- @field tileset tileset
--- @field private batch love.SpriteBatch
local M = {}

--- Meta-table for tilelayer class
local MT = { __index = M }

--- Tile Layer Factory
---
--- @param data integer[] map data
--- @param layersize vector2 maps total dimensions
--- @param tilesize vector2 tile dimensions
--- @param offset vector2 layer offset
--- @param tileset tileset tileset to use when rendering map
---
--- @return tilelayer
function M.new(data, layersize, tilesize, offset, tileset)
  local self = {
    data = data,
    layersize = layersize,
    tilesize = tilesize,
    offset = offset,
    tileset = tileset,
    batch = tileset:batch(data, layersize.x, layersize.y, "dynamic")
  }

  return setmetatable(self, MT)
end

--- Draw Tile Layer
---
--- @param self tilelayer
function M.draw(self)
  love.graphics.draw(self.batch, self.offset.x, self.offset.y)
end

return M
