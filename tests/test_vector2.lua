local vector2 = require("crawler.engine.vector2")

local M = {}

function M.test_new_should_create_vector2()
  local v = vector2.new()

  assert(v.x == 0, "x not set correctly")
  assert(v.y == 0, "y not set correctly")
end

function M.test_new_should_create_vector2_with_components()
  local x, y = math.random(100), math.random(100)
  local v = vector2.new(x, y)

  assert(v.x == x, "x not set correctly")
  assert(v.y == y, "y not set correctly")
end

function M.test_isvector2_returns_true_for_vector()
  assert(vector2.isvector2(vector2.new()), "failed on empty vector2")
  assert(vector2.isvector2(vector2.new(1, 2)), "failed on integer vector2")
  assert(vector2.isvector2(vector2.new(0.1, 0.2)), "failed on number vector2")
end

function M.test_isvector2_returns_false_for_non_vector()
  assert(not vector2.isvector2("vector"), "failed on invalid vector2")
  assert(not vector2.isvector2(1), "failed on invalid vector2")
  assert(not vector2.isvector2({ x = 1, y = 2 }), "failed on invalid vector2")
end

function M.test_it_can_check_vector2_equality()
  local v = vector2.new(3, 5)
  local expected = vector2.new(2, 3)

  assert(vector2.new(1, 2) == vector2.new(1, 2), "invalid result")
  assert(vector2.new(1, 2) ~= vector2.new(2, 1), "invalid result")
end

function M.test_it_can_add_two_vector2s()
  local v1, v2 = vector2.new(1, 2), vector2.new(3, 4)
  local expected = vector2.new(4, 6)

  assert(v1 + v2 == expected, "invalid result")
end

function M.test_it_can_subtract_two_vector2s()
  local v1, v2 = vector2.new(1, 2), vector2.new(3, 4)
  local expected = vector2.new(-2, -2)

  assert(v1 - v2 == expected, "invalid result")
end

function M.test_it_can_multiply_two_vector2s()
  local v1, v2 = vector2.new(2, 3), vector2.new(4, 5)
  local expected = vector2.new(8, 15)

  assert(v1 * v2 == expected, "invalid result")
end

function M.test_it_can_divide_two_vector2s()
  local v1, v2 = vector2.new(6, 8), vector2.new(3, 2)
  local expected = vector2.new(2, 4)

  assert(v1 / v2 == expected, "invalid result")
end

function M.test_it_can_multiply_vector2_with_number()
  local v = vector2.new(2, 3)
  local expected = vector2.new(6, 9)

  assert(v * 3 == expected, "invalid result")

  assert(3 * v == expected, "invalid result")
end

function M.test_it_can_divide_vector2_with_number()
  local v = vector2.new(6, 9)
  local expected = vector2.new(2, 3)

  assert(v / 3 == expected, "invalid result")
  assert(3 / v == expected, "invalid result")
end

function M.test_angle_returns_vectors_angle_in_radians()
  assert(vector2.new(1, 0):angle() == 0)
  assert(vector2.new(0, 1):angle() == math.pi / 2)
  assert(vector2.new(-1, 0):angle() == math.pi)
  assert(vector2.new(0, -1):angle() == -math.pi / 2)
  assert(vector2.new(1, -1):angle() == -math.pi / 4)
end

function M.test_length_returns_vector_magnitude()
  assert(vector2.new(1, 0):length() == 1)
  assert(vector2.new(0, 1):length() == 1)
  assert(vector2.new(10, 0):length() == 10)
  assert(vector2.new(0, 10):length() == 10)
  assert(vector2.new(3, 4):length() == 5)
  assert(vector2.new(8, 6):length() == 10)
  assert(vector2.new(8, 6):length() == 10)
end

function M.test_lengthsquared_returns_vectors_magnitude_squared()
  assert(vector2.new(1, 0):lengthsquared() == 1)
  assert(vector2.new(0, 1):lengthsquared() == 1)
  assert(vector2.new(10, 0):lengthsquared() == 100)
  assert(vector2.new(0, 10):lengthsquared() == 100)
  assert(vector2.new(3, 4):lengthsquared() == 25)
  assert(vector2.new(8, 6):lengthsquared() == 100)
  assert(vector2.new(8, 6):lengthsquared() == 100)
end

function M.test_normalize_returns_vector_length_of_1()
  local v = vector2.new(3, 4)

  v:normalize()

  assert(math.abs(v:length() - 1) < 0.000001, "invalid length")
  assert(math.abs(v.x - (3 / 5)) < 0.000001, "invalid x component")
  assert(math.abs(v.y - (4 / 5)) < 0.000001, "invalid x component")
end

function M.test_normalize_returns_self()
  local v = vector2.new(math.random(100), math.random(100))

  assert(v == v:normalize())
end

function M.test_normalized_returns_vector_length_of_1()
  local v = vector2.new(3, 4)

  local v2 = v:normalized()

  assert(math.abs(v2:length() - 1) < 0.000001, "invalid length")
  assert(math.abs(v2.x - (3 / 5)) < 0.000001, "invalid x component")
  assert(math.abs(v2.y - (4 / 5)) < 0.000001, "invalid x component")
end

function M.test_normalized_returns_new_vector()
  local v = vector2.new(math.random(100), math.random(100))

  assert(v ~= v:normalized())
end

function M.test_unpack_returns_x_and_y_component()
  local v = vector2.new(math.random(100), math.random(100))

  local x, y = v:unpack()

  assert(v.x == x)
  assert(v.y == y)
end

return M
