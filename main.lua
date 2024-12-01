-- enable the debugger
if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
  require("lldebugger").start()
end

objects = {}

map = {
  { 0, 0, 2, 2, 0, 0, 2, 2, 2, 0, 0, 0, 2, 2, 0, 0 },
  { 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0 },
  { 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 0 },
  { 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 0, 0 },
  { 0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 0, 0 },
  { 0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 0, 0 },
  { 0, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 0 },
  { 0, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 0 },
  { 0, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
  { 0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
  { 0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 },
  { 0, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 0 },
  { 0, 2, 2, 1, 1, 2, 2, 2, 2, 1, 1, 1, 1, 1, 2, 0 },
  { 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0 },
  { 0, 0, 2, 2, 2, 2, 0, 2, 0, 2, 2, 2, 0, 1, 0, 0 },
}

tiles = {}

function sprite_draw(sprite)
  love.graphics.draw(sprite.image, sprite.position.x, sprite.position.y)
end

function sprite_move(sprite, dt)
  sprite.position.x = sprite.position.x + sprite.velocity.x * dt
  sprite.position.y = sprite.position.y + sprite.velocity.y * dt
end

function love.load()
  -- startup tasks
  slime = {
    position = { x = 400, y = 300 },
    velocity = { x = 0, y = 0 },
    speed = 100,
    image = love.graphics.newImage("data/assets/images/slime.png"),
    update = function(self, dt)
      self.velocity.x = 0
      self.velocity.y = 0

      if love.keyboard.isDown("w") then
        self.velocity.y = self.velocity.y - self.speed
      end

      if love.keyboard.isDown("a") then
        self.velocity.x = self.velocity.x - self.speed
      end

      if love.keyboard.isDown("s") then
        self.velocity.y = self.velocity.y + self.speed
      end

      if love.keyboard.isDown("d") then
        self.velocity.x = self.velocity.x + self.speed
      end

      sprite_move(self, dt)
    end,
    draw = sprite_draw,
  }
  table.insert(objects, slime)

  slime2 = {
    position = { x = 200, y = 400 },
    velocity = { x = 50, y = 50 },
    image = love.graphics.newImage("data/assets/images/slime.png"),
    update = sprite_move,
    draw = sprite_draw,
  }
  table.insert(objects, slime2)

  tileset = love.graphics.newImage("data/assets/images/tiles.png")

  width, height = tileset:getDimensions()

  for i = 1, math.floor(width / 32) do
    tiles[i] = love.graphics.newQuad((i - 1) * 32, 0, 32, 32, tileset)
  end
end

function love.update(dt)
  -- updating the state of the game
  for _, object in ipairs(objects) do
    if object.update then
      object:update(dt)
    end
  end
end

function love.draw()
  -- draw things to the screen
  for y, row in ipairs(map) do
    for x, tile in ipairs(row) do
      if tile > 0 then
        love.graphics.draw(tileset, tiles[tile], (x - 1) * 32, (y - 1) * 32)
      end
    end
  end

  for _, object in ipairs(objects) do
    if object.draw then
      object:draw()
    end
  end
end
