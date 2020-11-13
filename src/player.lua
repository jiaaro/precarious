local lp = love.physics
local lg = love.graphics
local lume = require 'lume'

return function(world, objects, x, y)
  local wheel = {}
  wheel = {
    body = lp.newBody(world, x, y + 30, "dynamic"),
    shape = lp.newCircleShape( 12),
  }
  wheel.fixture = lp.newFixture(wheel.body, wheel.shape, 10)
  wheel.fixture:setRestitution(0.4)
  wheel.fixture:setFriction(10)
  wheel.fixture:setFilterData(1, 65535, -1)

  local player = {
    zindex = 100,
    can_move = true,
    body = lp.newBody(world, x, y, "dynamic"),
    shape = lp.newRectangleShape(0, 0, 25, 40),
  }
  player.fixture = lp.newFixture(player.body, player.shape, 2)
  player.fixture:setFilterData(1, 65535, -1)

  player.wheelJoint = lp.newDistanceJoint(
      player.body,
      wheel.body,
      player.body:getX(),
      player.body:getY(),
      wheel.body:getX(),
      wheel.body:getY(),
      0,
      1
  )
  player.wheelJoint = lp.newWheelJoint(
      player.body,
      wheel.body,
      wheel.body:getX(),
      wheel.body:getY(),
      0,
      1
  )
  player.wheelJoint:setSpringDampingRatio(0.1)
  player.wheelJoint:setSpringFrequency(1)

  function player:setDamping(damping)
    player.body:setLinearDamping(damping)
    player.body:setAngularDamping(damping)
  end

  player:setDamping(difficulty_damping[difficulty])

  function player:fellDown()
    return math.abs(player.body:getAngle()) > math.pi * 0.4
  end

  function player:draw()
    lg.setColor(1,1,1)

    -- Wheel -----
    local x, y, r = wheel.body:getX(), wheel.body:getY(), wheel.shape:getRadius()
    local angle = wheel.body:getAngle()
    lg.circle("line", x, y, r)
    lg.circle("line", x, y, r - 3)
    lg.circle("line", x, y, 1)

    local spokes = 5
    for i = 0, spokes do
      local xd, yd = lume.vector(angle + i * (math.pi * 2 / spokes) , r - 3)
      lg.line(x, y, x + xd, y + yd)
    end

    -- Body -----
    local x1, y1, x2, y2 = player.body:getWorldPoints(player.shape:getPoints())
    local angle = player.body:getAngle()
    local tilt = (math.pi+angle) / (2*math.pi)
    local straightness = math.abs(angle) / math.pi
    lg.push()
    lg.translate(x1, y1)
    lg.rotate(angle)

    -- antenna
    local headx = lume.lerp(24, 0, tilt)
    lg.circle('line', headx, -21, 2)
    lg.line(headx, -12, headx, -18)
    --head
    lg.circle('line', headx, 1, 11)
    -- eye
    lg.setColor(0,0,0)
    lg.circle('fill', headx + lume.lerp(-24, 16, tilt), lume.lerp(-3, -6, straightness), 3)
    lg.circle('fill', headx + lume.lerp(-16, 24, tilt), lume.lerp(-3, -6, straightness), 3)
    lg.setColor(1,1,1)
    lg.circle('line', headx + lume.lerp(-24, 16, tilt), lume.lerp(-3, -6, straightness), 2)
    lg.circle('line', headx + lume.lerp(-16, 24, tilt), lume.lerp(-3, -6, straightness), 2)

    -- waist
    lg.ellipse('line', 12, 36, 12, 3)

    --body
    lg.setColor(0,0,0)
    lg.ellipse('fill', 12, 24, 7, 12)
    lg.setColor(1,1,1)
    lg.ellipse('line', 12, 24, 7, 12)

    lg.pop()
  end

  function player:distanceToDrink()
    if objects.drink.player_hand_joint then
      return 99999
    end
    local playerx, playery = objects.player.body:getPosition()
    local drinkx, drinky = objects.drink.body:getPosition()
    return lume.distance(playerx, playery, drinkx, drinky)
  end

  objects.player = player
  objects.wheel = wheel
end
