love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";vendor/?.lua")
--package.cpath = package.cpath .. "./?.so"
Controller = require 'controller'
local levels = require 'levels'
local lume = require 'lume'
local https = require 'https'


--local code, body = https.request("https://httpbin.org")
--print(body)

--local code, body, headers = https.request("https://gamebeta.futurerewards.co", {method="post", data="cake=1"})
--local code, body, headers = https.request("https://gamebeta.futurerewards.co", {method="post", data="cake"})
--local code, body, headers = https.request("https://httpbin.org/post", {method="post", data="cake"})
--print(code)
--print(body)
--print(headers)

local lg = love.graphics
local lp = love.physics

local level_number = 1

function love.load()
  package.cpath = package.cpath .. ';/Users/jiaaro/Library/Application Support/JetBrains/PyCharm2020.1/plugins/intellij-emmylua/classes/debugger/emmy/mac/?.dylib'
  local dbg = require('emmy_core')
  dbg.tcpListen('localhost', 9966)
  --dbg.waitIDE()

  screen_w, screen_h = love.window.getMode()
  controller = Controller(love.joystick.getJoysticks()[1])

  lp.setMeter(32) --the height of a meter our worlds will be 64px
  world = lp.newWorld(0, 9.81*32, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81

  objects = {}
  levels[level_number](world, objects)

  lg.setBackgroundColor(0,0,0)
end

local mouse_rotation = 0
function love.wheelmoved(x, y)
  mouse_rotation = mouse_rotation + (y / 15.0)
end

angle = 0
adamping = 0
function love.update(dt)
  controller:update(dt)
  local rotation = (controller.crankr.rotation_this_frame or 0) + mouse_rotation
  mouse_rotation = 0
  objects.wheel.body:setInertia(0)
  objects.wheel.body:setAngularVelocity(rotation/dt)
  world:update(dt)
end

function love.gamepadpressed(joystick, button )
  local level_to_load = level_number
  if button == "leftshoulder" then
    level_to_load = level_number - 1
  elseif button == "rightshoulder" then
    level_to_load = level_number + 1
  end
  level_to_load = math.min(math.max(level_to_load, 1), #levels)
  if level_to_load ~= level_number then
    level_number = level_to_load
    love.load()
  end
end

function love.keypressed(key)
  local os = love.system.getOS()
  local cmd;
  if os == "OS X" or os == "iOS" then
    cmd = love.keyboard.isDown("lgui", 'rgui')
  else
    cmd = love.keyboard.isDown('lctrl', 'rctrl')
  end

  if cmd and key == 'r' then
    love.load()
  end
end

function love.mousepressed(x, y)
end

function love.draw()
  --controller:draw(screen_w, screen_h)

  lg.setColor(1,1,1)

  for name, obj in pairs(objects) do
    if name ~= "player" and obj.draw then
      obj:draw()
    end
  end
  objects.player:draw()

  lg.setColor(1, 1, 1)
  --lg.print("Instructions: Hook up a DualShock and rotate the\nright analog stick to turn the wheel", 30, 5)
end
