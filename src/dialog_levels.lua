local lume = require 'lume'
local flux = require "flux"
local lp = love.physics
local lg = love.graphics
local make_customer = require 'customer'
local make_player = require 'player'
local make_drink = require 'drink'


return function(world, objects, dialog_gen)
  music:setDialogScene()
  make_base_level(world, objects)

  make_player(world, objects, 120, 160)
  make_hightop(world, objects, 275, 180)
  make_customer(world, objects, 350, 180)
  make_drink(world, objects, -100, 0)

  local last_text_t = -1
  local co = coroutine.create(dialog_gen)
  local dialogs = {
    text = nil
  }

  function dialogs:next()
    if _G.t - last_text_t < 0.3 then
      return
    end
    last_text_t = _G.t
    local status, dtext = coroutine.resume(co)
    if dtext then
      dialogs.text = dtext
    else
      level_up()
    end
  end
  function dialogs:draw()
    lg.setColor(1, 1, 1)
    if dialogs.text.player then
      lg.printf(dialogs.text.player, 60, 50, 120, "center")
    end
    if dialogs.text.mrbot then
      lg.printf(dialogs.text.mrbot, 250, 50, 120, "center")
    end
  end

  dialogs:next()
  objects.dialogs = dialogs
  objects.player.can_move = false
end
