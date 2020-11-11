local lume = require 'lume'
local flux = require "flux"
local lp = love.physics
local lg = love.graphics


---@return Drink
return function(world, objects, x, y)
  ---@class Drink
  local drink = {
    handx = 0,
    zindex = 200,
    pickup_distance = 40,
    body = lp.newBody(world, x, y, "dynamic"),
    shape = lp.newRectangleShape(0, 0, 14, 22),
  }
  drink.fixture = lp.newFixture(drink.body, drink.shape, 0.1)
  drink.fixture:setFilterData(1, 65535, -1)
  drink.body:setAngularDamping(20)
  drink.body:setLinearDamping(2)

  function drink:draw()
    lg.push()
    lg.setColor(1, 1, 1)

    lg.translate(self.body:getX(), self.body:getY())
    lg.rotate(self.body:getAngle())
    lg.translate(0, -10)

    lg.setColor(0,0,0)
    lg.ellipse('fill', 0, 21, 6, 2)

    lg.setColor(1, 1, 1)
    lg.ellipse('line', 0, 0, 7, 1)
    lg.line(-7, 0, 0, 8)
    lg.line(7, 0, 0, 8)
    lg.line(0, 8, 0, 21)
    lg.ellipse('line', 0, 21, 6, 2)

    lg.pop()
  end
  function drink:update()
    if drink.moving_hands then
      drink:to_handx(drink.handx)
    elseif not drink.player_hand_joint and drink:isSpilled() then
      drink.dropped = true
    end
  end
  function drink:to_hand(handx)
    self.moving_hands = true
    self.body:setAngularDamping(100)
    flux.to(drink, 0.25, {handx=handx}):oncomplete(function()
      drink.moving_hands = false
      self.body:setAngularDamping(20)
    end)
  end
  function drink:to_handx(handx)
    if drink.dropped then
      return
    end
    if drink.player_hand_joint then
      drink.player_hand_joint:destroy()
      drink.player_hand_joint = nil
    end
    local selfx, selfy = self.body:getWorldPoint(0, -6)
    local playerx, playery = objects.player.body:getWorldPoint(handx, -18)
    drink.player_hand_joint = lp.newDistanceJoint(
        self.body,
        objects.player.body,
        selfx, selfy,
        playerx, playery
    )
    drink.player_hand_joint:setLength(1)
    drink.player_hand_joint:setDampingRatio(0.8)
    drink.player_hand_joint:setFrequency(3)
  end

  function drink:drop()
    if drink.player_hand_joint then
      drink.player_hand_joint:destroy()
      drink.player_hand_joint = nil
      drink.body:setAngularDamping(2)
      drink.body:setLinearDamping(.5)
      drink.dropped = true
      drink.body:applyLinearImpulse(5, 8)
      drink.fixture:setRestitution(0.25)
    end
  end

  function drink:distanceToTable()
    if not self.player_hand_joint then
      return 99999
    end
    local drinkx, drinky = self.body:getPosition()
    local htx, hty = objects.hightop.body:getPosition()
    return lume.distance(htx, hty, drinkx, drinky)
  end

  function drink:isTouchingTable()
    return self.body:isTouching(objects.hightop.body)
  end

  function drink:isSpilled()
    return (
        math.abs(drink.body:getAngle()) > math.pi / 4
        or drink.body:isTouching(objects.customer.body)
    )
  end
  function drink:putDown()
    if drink.dropped then
      return
    end
    if drink:isSpilled() then
      drink.dropped = true
      return
    end
    if not drink.player_hand_joint then
      return
    end

    drink.player_hand_joint:destroy()
    drink.player_hand_joint = nil

    drink.body:setAngularDamping(2)
    drink.body:setLinearDamping(1)
    drink.body:applyLinearImpulse(2.5 * lume.sign(drink.handx), -5)
    drink.fixture:setRestitution(0.15)
  end

  objects.drink = drink
end
