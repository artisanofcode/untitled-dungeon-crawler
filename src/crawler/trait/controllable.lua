local trait = require("src.crawler.traits.trait")
local moveable = require("crawler.traits.moveable")

local engine = require("crawler.engine")

--- @class controllable: moveable
--- @field speed number
local M = {}

--- Add controllable trait to object
---
--- Extends moveable trait to set velocity via user input.
---
--- @param object table
--- @param position vector2
--- @param velocity vector2
--- @param speed number
function M.apply(object, position, velocity, speed)
  moveable.apply(object, position, velocity)

  object.speed = speed

  trait.apply(object, M)
end

--- Update
---
--- Set velocity based on user input and call
--- parent update method.
---
--- @param self controllable
--- @param dt number
function M.update(self, dt)
  local velocity = engine.vector2.new(0, 0)

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

  moveable.update(self, dt)
end

return M
