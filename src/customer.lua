local lp = love.physics
local lg = love.graphics
local lume = require 'lume'
require 'level_utils'

return function(world, objects, x, y)
  local customer = {
    body = lp.newBody(world, x, y, "dynamic"),
    shape = lp.newRectangleShape(0, 0, 26, 40),
  }
  customer.fixture = lp.newFixture(customer.body, customer.shape, 1)

  local stool = {
    body = lp.newBody(world, x-2, y + 30, "dynamic"),
    shape = lp.newRectangleShape(0, 0, 22, 16),
  }
  stool.fixture = lp.newFixture(stool.body, stool.shape, 1)

  function customer:draw()
    local cx, cy = self.body:getWorldPoints(self.shape:getPoints())
    lg.push()
    lg.translate(cx, cy)

    lg.setColor(1,1,1)
    -- head
    lg.rectangle('fill', 3, 0, 22, 14)

    -- neck
    lg.rectangle('fill', 7, 15, 15, 1)
    lg.rectangle('fill', 7, 17, 15, 1)

    -- body
    lg.rectangle('fill', 2, 19, 24, 15)

    -- feet
    lg.rectangle('fill', 0, 35, 11, 4)
    lg.rectangle('fill', 15, 35, 11, 4)

    lg.setColor(0,0,0)

    -- eyes
    lg.rectangle('fill', 6, 2, 3, 3)
    lg.rectangle('fill', 15, 2, 3, 3)
    -- mouth
    lg.rectangle('fill', 8, 10, 11, 1)
    lg.rectangle('fill', 8, 12, 11, 1)

    lg.rectangle('fill', 8, 11, 1, 1)
    lg.rectangle('fill', 10, 11, 1, 1)
    lg.rectangle('fill', 12, 11, 1, 1)
    lg.rectangle('fill', 14, 11, 1, 1)
    lg.rectangle('fill', 18, 11, 1, 1)

    -- buttons
    lg.rectangle('fill', 13, 21, 2, 2)
    lg.rectangle('fill', 13, 25, 2, 2)
    lg.rectangle('fill', 13, 29, 2, 2)

    lg.pop()
    lg.setColor(1,1,1)
  end

  function stool:draw()
    local cx, cy = self.body:getWorldPoints(self.shape:getPoints())
    lg.push()
    lg.translate(cx, cy)
    lg.rectangle('fill', 0, 0, 26, 5)
    lg.polygon('fill', 4, 0, 10, 0, 4, 15, 2, 15)
    lg.polygon('fill', 22, 0, 16, 0, 22, 15, 24, 15)

    lg.pop()
  end

  objects.customer = customer
  objects.stool = stool
end
