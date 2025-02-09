--- A 2D vector using fractional coordinates.
---
--- @class vector2
--- @field x number the vectors X component
--- @field y number the vectors Y component
---
--- @operator add(vector2): vector2
--- @operator sub(vector2): vector2
--- @operator mul(vector2): vector2
--- @operator div(vector2): vector2
--- @operator mul(number): vector2
--- @operator div(number): vector2
--- @operator unm: vector2
local M = {}

--- Meta-table for vector2 class
local MT = { __index = M }


--- 2D Vector Factory.
---
--- Construct a new vector2 instance.
---
--- @param x? number the vectors X component
--- @param y? number the vectors Y component
---
--- @return vector2 v a vector instance
function M.new(x, y)
  local self = { x = x or 0, y = y or 0 }

  return setmetatable(self, MT)
end

--- Check type is 2D Vector.
---
--- @param value any
---
--- @return boolean
--- @nodiscard
function M.isvector2(value)
  return getmetatable(value) == MT
end

--- Add Vectors.
---
--- This is the same as `new(a.x + b.x, a.y + b.y)`.
---
--- @param a vector2
--- @param b vector2
---
--- @return vector2
function MT.__add(a, b)
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
function MT.__sub(a, b)
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
function MT.__mul(a, b)
  if type(b) == "number" then
    return M.new(a.x * b, a.y * b)
  end

  if type(a) == "number" then
    return M.new(b.x * a, b.y * a)
  end
  if M.isvector2(a) and M.isvector2(b) then
    return M.new(a.x * b.x, a.y * b.y)
  end

  error("vector2 can only be multiplied by number or vector2")
end

--- Divide Vectors.
---
--- This is the same as `new(a.x / b.x, a.y / b.y)` or `new(a.x / b, a.y / b)`.
---
--- @param a vector2 | number
--- @param b vector2 | number
---
--- @return vector2
function MT.__div(a, b)
  if type(b) == "number" then
    return M.new(a.x / b, a.y / b)
  end
  if type(a) == "number" then
    return M.new(b.x / a, b.y / a)
  end

  if M.isvector2(a) and M.isvector2(b) then
    return M.new(a.x / b.x, a.y / b.y)
  end

  error("vector2 can only be divided by number or vector2")
end

--- Negate Vector
---
--- @param a vector2
--- @return vector2
function MT.__unm(a)
  return M.new(-a.x, -a.y)
end

--- Compare Vectors Equality.
---
--- This is the same as `(a.x == b.x and a.y == b.y)`.
---
--- @param a vector2
--- @param b vector2 | number
---
--- @return boolean
function MT.__eq(a, b)
  return a.x == b.x and a.y == b.y
end

--- Convert to String
---
--- @param self vector2
---
--- @return string str
function MT.__tostring(self)
  return "(" .. self.x .. ", " .. self.y .. ")"
end

--- Clamp Vector
---
--- Constrain vector components in-place to be within the range of the min and max
--- vectors, and return self.
---
--- @param self vector2
--- @param min vector2 minimum vector
--- @param max vector2 maximum vector
--- @return vector2
function M.clamp(self, min, max)
  self.x = math.min(max.x, math.max(min.x, self.x))
  self.y = math.min(max.y, math.max(min.y, self.y))

  return self
end

--- Clamped Vector
---
--- Constrain vector components to be within the range of the min and max vectors.
---
--- @param self vector2
--- @param min vector2 minimum vector
--- @param max vector2 maximum vector
--- @return vector2
function M.clamped(self, min, max)
  local copy = M.new(self.x, self.y)

  return copy:clamp(min, max)
end

--- Normalized Vector.
---
--- Normalize the vector to a length of 1 while preserving the angle.
---
--- @param self vector2
---
--- @return vector2
--- @nodiscard
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

  local length = self:length()

  self.x = self.x / length
  self.y = self.y / length

  return self
end

--- Floored Vector
---
--- Round vector components to the largest integral value smaller than or equal to the
--- existing value.
---
--- @param self vector2
--- @return vector2
function M.floored(self)
  local copy = M.new(self.x, self.y)

  return copy:floor()
end

--- Floor Vector
---
--- Round vector components in-place to the largest integral value smaller than or equal
--- to the existing value, and return self.
---
--- @param self vector2
--- @return vector2
function M.floor(self)
  self.x = math.floor(self.x)
  self.y = math.floor(self.y)

  return self
end

--- Round
---
--- Round a number to nearest integral value.
---
--- @param x number
---
--- @return integer
local function round(x)
  if x >= 0 then
    return math.floor(x + 0.5)
  else
    return math.ceil(x - 0.5)
  end
end

--- Rounded Vector
---
--- Round vector components to the nearest integral value.
---
--- @param self vector2
--- @return vector2
function M.rounded(self)
  local copy = M.new(self.x, self.y)

  return copy:round()
end

--- Round Vector
---
--- Round vector components in-place to the nearest integral value, and return self.
---
--- @param self vector2
--- @return vector2
function M.round(self)
  self.x = round(self.x)
  self.y = round(self.y)

  return self
end

--- Vector Angle
---
--- Returns the vectors angle from the positive X axis in radians.
---
--- @param self vector2
---
--- @return number
function M.angle(self)
  return math.atan2(self.y, self.x)
end

--- Vector Length.
---
--- Returns the length (magnitude) of the vector.
---
--- @param self vector2
---
--- @return number
function M.length(self)
  return math.sqrt(self:lengthsquared())
end

--- Vector Length Squared.
---
--- Returns the squared length (squared magnitude) of the vector.
---
--- This is faster than length things like for comparison.
---
--- @param self vector2
---
--- @return number
function M.lengthsquared(self)
  return self.x ^ 2 + self.y ^ 2
end

--- Unpack Components
---
--- @param self vector2
---
--- @return number x, number y the vectors X and Y components
--- @nodiscard
function M.unpack(self)
  return self.x, self.y
end

return M
