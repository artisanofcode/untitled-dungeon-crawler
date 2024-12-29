local vector2 = require("crawler.engine.vector2")
local tileset = require("crawler.engine.tileset")
local tilelayer = require("crawler.engine.tilelayer")

--- Tile Map
---
--- @class tilemap
--- @field mapsize vector2
--- @field layers tilelayer[]
local M = {}

M.__index = M

--- Tile Map Factory
---
--- @param mapsize vector2 maps total dimensions
--- @param layers tilelayer[] map layers
---
--- @return tilemap
function M.new(mapsize, layers)
  local self = {
    mapsize = mapsize,
    layers = layers,
  }

  return setmetatable(self, M)
end

--- Load Tile Map
--- @param filename string
---
--- @return tilemap
function M.load(filename)
  local chunk = love.filesystem.load(filename)
  local data = chunk()

  local pathname = filename:match("(.+)/") or ""
  local tilesetfile = data.tilesets[1].exportfilename

  while tilesetfile:sub(1, 3) == "../" do
    pathname = pathname:match("(.+)/")
    tilesetfile = tilesetfile:sub(4)
  end

  local tiles = tileset.load(pathname .. "/" .. tilesetfile)

  local layers = {}

  local tilesize = vector2.new(data.tilewidth, data.tileheight)
  for _, item in ipairs(data.layers) do
    if item.type == "tilelayer" then
      local data = {}

      local layer = tilelayer.new(
        item.data,
        vector2.new(item.width, item.height),
        tilesize,
        tiles
      )

      table.insert(layers, layer)
    end
  end

  return M.new(vector2.new(data.width, data.height), layers)
end

---Check Type is Tile Map
---
---@param value any
--
---@return boolean
function M.istilemap(value)
  return getmetatable(value) == M
end

--- Draw Tile Map
---
--- @param self tilemap
function M.draw(self)
  for _, layer in ipairs(self.layers) do
    layer:draw()
  end
end

return M
