--- Tile Map
---
--- @class tilemap
--- @field data number[]
--- @field mapsize vector2
--- @field tilesize vector2
--- @field tileset tileset
local M = {}

M.__index = M

--- Tile Map Factory
---
--- @param data integer[][] map data
--- @param mapsize vector2 maps total dimensions
--- @param tileset tileset tileset to use when rendering map
---
--- @return tilemap
function M.new(data, mapsize, tileset)
  local self = {
    data = data,
    mapsize = mapsize,
    tilesize = tileset.tilesize,
    tileset = tileset,
  }

  return setmetatable(self, M)
end

---Check Type is Tile Map
---
---@param value any
--
---@return boolean
function M.istilemap(value)
  return getmetatable(value) == M
end

function M.draw(self)
  local width, height = self.mapsize:unpack()
  local tilewidth, tileheight = self.tilesize:unpack()
  local tileset = self.tileset

  local default = 2

  for x = 1, width do
    for y = 1, height do
      local tl, tr, br, bl = default, default, default, default

      tr = self.data[y][x] or default
      tl = self.data[y][x + 1] or default
      if y < height then
        br = self.data[y + 1][x] or default
        bl = self.data[y + 1][x + 1] or default
      end

      tileset:draw(
        tr, tl, bl, br,
        (x - 1) * tilewidth - tilewidth / 2,
        (y - 1) * tileheight - tileheight / 2
      )
    end
  end
end

return M
