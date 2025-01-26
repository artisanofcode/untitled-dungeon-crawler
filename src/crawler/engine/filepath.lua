local M = {}

--- Logical parent of the path
---
--- @param path string
--- @return string
function M.parent(path)
  local result = path:match("(.+)/")

  if not result then
    if path:sub(1, 1) == "/" then
      result = "/"
    else
      result = "."
    end
  end

  return result
end

--- Resolve path
---
--- Resolve relative parts of the path, removes all `..` sections
---
--- @param path string
---
--- @return string
function M.resolve(path)
  local parts = {}

  for part in path:gsub("/+", "/"):gmatch("([^/]+)") do
    if part == ".." then
      table.remove(parts)
    else
      table.insert(parts, part)
    end
  end

  return M.join(unpack(parts))
end

--- Join paths
---
--- @param path string
--- @param ... string additional paths
---
--- @return string
function M.join(path, ...)
  for _, part in ipairs({ ... }) do
    path = path .. "/" .. part
  end

  return path
end

return M
