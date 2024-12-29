local vector2 = require("crawler.engine.vector2")
local animation = require("crawler.engine.animation")

local M = {}

--- Slime Factory
---
--- @param name string
--- @param atlas textureatlas
--- @param x number
--- @param y number
--- @return { animation: animation,  speed: number, position: vector2, velocity: vector2}
function M.new(name, atlas, x, y)
  return {
    animation = animation.new(
      atlas,
      {
        { index = 1, duration = 0.3 },
        { index = 2, duration = 0.4 },
        { index = 1, duration = 0.2 },
        { index = 2, duration = 0.1 },
      }
    ),
    speed = 100,
    position = vector2.new(x, y),
    velocity = vector2.new(50, 50),
  }
end

return M
