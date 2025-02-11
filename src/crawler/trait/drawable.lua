--- @module "crawler.engine"

local trait = require("src.crawler.trait.trait")

--- @alias renderable {
---   draw: fun(
---     self: any,
---     x: number,
---     y: number,
---     r?: number,
---     sx?: number,
---     sy?: number,
---     ox?: number,
---     oy?: number): nil}

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
  local position = self.position:rounded()
  self.drawable:draw(position.x, position.y, nil, nil, nil, 16, 16)
end

return M
