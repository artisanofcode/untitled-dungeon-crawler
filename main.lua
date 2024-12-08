if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

love.filesystem.setRequirePath(
  "src/?.lua;src/?/init.lua;lib/?.lua;lib/?/init.lua;" ..
  love.filesystem.getRequirePath()
)

function love.load()
  GAME = require("crawler")
  GAME.load()
end

function love.update(dt)
  GAME.update(dt)
end

function love.draw()
  GAME.draw()
end
