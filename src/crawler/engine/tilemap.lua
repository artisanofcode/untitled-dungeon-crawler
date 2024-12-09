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
  local width = self.mapsize.x
  local tilewidth, tileheight = self.tilesize:unpack()
  local tileset = self.tileset

  for i, tileindex in ipairs(self.data) do
    if tileindex > 0 then
      tileset:draw(
        tileindex,
        ((i - 1) % width) * tilewidth,
        (math.floor((i - 1) / width)) * tileheight
      )
    end
  end
end

return M
