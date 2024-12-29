local Function = {}
local FunctionMeta = { __index = Function }

function Function.new(parent, name, func)
  local self = {
    parent = parent,
    name = name,
    path = parent.path .. "#" .. name,
    func = func
  }

  return setmetatable(self, FunctionMeta)
end

function Function:collect() end

function Function:run(writer)
  local success, result = pcall(self.func)

  if success then
    result = nil
  end

  writer:add(
    self,
    self.name,
    self.path,
    self.func,
    success,
    result
  )
end

function Function:count()
  return 1
end

local File = {}
local FileMeta = { __index = File }

function File.new(parent, name)
  local self = {
    parent = parent,
    name = name,
    path = parent.path .. "/" .. name,
    children = {},
    chunk = nil
  }

  return setmetatable(self, FileMeta)
end

function File:collect()
  self.chunk = love.filesystem.load(self.path)()

  for k, v in pairs(self.chunk) do
    if k:match("^test_") then
      local item = Function.new(self, k, v)
      table.insert(self.children, item)
      item:collect()
    end
  end
end

function File:run(writer)
  for _, child in ipairs(self.children) do
    child:run(writer)
  end
end

function File:count()
  local count = 0

  for k, v in pairs(self.children) do
    count = count + v:count()
  end

  return count
end

local Directory = {}
local DirectoryMeta = { __index = Directory }

function Directory.new(parent, name)
  local pathname = name

  if parent then
    pathname = parent.path .. "/" .. pathname
  end

  local self = {
    parent = parent,
    name = name,
    path = pathname,
    children = {},
  }

  return setmetatable(self, DirectoryMeta)
end

function Directory:collect()
  for _, file in ipairs(love.filesystem.getDirectoryItems(self.path)) do
    local info = love.filesystem.getInfo(self.path .. "/" .. file)
    if info.type == "file" and file:match("^test_.+.lua$") then
      local item = File.new(self, file)
      table.insert(self.children, item)
      item:collect()
    elseif info.type == "directory" then
      local item = Directory.new(self, file)
      table.insert(self.children, item)
      item:collect()
    end
  end
end

function Directory:run(writer)
  for _, child in ipairs(self.children) do
    child:run(writer)
  end
end

function Directory:count()
  local count = 0

  for k, v in pairs(self.children) do
    count = count + v:count()
  end

  return count
end

local ReportWriter = {}
local ReportWriterMeta = { __index = ReportWriter }

function ReportWriter.new()
  local self = { items = {}, file = nil }

  return setmetatable(self, ReportWriterMeta)
end

function ReportWriter:write(...)
  io.write(...)
end

local function ansi(str)
  return string.char(27) .. "[" .. str .. "m"
end

function ReportWriter:add(node, name, path, func, success, error)
  local item = {
    node = node,
    name = name,
    path = path,
    func = func,
    success = success,
    error = error
  }


  if node.parent ~= self.parent then
    self:write("\n", node.parent.path, " ")
    self.parent = node.parent
  end

  if success then
    self:write(ansi(32) .. "." .. ansi(0))
  else
    self:write(ansi(31) .. "F" .. ansi(0))
  end

  table.insert(self.items, item)
end

function ReportWriter:heading(text)
  local length = 88 - 2 - #text

  self:write(string.rep("=", math.floor(length / 2)))
  self:write(" ", text, " ")
  self:write(string.rep("=", math.ceil(length / 2)))
  self:write("\n")
end

function ReportWriter:header(dir, count)
  self:heading("test suite")
  self:write("rootdir: ", dir, "\n")
  self:write(ansi(1) .. "collected ", count, " items" .. ansi(0) .. "\n")
end

function ReportWriter:footer()
  self:write("\n\n")

  local failed = 0
  local passed = 0

  for _, item in ipairs(self.items) do
    if not item.success then
      if failed == 0 then
        self:heading("FAILURES")
        self:write("\n")
      end
      self:write(ansi(31))
      self:heading(item.name)
      self:write(ansi(0))
      self:write("\n", item.error, "\n\n")
      failed = failed + 1
    else
      passed = passed + 1
    end
  end

  local color = 32
  local summary = ansi(32) .. passed .. " passed" .. ansi(0)
  local summary2 = passed .. " passed"

  if failed > 0 then
    summary = ansi(31) .. failed .. " failed" .. ansi(0) .. ", " .. summary
    summary2 = failed .. " failed" .. ", " .. summary2
    color = 31
  end


  local length = 88 - 2 - #summary2

  self:write(ansi(color), string.rep("=", math.floor(length / 2)), ansi(0))
  self:write(" ", summary, " ")
  self:write(ansi(color), string.rep("=", math.ceil(length / 2)), ansi(0))
  self:write("\n")
end

local Runner = {}
local RunnerMeta = { __index = Runner }

function Runner.new(factory)
  local self = {
    factory = factory or ReportWriter.new,
  }

  return setmetatable(self, RunnerMeta)
end

function Runner:run(dir)
  local writer = self.factory()

  local base = Directory.new(nil, "tests")

  base:collect()
  writer:header(dir, base:count())
  base:run(writer)
  writer:footer()
end

return Runner
