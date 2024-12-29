--- Message Bus
---
--- Implementation of the command dispatcher pattern.
---
--- @class messagebus
--- @field objects any[]
--- @field handlers table<string, { traits: string[], callback: fun(obj: any, param: any)}[]>
local M = {}
local MT = { __index = M }

--- Message Bus Factory
---
--- @return messagebus
function M.new()
  local self = { objects = {}, handlers = {} }

  return setmetatable(self, MT)
end

--- Register Game Object with Message Bus
--- @param self messagebus
---
--- @param object any
function M.register(self, object)
  table.insert(self.objects, object)
end

--- Register Handler with Message Bus
---
--- @param self messagebus
--- @param event string
--- @param traits string[]
--- @param callback fun(obj: any, param: any)
function M.on(self, event, traits, callback)
  if self.handlers[event] == nil then
    self.handlers[event] = {}
  end

  table.insert(self.handlers[event], {
    traits = traits,
    callback = callback
  })
end

--- Triggers Handlers
---
--- @param self messagebus
--- @param event string
--- @param param any
function M.trigger(self, event, param)
  if self.handlers[event] == nil then
    return
  end

  for _, object in ipairs(self.objects) do
    for _, item in ipairs(self.handlers[event]) do
      local matches = true
      for _, trait in ipairs(item.traits) do
        if object[trait] == nil then
          matches = false
          break
        end
      end

      if matches then
        item.callback(object, param)
      end
    end
  end
end

--- Trigger Update Handlers
---
--- Shortcut for "update" event
---
--- @param self messagebus
--- @param dt number
function M.update(self, dt)
  self:trigger("update", dt)
end

--- Trigger Draw Handlers
---
--- Shortcut for the "draw" event
---
--- @param self messagebus
function M.draw(self)
  self:trigger("draw", nil)
end

return M
