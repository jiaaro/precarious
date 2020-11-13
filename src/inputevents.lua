local lume = require 'lume'

function level_up()
  local level_to_load = math.min(math.max(level_number + 1, 1), #levels)
  if level_to_load ~= level_number then
    level_number = level_to_load
    love.load()
  end
end
function level_down()
  local level_to_load = math.min(math.max(level_number - 1, 1), #levels)
  if level_to_load ~= level_number then
    level_number = level_to_load
    love.load()
  end
end

-- Wire up love handlers
function love.gamepadpressed(joystick, button )
  if button == "a" then
    return controls.buttonpress_a()
  elseif button == "b" then
    return controls.buttonpress_b()
  elseif button == "dpup" then
    return controls.buttonpress_up()
  elseif button == "dpdown" then
    return controls.buttonpress_down()
  elseif button == "dpleft" then
    return controls.buttonpress_left()
  elseif button == "dpright" then
    return controls.buttonpress_right()
  elseif button == "leftshoulder" then
    return level_up()
  elseif button == "rightshoulder" then
    return level_down()
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
  elseif cmd and key == "=" then
    level_up()
  elseif cmd and key == "-" then
    level_down()
  elseif key == "w" or key == "up" then
    controls.buttonpress_up()
  elseif key == "a" or key == "left" then
    controls.buttonpress_left()
  elseif key == "s" or key == "down" then
    controls.buttonpress_down()
  elseif key == "d" or key == "right" then
    controls.buttonpress_right()
  elseif key == "space" or key == "return" or key == "b" or key == "z" or key == "q" then
    controls.buttonpress_b()
  elseif key == "x" or key == "e" then
    controls.buttonpress_a()
  end
end

function set_controls(c)
  local function noop() end
  _G.controls = lume.extend({
    buttonpress_a = noop,
    buttonpress_b = noop,
    buttonpress_up = noop,
    buttonpress_down = noop,
    buttonpress_left = noop,
    buttonpress_right = noop,
  }, c)
end

function show_menu()
  make_menu_overlay(world, objects, {
    {"CONTINUE", function()
      if objects.drink.dropped or objects.player:fellDown() then
        love.load()
      else
        objects.menu:dismiss()
        set_controls(platforming_controls)
      end
    end},
    {"DIFFICULTY: {difficulty}", function() difficulty = math.mod(difficulty, #difficulty_labels) + 1 end},
  })
end
platforming_controls = {
  buttonpress_a = function()
    show_menu()
  end,
  buttonpress_b = function()
    show_menu()
  end,
  buttonpress_up = function()
    -- jump?
  end,
  buttonpress_down = function()
    objects.drink:putDown()
  end,
  buttonpress_left = function()
    if objects.drink.player_hand_joint or objects.player:distanceToDrink() <= objects.drink.pickup_distance then
      objects.drink:to_hand(-30)
    end
  end,
  buttonpress_right = function()
    if objects.drink.player_hand_joint then
      objects.drink:to_hand(30)
    end
  end,
}
dialog_controls = {
  buttonpress_a = function()
    objects.dialogs:next()
  end,
  buttonpress_b = function()
    objects.dialogs:next()
  end,
  buttonpress_up = function()
    objects.dialogs:next()
  end,
  buttonpress_down = function()
    objects.dialogs:next()
  end,
  buttonpress_left = function()
    objects.dialogs:next()
  end,
  buttonpress_right = function()
    objects.dialogs:next()
  end,
}

menu_controls = {
  buttonpress_a = function()
    objects.menu:select()
  end,
  buttonpress_b = function()
    objects.menu:select()
  end,
  buttonpress_up = function()
    objects.menu:move(-1)
  end,
  buttonpress_down = function()
    objects.menu:move(1)
  end,
  buttonpress_left = function()
    --if objects.drink.player_hand_joint or objects.player:distanceToDrink() <= objects.drink.pickup_distance then
    --  objects.drink:to_hand(-30)
    --end
  end,
  buttonpress_right = function()
    --if objects.drink.player_hand_joint then
    --  objects.drink:to_hand(30)
    --end
  end,
}

controls = menu_controls
