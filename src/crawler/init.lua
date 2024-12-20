local M = {}

local vector2 = require("crawler.engine.vector2")
local tileset = require("crawler.engine.tileset")
local tilemap = require("crawler.engine.tilemap")
local animation = require("crawler.engine.animation")

local objects = {}

local function sprite_move(sprite, dt)
  sprite.position = sprite.position + (sprite.velocity * dt)
end

function M.load()
  local sprite_image = love.graphics.newImage("data/assets/images/slime.png")

  local slime = {
    animation = animation.new(
      sprite_image,
      {
        { index = 1, duration = 0.3 },
        { index = 2, duration = 0.4 },
        { index = 1, duration = 0.2 },
        { index = 2, duration = 0.1 },
      }
    ),
    position = vector2.new(400, 300),
    velocity = vector2.new(0, 0),
    speed = 100,
    update = function(self, dt)
      self.animation:update(dt)

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

      self.velocity = velocity:normalize() * self.speed

      sprite_move(self, dt)
    end,
    draw = function(self)
      self.animation:draw(self.position.x, self.position.y)
    end,
  }
  table.insert(objects, 1, slime)

  local slime2 = {
    animation = animation.new(
      sprite_image,
      {
        { index = 1, duration = 0.3 },
        { index = 2, duration = 0.4 },
        { index = 1, duration = 0.2 },
        { index = 2, duration = 0.1 },
      }
    ),
    position = vector2.new(200, 400),
    velocity = vector2.new(50, 50),
    update = function(self, dt)
      self.animation:update(dt)

      sprite_move(self, dt)
    end,
    draw = function(self)
      self.animation:draw(self.position.x, self.position.y)
    end,
  }
  table.insert(objects, 1, slime2)

  local tiles = tileset.new(
    love.graphics.newImage("data/assets/images/tiles.png"),
    vector2.new(32, 32),
    vector2.new(0, 0),
    vector2.new(0, 0),
    {
      ["1:1:1:2"] = 1,
      ["1:2:2:1"] = 2,
      ["2:1:2:2"] = 3,
      ["1:1:2:2"] = 4,
      ["2:1:2:1"] = 5,
      ["1:2:2:2"] = 6,
      ["2:2:2:2"] = 7,
      ["2:2:1:2"] = 8,
      ["1:2:1:1"] = 9,
      ["2:2:1:1"] = 10,
      ["2:2:2:1"] = 11,
      ["2:1:1:2"] = 12,
      ["1:1:1:1"] = 13,
      ["1:1:2:1"] = 14,
      ["1:2:1:2"] = 15,
      ["2:1:1:1"] = 16,
    }
  )

  local map = tilemap.new(
    {
      2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
      2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
      2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2,
      2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2,
      2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2,
      2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2,
      2, 2, 2, 1, 1, 1, 2, 1, 1, 1, 1, 1, 2, 2, 2, 2,
      2, 2, 2, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 2, 2,
      2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
      2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
      2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
      2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2,
      2, 2, 2, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 2, 2,
      2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2,
      2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2, 2,
    },
    vector2.new(16, 15),
    tiles
  )
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
