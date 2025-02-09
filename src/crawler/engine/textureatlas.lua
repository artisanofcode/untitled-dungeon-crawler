local vector2 = require("crawler.engine.vector2")

--- Texture Atlas
---
--- @class textureatlas
--- @field private texture love.Texture\
--- @field assetsize vector2
--- @field private margin vector2
--- @field private spacing vector2
--- @field private quads love.Quad[]
local M = {}

--- Meta-table for textureatlas class
local MT = { __index = M }

---Texture Atlas Factory
---
---@param texture love.Texture
---@param assetsize? vector2
---@param margin? vector2
---@param spacing? vector2
---
---@return table
function M.new(texture, assetsize, margin, spacing)
  local quads = {}
  local imagewidth, imageheight = texture:getDimensions()

  texture:setFilter("nearest", "nearest")

  assetsize = assetsize or vector2.new(32, 32)
  margin = margin or vector2.new(0, 0)
  spacing = spacing or vector2.new(0, 0)

  local self = {
    texture = texture,
    assetsize = assetsize,
    imagesize = vector2.new(imagewidth, imageheight),
    margin = margin,
    spacing = spacing,
    quads = quads,
  }

  local columns = math.floor(
    (imagewidth - margin.x + spacing.x) / (assetsize.x + spacing.x)
  )
  local rows = math.floor(
    (imageheight - margin.y + spacing.y) / (assetsize.y + spacing.y)
  )

  for row = 0, rows - 1, 1 do
    for column = 0, columns - 1, 1 do
      table.insert(
        quads,
        love.graphics.newQuad(
          column * (assetsize.x + spacing.x) + margin.x,
          row * (assetsize.y + spacing.y) + margin.y,
          assetsize.x,
          assetsize.y,
          imagewidth,
          imageheight
        )
      )
    end
  end

  return setmetatable(self, MT)
end

--- Draw an Asset
---
---@param self textureatlas
---@param index integer
---@param x number
---@param y number
function M.draw(self, index, x, y)
  love.graphics.draw(self.texture, self.quads[index], x, y)
end

--- Create SpriteBatch
---
--- Creates a SpriteBatch using the given textureatlas.
---
--- @param self textureatlas
--- @param maxsprites? number
--- @param usage? love.SpriteBatchUsage
--- @return love.SpriteBatch
function M.batch(self, maxsprites, usage)
  return love.graphics.newSpriteBatch(self.texture, maxsprites, usage)
end

--- Add to SpriteBatch
---
--- Add a specific asset from the textureatlas to the sprite sheet at given position.
---
--- @param self textureatlas
--- @param batch love.SpriteBatch
--- @param index number
--- @param x number
--- @param y number
function M.batchadd(self, batch, index, x, y)
  batch:add(self.quads[index], x, y)
end

return M
