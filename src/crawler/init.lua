local M = {}

local engine = require("crawler.engine")
local object = require("crawler.object")

local objects = {}
--- @type player
local player = nil
--- @type camera
local camera = nil

function M.load()
  local spriteatlas = engine.textureatlas.new(
    love.graphics.newImage("data/assets/images/slime.png"),
    engine.vector2.new(32, 32)
  )

  local map = engine.tilemap.load("data/maps/village.lua")
  table.insert(objects, map)
  player = object.player.new(spriteatlas, 400, 300)
  table.insert(objects, player)
  table.insert(objects, object.slime.new(spriteatlas, 200, 400))

  local size = (map.mapsize - engine.vector2.new(1, 1)) * map.tilesize

  camera = engine.camera.new(2, engine.rect2.new(0, 0, size.x, size.y))
end

function M.update(dt)
  for _, obj in ipairs(objects) do
    if obj.update then
      obj:update(dt)
    end
  end

  camera:setposition(player.position)
end

function M.draw()
  camera:attach()

  for _, obj in ipairs(objects) do
    if obj.draw then
      obj:draw()
    end
  end

  camera:detach()
end

return M
