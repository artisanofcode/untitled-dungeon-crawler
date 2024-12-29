local M = {}

local vector2 = require("crawler.engine.vector2")
local tileset = require("crawler.engine.tileset")
local tilemap = require("crawler.engine.tilemap")
local tilelayer = require("crawler.engine.tilelayer")
local textureatlas = require("crawler.engine.textureatlas")
local messagebus = require("crawler.engine.messagebus")
local object = require("crawler.object")

local objects = {}

function M.load()
  local sprite_atlas = textureatlas.new(
    love.graphics.newImage("data/assets/images/slime.png"),
    vector2.new(32, 32)
  )

  local bus = messagebus.new()
  bus:register(object.player.new("Player", sprite_atlas, 400, 300))
  bus:register(object.slime.new("Slime", sprite_atlas, 200, 400))

  bus:on("update", { "position", "velocity" }, function(obj, dt)
    obj.position = obj.position + (obj.velocity * dt)
  end)

  bus:on("update", { "animation" }, function(obj, dt)
    obj.animation:update(dt)
  end)

  bus:on("update", { "velocity", "speed", "input" }, function(obj, dt)
    local velocity = vector2.new(0, 0)

    if love.keyboard.isDown("w") then
      velocity.y = velocity.y - 1
    end

    if love.keyboard.isDown("a") then
      velocity.x = velocity.x - 1
    end

    if love.keyboard.isDown("s") then
      velocity.y = velocity.y + 1
    end

    if love.keyboard.isDown("d") then
      velocity.x = velocity.x + 1
    end

    obj.velocity = velocity:normalize() * obj.speed
  end)

  bus:on("draw", { "animation", "position" }, function(obj, _)
    obj.animation:draw(obj.position.x, obj.position.y)
  end)

  table.insert(objects, bus)

  -- local tiles = tileset.load("data/tilesets/tiles.lua")

  -- local tiles = tileset.new(
  --   tile_atlas,
  --   {
  --     ["1:1:1:2"] = 1,
  --     ["1:2:2:1"] = 2,
  --     ["2:1:2:2"] = 3,
  --     ["1:1:2:2"] = 4,
  --     ["2:1:2:1"] = 9,
  --     ["1:2:2:2"] = 10,
  --     ["2:2:2:2"] = 11,
  --     ["2:2:1:2"] = 12,
  --     ["1:2:1:1"] = 17,
  --     ["2:2:1:1"] = 18,
  --     ["2:2:2:1"] = 19,
  --     ["2:1:1:2"] = 20,
  --     ["1:1:1:1"] = 25,
  --     ["1:1:2:1"] = 26,
  --     ["1:2:1:2"] = 27,
  --     ["2:1:1:1"] = 28,
  --   }
  -- )

  -- local data, mapsize = tiles:fromterrain(
  --   {
  --     2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  --     2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  --     2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2,
  --     2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2,
  --     2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2,
  --     2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2,
  --     2, 2, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 2, 2, 2,
  --     2, 2, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 2,
  --     2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
  --     2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
  --     2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
  --     2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
  --     2, 2, 2, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 2, 2,
  --     2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
  --     2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2,
  --   },
  --   16,
  --   15
  -- -- )

  -- local layer = tilelayer.new(
  --   data,
  --   mapsize,
  --   vector2.new(32, 32),
  --   tiles
  -- )

  -- local map = tilemap.new(mapsize, { layer })

  local map = tilemap.load("data/maps/village.lua")

  table.insert(objects, 1, map)
end

function M.update(dt)
  for _, object in ipairs(objects) do
    if object.update then
      object:update(dt)
    end
  end
end

function M.draw()
  for _, object in ipairs(objects) do
    if object.draw then
      object:draw()
    end
  end
end

return M
