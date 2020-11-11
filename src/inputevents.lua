
function buttonpress_a()
  love.load()
end

function buttonpress_b()
  love.load()
end

function buttonpress_up()
  -- jump?
end

function buttonpress_down()
  objects.drink:putDown()
end
function buttonpress_left()
  if objects.drink.player_hand_joint or objects.player:distanceToDrink() <= objects.drink.pickup_distance then
    objects.drink:to_hand(-30)
  end
end
function buttonpress_right()
  if objects.drink.player_hand_joint then
    objects.drink:to_hand(30)
  end
end


-- Wire up love handlers
function love.gamepadpressed(joystick, button )
  if button == "a" then
    return buttonpress_a()
  elseif button == "b" then
    return buttonpress_b()
  elseif button == "dpup" then
    return buttonpress_up()
  elseif button == "dpdown" then
    return buttonpress_down()
  elseif button == "dpleft" then
    return buttonpress_left()
  elseif button == "dpright" then
    return buttonpress_right()
  end

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

  if key == "w" then
    buttonpress_up()
  elseif key == "a" then
    buttonpress_left()
  elseif key == "s" then
    buttonpress_down()
  elseif key == "d" then
    buttonpress_right()
  elseif key == "space" or key == "b" then
    buttonpress_b()
  end
end
