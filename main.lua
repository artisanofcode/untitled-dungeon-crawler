if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

love.filesystem.setRequirePath(
  "src/?.lua;src/?/init.lua;lib/?.lua;lib/?/init.lua;" ..
  love.filesystem.getRequirePath()
)

function love.load(args)
  for _, arg in ipairs(args) do
    if arg == "--test" then
      local runner = require("tests.runtime").new()
      runner:run("tests")
      os.exit(0)
    end
  end

  GAME = require("crawler")
  GAME.load()
end

function love.update(dt)
  GAME.update(dt)
end

function love.draw()
  GAME.draw()
end
