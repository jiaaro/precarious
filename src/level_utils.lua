local lume = require 'lume'
local lg = love.graphics
local lp = love.physics

function filldraw(self)
  lg.setColor(1, 1, 1)
  lg.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end
function linedraw(self)
  lg.setColor(1, 1, 1)
  lg.polygon("line", self.body:getWorldPoints(self.shape:getPoints()))
end
function make_hightop(world, objects, x, y)
  local hightop = {
    body = lp.newBody(world, x, y, 'dynamic'),
    topshape = lp.newRectangleShape(24, 6, 48, 12),
    legshape = lp.newRectangleShape(24, 24, 4, 26),
    feetshape = lp.newRectangleShape(24, 37, 16, 6),
  }
  hightop.fixture = lp.newFixture(hightop.body, hightop.topshape, 5)
  hightop.fixture = lp.newFixture(hightop.body, hightop.legshape, 10)
  hightop.fixture = lp.newFixture(hightop.body, hightop.feetshape, 35)
  function hightop:draw()
    lg.push()
    local topx, topy = self.body:getWorldPoint(24, 6)
    lg.translate(topx, topy)
    lg.rotate(self.body:getAngle())
    lg.ellipse("fill", 0, 0, 24, 6)
    lg.pop()
    lg.polygon("fill", self.body:getWorldPoints(self.legshape:getPoints()))
    lg.polygon("fill", self.body:getWorldPoints(self.feetshape:getPoints()))
  end
  objects.hightop = hightop
end

function make_base_level(world, objects)
  --let's create the ground
  objects.ground = {
    draw = filldraw,
    body = lp.newBody(world, screen_w /2, screen_h - 10),
    shape = lp.newRectangleShape(screen_w, 20)
  }
  objects.ground.fixture = lp.newFixture(objects.ground.body, objects.ground.shape)
  objects.ground.fixture:setFriction(5)

  objects.bar = {
    draw = filldraw,
    body = lp.newBody(world, 0, screen_h - 30),
    shape = lp.newRectangleShape(0, 0, 50, 50),
  }
  objects.bar.fixture = lp.newFixture(objects.bar.body, objects.bar.shape, 1)

  objects.lwall = {
    body = lp.newBody(world, 0, 0),
    shape = lp.newRectangleShape(0, 0, 1, screen_h*2),
  }
  objects.lwall.fixture = lp.newFixture(objects.lwall.body, objects.lwall.shape, 100)
  objects.rwall = {
    body = lp.newBody(world, 0, 0),
    shape = lp.newRectangleShape(screen_w+1, 0, 1, screen_h*2),
  }
  objects.rwall.fixture = lp.newFixture(objects.rwall.body, objects.rwall.shape, 100)
end


function make_help_text(world, objects, mk_text_fn)
  local help_text = {
    zindex = 10,
    state = "",
    changed_t = 0,
    text = "",
  }

  function help_text:update(dt)
    local state, text = mk_text_fn()

    if state ~= help_text.state or t - help_text.changed_t > 5 then
      help_text.state = state
      help_text.changed_t = t
      help_text.text = text or ""
    end
  end

  function help_text:draw()
    lg.print(help_text.text, instructions_font, 10, 6)
  end
  objects.help_text = help_text
end


function make_menu_overlay(world, objects, menu_options)
  set_controls(menu_controls)

  local menu = {
    zindex = 100000,
    options = menu_options,
    selected = 1
  }

  local h, w = 30, 300
  function menu:draw()
    local n_options = #menu.options
    local menu_w = w + 20
    local menu_h = (h + 10) * n_options + 10
    lg.push()
    lg.translate((screen_w - menu_w) / 2, (screen_h - menu_h) / 2)

    lg.setColor(0, 0, 0)
    lg.rectangle("fill", 0, 0, menu_w, menu_h)

    lg.setColor(1, 1, 1)
    lg.rectangle("line", 0, 0, menu_w, menu_h)
    lg.translate(10, 10)
    lg.printf({{1, 1, 1}, "M E N U"}, 0, -34, w, "center")
    lg.printf({{1, 1, 1}, "M E N U"}, 1, -34, w, "center")

    for i = 1, #menu.options do
      local text = menu.options[i][1]
      text = text:gsub("{difficulty}", difficulty_labels[difficulty])
      if menu.selected == i then
        lg.rectangle("fill", 0, 0, w, h)
        lg.printf({{0, 0, 0}, text}, 0, 7, w, "center")
        lg.printf({{0, 0, 0}, text}, 1, 7, w, "center")
      else
        lg.rectangle("line", 0, 0, w, h)
        lg.printf(text, 0, 7, w,"center")
      end
      lg.translate(0, h + 10)
    end
    lg.pop()
  end

  function menu:move(direction)
    menu.selected = lume.clamp(menu.selected + direction, 1, #menu.options)
  end
  function menu:select()
    local callback_fn = menu.options[menu.selected][2]
    callback_fn()
  end
  function menu:dismiss()
    objects.player:setDamping(difficulty_damping[difficulty])
    objects.menu = nil
    update_draw_stack()
  end

  objects.menu = menu
  update_draw_stack()
end
