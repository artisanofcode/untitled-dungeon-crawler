--- @module "crawler.engine"

local trait = require("src.crawler.trait.trait")
local drawable = require("crawler.trait.drawable")

--- @class animatable: drawable
---
--- @field drawable animation
local M = {}

--- Add animatable trait to object
---
--- Extends the drawable trait to add animation.
---
--- @param object table
--- @param animation animation
--- @param position vector2
function M.apply(object, animation, position)
  drawable.apply(object, animation, position)

  trait.apply(object, M)
end

function M.update(self, dt)
  self.drawable:update(dt)
end

return M
