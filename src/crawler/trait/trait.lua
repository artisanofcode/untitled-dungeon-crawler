local M = {}

--- Apply functions to object when not already present.
---
--- @param object table
--- @param trait table<string,any>
function M.apply(object, trait)
  for key, func in pairs(trait) do
    if not object[key] and type(func) == "function" then
      object[key] = func
    end
  end
end

return M
