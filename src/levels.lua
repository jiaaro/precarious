local lp = love.physics
local lg = love.graphics
local lume = require 'lume'
local make_customer = require 'customer'
require 'level_utils'
local make_player = require 'player'

function flat(world, objects)
  make_base_level(world, objects)
  make_hightop(world, objects, 300, 180)
  make_customer(world, objects, 375, 180)
  make_player(world, objects, 75, 160)
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

  make_hightop(world, objects, 300, 155)
  make_customer(world, objects, 375, 155)
  make_player(world, objects, 75, 160)
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

  make_hightop(world, objects, 300, 155)
  make_customer(world, objects, 375, 155)
  make_player(world, objects, 75, 160)
end

return {
  flat,
  ramp,
  stairs
}
