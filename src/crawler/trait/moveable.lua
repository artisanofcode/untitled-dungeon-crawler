--- @module "crawler.engine"

local trait = require("src.crawler.trait.trait")

--- @class moveable
--- @field position vector2
--- @field velocity vector2
local M = {}

--- Add moveable trait to object
---
--- Updates the objects position based on velocity.
---
--- @param object table
--- @param position vector2
--- @param velocity vector2
function M.apply(object, position, velocity)
  object.position = position
  object.velocity = velocity

  trait.apply(object, M)
end

--- Update
---
--- Update the objects position based on velocity.
---
--- @param self moveable
--- @param dt number
function M.update(self, dt)
  self.position = self.position + (self.velocity * dt)
end

return M
