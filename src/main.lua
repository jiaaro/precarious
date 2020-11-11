love.filesystem.setRequirePath(love.filesystem.getRequirePath() .. ";vendor/?.lua")
--package.cpath = package.cpath .. "./?.so"
Controller = require 'controller'
levels = require 'levels'
local lume = require 'lume'
--local https = require 'https'
local flux = require "flux"

require 'inputevents'

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

level_number = 1

local instructions_font
local has_moved = false
local level_complete = false

local draw_stack = {}
local update_stack = {}
function update_draw_stack()
  local drawables = {}
  update_stack = {}
  for name, obj in pairs(objects) do
    if obj.draw then
      drawables[#drawables+1] = obj
    end
    if obj.update then
      update_stack[#update_stack+1] = obj
    end
  end
  draw_stack = lume.sort(drawables, function(a, b)
    return (a.zindex or 0) < (b.zindex or 0)
  end)
end

function love.load()
  package.cpath = package.cpath .. ';/Users/jiaaro/Library/Application Support/JetBrains/PyCharm2020.1/plugins/intellij-emmylua/classes/debugger/emmy/mac/?.dylib'
  local dbg = require('emmy_core')
  dbg.tcpListen('localhost', 9966)
  --dbg.waitIDE()
  lg.setDefaultFilter('nearest', 'nearest')
  level_complete = false
  has_moved = false
  instructions_font = love.graphics.newFont(20, 'mono')

  screen_w, screen_h = love.window.getMode()
  controller = Controller(love.joystick.getJoysticks()[1])

  lp.setMeter(32) --the height of a meter our worlds will be 64px
  world = lp.newWorld(0, 9.81*32, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81

  objects = {}
  levels[level_number](world, objects)

  lg.setBackgroundColor(0,0,0)
  update_draw_stack()
end

local mouse_rotation = 0
function love.wheelmoved(x, y)
  mouse_rotation = mouse_rotation + (y / 15.0)
end

help_text_state = 0
help_text = ""
function mk_help_text()
  local prev_help_text_state = _G.help_text_state
  local try_again = {"try again", "retry", "give it another go", "get back on the horse", "take another stab", "keep trying", "keep your job", "quit slacking off", "get back to it"}
  local help_text = ""
  if not has_moved then
    help_text_state = "didntmove"
    help_text = "Turn crank, scroll wheel, or rotate\nright analog stick to " .. lume.randomchoice({
      "move", "turn wheel", "roll"
    })
  elseif level_complete then
    help_text_state = "levelcomplete"
    help_text = "Nice Job! B/space to continue"
  elseif objects.customer.wasBumped then
    help_text_state = "customerbumped"
    help_text = "RUDE! b/space to " .. lume.randomchoice(try_again)
  elseif objects.player:fellDown() then
    help_text_state = "felldown"
    help_text = "b/space to " .. lume.randomchoice(try_again)
  elseif objects.drink.dropped then
    help_text_state = "droppeddrink"
    help_text = "b/space to " .. lume.randomchoice(try_again)
  elseif objects.player:distanceToDrink() <= objects.drink.pickup_distance then
    help_text_state = "canpickup"
    help_text = "left/right (or wasd) to " .. lume.randomchoice({
      "pick up ", "get ", "grab ",
    }) .. lume.randomchoice({"drink", "order", "martini"})
  elseif objects.drink:isTouchingTable() then
    help_text_state = "drinkplaced"
    help_text = lume.randomchoice({
      "Stop bothering the customer!",
      "Give 'em some space!",
      "Let the bot drink in peace!",
      "That drink is best enjoyed alone",
      "The bot didn't come for conversation"
    })
  elseif objects.drink.player_hand_joint and objects.drink:distanceToTable() < 100 then
    help_text_state = "closetotablewithdrink"
    help_text = "down (or wasd) to " .. lume.randomchoice({
      "put down drink",
      "serve drink",
    })
  elseif objects.drink.player_hand_joint and objects.drink.handx < 0 then
    help_text_state = "canswitchhands"
    help_text = "left/right (or wasd) to " .. lume.randomchoice({
      "switch hands",
    })
  elseif objects.drink.player_hand_joint and objects.drink.handx >= 0 then
    help_text_state = "customerwaiting"
    help_text = "The customer is waiting . . ."
  end

  if help_text_state ~= prev_help_text_state then
    _G.help_text = help_text
  end
end

angle = 0
adamping = 0
function love.update(dt)
  controller:update(dt)
  flux.update(dt)
  for i = 1, #update_stack do
    update_stack[i]:update(dt)
  end

  local rotation = (controller.crankr.rotation_this_frame or 0) + mouse_rotation
  mouse_rotation = 0
  if rotation ~= 0 then
    has_moved = true
  end
  objects.wheel.body:setInertia(0)
  objects.wheel.body:setAngularVelocity(rotation/dt)
  world:update(dt)

  if level_complete == false and objects.drink:isTouchingTable() and objects.player.body:getX() < 80 then
    level_complete = true
    level_number = math.min(math.max(level_number + 1, 1), #levels)
  end
  if math.abs(objects.player.body:getAngle()) > math.pi / 3 then
    objects.drink:drop()
  end

  mk_help_text()
end

function love.draw()
  --controller:draw(screen_w, screen_h)

  lg.setColor(1,1,1)

  for i=1,#draw_stack do
    draw_stack[i]:draw()
  end

  lg.setColor(1, 1, 1)

  lg.print(help_text, instructions_font, 10, 6)
end
