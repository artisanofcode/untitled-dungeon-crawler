--- A 2D vector using fractional coordinates.
---
--- @class vector2
--- @field x number the vectors X component
--- @field y number the vectors Y component
local M = {}

M.__index = M

--- 2D Vector Factory.
---
--- Construct a new vector2 instance.
---
--- @param x number the vectors X component
--- @param y number the vectors Y component
---
--- @return vector2 v a vector instance
function M.new(x, y)
  local self = { x = x, y = y }

  return setmetatable(self, M)
end

--- Check type is 2D Vector.
---
--- @param value any
---
--- @return boolean
function M.isvector2(value)
  return getmetatable(value) == M
end

--- Add Vectors.
---
--- This is the same as `new(a.x + b.x, a.y + b.y)`.
---
--- @param a vector2
--- @param b vector2
---
--- @return vector2
function M.__add(a, b)
  return M.new(a.x + b.x, a.y + b.y)
end

--- Subtract Vectors.
---
--- This is the same as `new(a.x - b.x, a.y - b.y)`.
---
--- @param a any
--- @param b any
---
--- @return vector2
function M.__sub(a, b)
  return M.new(a.x - b.x, a.y - b.y)
end

--- Multiply Vectors.
---
--- This is the same as `new(a.x * b.x, a.y * b.y)` or `new(a.x * b, a.y * b)`.
---
--- @param a vector2
--- @param b vector2 | number
---
--- @return vector2
function M.__mul(a, b)
  if type(b) == "number" then
    return M.new(a.x * b, a.y * b)
  end

  if M.isvector2(b) then
    return M.new(a.x * b.x, a.y * b.y)
  end

  error("vector2 can only be multiplied by number or vector2")
end

--- Divide Vectors.
---
--- This is the same as `new(a.x / b.x, a.y / b.y)` or `new(a.x / b, a.y / b)`.
---
--- @param a vector2
--- @param b vector2 | number
---
--- @return vector2
function M.__div(a, b)
  if type(b) == "number" then
    return M.new(a.x / b, a.y / b)
  end

  if M.isvector2(b) then
    return M.new(a.x / b.x, a.y / b.y)
  end

  error("vector2 can only be divided by number or vector2")
end

--- Compare Vectors Equality.
---
--- This is the same as `(a.x == b.x and a.y == b.y)`.
---
--- @param a vector2
--- @param b vector2 | number
---
--- @return boolean
function M.__eq(a, b)
  return a.x == b.x and a.y == b.y
end

--- Normalized Vector.
---
--- Normalize the vector to a length of 1 while preserving the angle..
---
--- @param self vector2
---
--- @return vector2
function M.normalized(self)
  -- normalize the length of a vector to 1
  local copy = M.new(self.x, self.y)

  return copy:normalize()
end

--- Normalize Vector.
---
--- Normalize vector in-place to a length of 1 while preserving the angle and return
--- self.
---
--- @param self vector2
---
--- @return vector2
function M.normalize(self)
  if self.x == 0 and self.y == 0 then
    return self
  end

  local length = math.sqrt(self.x ^ 2 + self.y ^ 2)

  self.x = self.x / length
  self.y = self.y / length

  return self
end

--- Unpack Components
---
--- @param self vector2
---
--- @return number x, number y the vectors X and Y components
function M.unpack(self)
  return self.x, self.y
end

return M
