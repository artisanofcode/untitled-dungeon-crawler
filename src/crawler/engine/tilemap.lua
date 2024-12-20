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
--- @param data integer[] map data
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
  local tileset, data = self.tileset, self.data
  local offsetwidth, offsetheight = tilewidth / 2, tileheight / 2

  for x = 0, width - 1 do
    for y = 0, height - 1 do
      local y2 = math.min(y + 1, height - 1)
      local x2 = math.min(x + 1, width - 1)

      tileset:draw(
        data[y * width + x + 1],
        data[y * width + x2 + 1],
        data[y2 * width + x2 + 1],
        data[y2 * width + x + 1],
        x * tilewidth - offsetwidth,
        y * tileheight - offsetheight
      )
    end
  end
end

return M
