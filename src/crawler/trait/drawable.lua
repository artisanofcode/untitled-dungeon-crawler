--- @module "crawler.engine"

local trait = require("src.crawler.traits.trait")

--- @alias renderable { draw: fun(self: any, x: number, y: number): nil }

--- @class drawable
--- @field drawable renderable
--- @field position vector2
local M = {}

--- Add drawable trait to object
---
--- Draws the object to screen at given position
---
--- @param object table
--- @param drawable renderable
--- @param position vector2
function M.apply(object, drawable, position)
  object.drawable = drawable
  object.position = position

  trait.apply(object, M)
end

function M.draw(self)
  self.drawable:draw(self.position.x, self.position.y)
end

return M
