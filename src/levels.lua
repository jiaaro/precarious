local lp = love.physics
local lg = love.graphics
local lume = require 'lume'
require 'level_utils'

local make_customer = require 'customer'
local make_player = require 'player'
local make_drink = require 'drink'

-- reusable text
local t_try_again = { "try again", "retry", "give it another go", "get back on the horse", "take another stab", "keep trying", "keep your job", "quit slacking off", "get back to it"}
local t_move = { "move", "turn wheel", "roll"}
local t_get = { "pick up ", "get ", "grab "}
local t_drink = { "drink", "order", "martini"}

function flat(world, objects)
  make_base_level(world, objects)
  make_hightop(world, objects, 300, 180)
  make_customer(world, objects, 375, 180)
  make_drink(world, objects, 15, 100)
  make_player(world, objects, 75, 160)
  make_help_text(world, objects, function()
    if not has_moved then
      return "didntmove", "Turn crank, scroll wheel, or rotate\nright analog stick to " .. lume.randomchoice(t_move)
    elseif level_complete then
      return "levelcomplete", "Nice Job! B/space to continue"
    elseif objects.customer.wasBumped then
      return "customerbumped", "RUDE! b/space to " .. lume.randomchoice(t_try_again)
    elseif objects.player:fellDown() then
      return "felldown", "b/space to " .. lume.randomchoice(t_try_again)
    elseif objects.drink.dropped then
      return "droppeddrink", "b/space to " .. lume.randomchoice(t_try_again)
    elseif objects.player:distanceToDrink() <= objects.drink.pickup_distance then
      return "canpickup", "left/right (or wasd) to " .. lume.randomchoice(t_get) .. lume.randomchoice(t_drink)
    elseif objects.drink:isTouchingTable() then
      return "drinkplaced", lume.randomchoice({
        "Get back to bar!",
        "You're needed at the bar",
        "Stop bothering the customer!",
        "Give 'em some space!",
        "Let the bot drink in peace!",
        "That drink is best enjoyed alone",
        "The bot didn't come for conversation"
      })
    elseif objects.drink.player_hand_joint and objects.drink:distanceToTable() < 100 then
      return "closetotablewithdrink", "down (or wasd) to " .. lume.randomchoice({
        "put down drink",
        "serve drink",
      })
    elseif objects.drink.player_hand_joint and objects.drink.handx < 0 then
      return "canswitchhands", "left/right (or wasd) to " .. lume.randomchoice({
        "switch hands",
        "move drink"
      })
    elseif objects.drink.player_hand_joint and objects.drink.handx >= 0 then
      return "customerwaiting", "The customer is waiting . . ."
    end
  end)
end

function ramp(world, objects)
  make_base_level(world, objects)
  local ramp = {
    draw = filldraw,
    body = lp.newBody(world, 145, screen_h - 45),
    shape = lp.newPolygonShape(0, 30, 125, 0, 125, 30),
  }
  ramp.fixture = lp.newFixture(ramp.body, ramp.shape, 1)
  ramp.fixture:setFriction(10)

  objects.ramp = ramp

  local platform = {
    draw = filldraw,
    body = lp.newBody(world, 340, screen_h - 30),
    shape = lp.newRectangleShape(0, 0, 140, 30),
  }
  platform.fixture = lp.newFixture(platform.body, platform.shape, 1)
  platform.fixture:setFriction(10)
  objects.platform = platform

  make_drink(world, objects, 15, 100)
  make_hightop(world, objects, 300, 155)
  make_customer(world, objects, 375, 155)
  make_player(world, objects, 75, 160)
  make_help_text(world, objects, function()
    if t < 5 then
      return "levelbanner", "Mr. Bot wanted a better view"
    elseif level_complete then
      return "levelcomplete", "Nice Job! B/space to continue"
    elseif objects.customer.wasBumped then
      return "customerbumped", "RUDE! b/space to " .. lume.randomchoice(t_try_again)
    elseif objects.player:fellDown() then
      return "felldown", "b/space to " .. lume.randomchoice(t_try_again)
    elseif objects.drink.dropped then
      return "droppeddrink", "b/space to " .. lume.randomchoice(t_try_again)
    elseif objects.drink:isTouchingTable() then
      return "drinkplaced", lume.randomchoice({
        "Get back to bar!",
        "You're needed at the bar",
        "Stop bothering the customer!",
        "Give 'em some space!",
        "Let the bot drink in peace!",
        "That drink is best enjoyed alone",
        "The bot didn't come for conversation"
      })
    else
      return "levelbanner", lume.randomchoice({
        "Grab that drink and go",
        "You can do this",
        "Roll out!",
        "Don't forget the drink",
        "Mr. Bot: Waiter! I'll have a Martini"
      })
    end
  end)
end

function stairs(world, objects)
  make_base_level(world, objects)
  local step
  for i = 1, 4 do
    step = {
      draw = filldraw,
      body = lp.newBody(world, 135 + (i * 25), screen_h - 5 - (5 * i)),
      shape = lp.newRectangleShape(0, 0, 25, 30),
    }
    step.fixture = lp.newFixture(step.body, step.shape, 1)
    step.fixture:setFriction(10)

    objects[("step%i"):format(i)] = step
  end

  local platform = {
    draw = filldraw,
    body = lp.newBody(world, 330, screen_h - 30),
    shape = lp.newRectangleShape(0, 0, 165, 30),
  }
  platform.fixture = lp.newFixture(platform.body, platform.shape, 1)
  platform.fixture:setFriction(10)
  objects.platform = platform

  make_drink(world, objects, 15, 100)
  make_hightop(world, objects, 300, 155)
  make_customer(world, objects, 375, 155)
  make_player(world, objects, 75, 160)
  make_help_text(world, objects, function()
    if t < 5 then
      return "levelbanner", "How about some stairs, wheels-for-feet?"
    elseif level_complete then
      return "levelcomplete", "Nice Job! B/space to continue"
    elseif objects.customer.wasBumped then
      return "customerbumped", "Watch it you clutz! b/space to " .. lume.randomchoice(t_try_again)
    elseif objects.player:fellDown() then
      return "felldown", "b/space to " .. lume.randomchoice(t_try_again)
    elseif objects.drink.dropped then
      return "droppeddrink", "b/space to " .. lume.randomchoice(t_try_again)
    elseif objects.drink:isTouchingTable() then
      return "drinkplaced", lume.randomchoice({
        "Get back to bar!",
        "You're needed at the bar",
        "Stop bothering the customer!",
        "Give 'em some space!",
        "Let the bot drink in peace!",
        "That drink is best enjoyed alone",
        "The bot didn't come for conversation"
      })
    else
      return "levelbanner", lume.randomchoice({
        "What are you waiting for?",
        "Do you want this job or not?",
        "The Customer is waiting",
        "Mr. Bot is not a patient bot",
        "Get rolling",
        "Afraid of a few stairs?",
        "Mr. Bot: Maybe you need a square wheel! Ha!",
        "Mr. Bot: Let's go, Round-foot!",
      })
    end
  end)
end

return {
  flat,
  ramp,
  stairs
}
