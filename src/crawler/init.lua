local M = {}

local vector2 = require("crawler.engine.vector2")
local tileset = require("crawler.engine.tileset")
local tilemap = require("crawler.engine.tilemap")

local objects = {}

local function sprite_draw(sprite)
  love.graphics.draw(sprite.image, sprite.frames[sprite.frame_index], sprite.position.x, sprite.position.y)
end

local function sprite_move(sprite, dt)
  sprite.position = sprite.position + (sprite.velocity * dt)
end

local function sprite_animate(sprite, dt)
  sprite.frame_time = sprite.frame_time + dt

  while sprite.frame_time >= sprite.frame_duration do
    sprite.frame_time = sprite.frame_time - sprite.frame_duration
    sprite.frame_index = sprite.frame_index + 1
    if sprite.frame_index > #sprite.frames then
      sprite.frame_index = 1
    end
  end
end

function M.load()
  local sprite_image = love.graphics.newImage("data/assets/images/slime.png")

  local sprite_width, sprite_height = sprite_image:getDimensions()

  local sprite_frames = {}
  for i = 1, math.floor(sprite_width / 32) do
    sprite_frames[i] = love.graphics.newQuad((i - 1) * 32, 0, 32, 32, sprite_width, sprite_height)
  end

  local slime = {
    position = vector2.new(400, 300),
    velocity = vector2.new(0, 0),
    speed = 100,
    frame_index = 1,
    frame_duration = 0.3,
    frame_time = 0,
    frames = sprite_frames,
    image = sprite_image,
    update = function(self, dt)
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

      sprite_animate(self, dt)
      sprite_move(self, dt)
    end,
    draw = sprite_draw,
  }
  table.insert(objects, 1, slime)

  local slime2 = {
    position = vector2.new(200, 400),
    velocity = vector2.new(50, 50),
    frame_index = 1,
    frame_duration = 0.3,
    frame_time = 0,
    frames = sprite_frames,
    image = sprite_image,
    update = function(self, dt)
      sprite_animate(self, dt)
      sprite_move(self, dt)
    end,
    draw = sprite_draw,
  }
  table.insert(objects, 1, slime2)

  local map = tilemap.new(
    {
      0, 0, 2, 2, 0, 0, 2, 2, 2, 0, 0, 0, 2, 2, 0, 0,
      0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0,
      0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 0,
      0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 0, 0,
      0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 0, 0,
      0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 0, 0,
      0, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 0,
      0, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 0,
      0, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
      0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
      0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
      0, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 0,
      0, 2, 2, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 2, 0,
      0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0,
      0, 0, 2, 2, 2, 2, 0, 2, 0, 2, 2, 2, 0, 1, 0, 0,
    },
    vector2.new(16, 15),
    tileset.new(
      love.graphics.newImage("data/assets/images/tiles.png"),
      vector2.new(32, 32)
    )
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
