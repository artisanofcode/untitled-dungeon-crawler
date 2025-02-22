local vector2 = require("crawler.engine.vector2")
local textureatlas = require("crawler.engine.textureatlas")
local filepath = require("crawler.engine.filepath")

--- Tile Set.
---
--- @class tileset
--- @field atlas textureatlas
--- @field terrains table<string, integer>
local M = {}

--- Meta-table for tileset class
local MT = { __index = M }

--- Tile Set Factory.
---
--- @param atlas textureatlas texture atlas containing tiles
--- @param terrains? table<string, integer> mapping of terrain patterns to tile indices
---
--- @return tileset
function M.new(atlas, terrains)
  local self = {
    atlas = atlas,
    terrains = terrains or {}
  }

  return setmetatable(self, MT)
end

--- Load Tile Set
---
--- @param filename string
---
--- @return tileset
function M.load(filename)
  local chunk = love.filesystem.load(filename)
  local data = chunk()

  local atlas = textureatlas.new(
    love.graphics.newImage(
      filepath.resolve(filepath.join(filepath.parent(filename), data.image))
    ),
    vector2.new(data.tilewidth, data.tileheight),
    vector2.new(data.margin, data.margin),
    vector2.new(data.spacing, data.spacing)
  )

  local terrains = nil

  for _, wangset in ipairs(data.wangsets) do
    if wangset.wangsettype == "corner" then
      terrains = {}

      for _, tile in ipairs(wangset.wangtiles) do
        local id = tile.wangid
        terrains[id[2] .. ":" .. id[4] .. ":" .. id[6] .. ":" .. id[8]] = tile.tileid + 1
      end

      break
    end
  end

  return M.new(atlas, terrains)
end

--- Create SpriteBatch from Tiles
---
--- Create a SpriteBatch using the given tile data.
---
--- @param self tileset
--- @param data number[]
--- @param width number
--- @param height number
--- @param usage love.SpriteBatchUsage
--- @return love.SpriteBatch
function M.batch(self, data, width, height, usage)
  local batch = self.atlas:batch(width * height, usage)
  local size = self.atlas.assetsize

  for index, tile in ipairs(data) do
    if tile > 0 then
      self.atlas:batchadd(
        batch,
        tile,
        ((index - 1) % width) * size.x,
        math.floor((index - 1) / width) * size.y
      )
    end
  end

  return batch
end

--- Load Terrain
---
--- @param terrain integer[]
--- @param width integer
--- @param height integer
---
--- @return integer[] tiles
--- @return vector2 size
function M.fromterrain(self, terrain, width, height)
  local tiles = {}
  for y = 0, height - 2 do
    for x = 0, width - 2 do
      table.insert(
        tiles,
        self.terrains[
        terrain[y * width + x + 2] .. ":" ..
        terrain[(y + 1) * width + x + 2] .. ":" ..
        terrain[(y + 1) * width + x + 1] .. ":" ..
        terrain[y * width + x + 1]
        ])
    end
  end

  return tiles, vector2.new(width - 1, height - 1)
end

return M
