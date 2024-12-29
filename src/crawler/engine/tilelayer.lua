--- Tile Layer
---
--- @class tilelayer


local M = {}
local MT = { __index = M }

--- Tile Layer Factory
---
--- @param data integer[] map data
--- @param layersize vector2 maps total dimensions
--- @param tilesize vector2 tile dimensions
--- @param tileset tileset tileset to use when rendering map
---
--- @return tilemap
function M.new(data, layersize, tilesize, tileset)
  local self = {
    data = data,
    layersize = layersize,
    tilesize = tilesize,
    tileset = tileset,
  }

  return setmetatable(self, MT)
end

function M.draw(self)
  local width, height = self.layersize:unpack()
  local tilewidth, tileheight = self.tilesize:unpack()
  local tileset, data = self.tileset, self.data
  local offsetwidth, offsetheight = tilewidth / 2, tileheight / 2

  for x = 0, width - 1 do
    for y = 0, height - 1 do
      tileset:draw(
        data[y * width + x + 1],
        x * tilewidth - offsetwidth,
        y * tileheight - offsetheight
      )
    end
  end
end

return M
