local M = {}

local engine = require("crawler.engine")
local object = require("crawler.object")

local objects = {}

function M.load()
  local spriteatlas = engine.textureatlas.new(
    love.graphics.newImage("data/assets/images/slime.png"),
    engine.vector2.new(32, 32)
  )

  table.insert(objects, engine.tilemap.load("data/maps/village.lua"))
  table.insert(objects, object.player.new(spriteatlas, 400, 300))
  table.insert(objects, object.slime.new(spriteatlas, 200, 400))
end

function M.update(dt)
  for _, obj in ipairs(objects) do
    if obj.update then
      obj:update(dt)
    end
  end
end

function M.draw()
  for _, obj in ipairs(objects) do
    if obj.draw then
      obj:draw()
    end
  end
end

return M
