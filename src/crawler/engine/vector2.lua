local M = {}

M.__index = M

-- module functions

function M.new(x, y)
  local self = { x = x, y = y }

  return setmetatable(self, M)
end

function M.isvector2(value)
  return getmetatable(value) == M
end

-- meta functions

function M.__add(a, b)
  return M.new(a.x + b.x, a.y + b.y)
end

function M.__sub(a, b)
  return M.new(a.x - b.x, a.y - b.y)
end

function M.__mul(a, b)
  if type(b) == "number" then
    return M.new(a.x * b, a.y * b)
  end

  if M.isvector2(b) then
    return M.new(a.x * b.x, a.y * b.y)
  end

  error("vector2 can only be multiplied by number or vector2")
end

function M.__div(a, b)
  if type(b) == "number" then
    return M.new(a.x / b, a.y / b)
  end

  if M.isvector2(b) then
    return M.new(a.x / b.x, a.y / b.y)
  end

  error("vector2 can only be divided by number or vector2")
end

function M.__eq(a, b)
  return a.x == b.x and a.y == b.y
end

-- vector functions

function M.normalized(self)
  -- normalize the length of a vector to 1
  local copy = M.new(self.x, self.y)

  return copy:normalize()
end

function M.normalize(self)
  if self.x == 0 and self.y == 0 then
    return self
  end

  local length = math.sqrt(self.x ^ 2 + self.y ^ 2)

  self.x = self.x / length
  self.y = self.y / length

  return self
end

function M.unpack(self)
  return self.x, self.y
end

return M
