local M = {}

M.__index = M

function M.new(data, mapsize, tileset)
  local self = {
    data = data,
    mapsize = mapsize,
    tilesize = tileset.tilesize,
    tileset = tileset,
  }

  return setmetatable(self, M)
end

function M.ismap(value)
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
