local Controller = require 'controller'
local hexcolor = require 'hexcolor'
local lume = require 'lume'

local colors = {
  [0] = hexcolor('#333'),
  [1] = hexcolor('#ccc'),
}

function Controller:drawStickPositions()
  local xoffset = self.w / 3
  local r = self.h / 5
  local x1 = self.joystick:getGamepadAxis('leftx')
  local y1 = self.joystick:getGamepadAxis('lefty')
  local x2 = self.joystick:getGamepadAxis('rightx')
  local y2 = self.joystick:getGamepadAxis('righty')

  lg.circle('line',self.x - xoffset, self.y, r)
  lg.circle('line',self.x + xoffset, self.y, r)

  lg.setColor(1, 0, 0)
  lg.circle('fill',self.x - xoffset + x1 * r, self.y + y1 * r, 10)
  lg.circle('fill',self.x + xoffset + x2 * r, self.y + y2 * r, 10)

  lg.setColor(1, 1, 1)
  --lg.print(string.format("%0.3f, %0.3f\n%0.3f, %0.3f", x1, y1, x2, y2))
  lg.print(string.format("%0.3f, %0.3f\n%s\n%s", getStickAngle(x1, y1) or -9, getStickAngle(x2, y2) or -9, self.x1, self.y1))
end

function Controller:drawCrankPositions()
  local xoffset = self.w / 3
  local r = self.h / 5

  lg.setColor(1, 1, 1)
  lg.circle('line',self.x - xoffset, self.y, r)
  lg.circle('line',self.x + xoffset, self.y, r)

  lg.setColor(0, 0, 1)

  local crankX, crankY
  crankX, crankY = lume.vector(self.crankl.pos, r)
  lg.circle('fill',self.x - xoffset + crankX, self.y + crankY, 10)

  crankX, crankY = lume.vector(self.crankr.pos, r)
  lg.circle('fill',self.x + xoffset + crankX, self.y + crankY, 10)
end

function Controller:draw(screen_w, screen_h)
  self.w = screen_w / 2
  self.h = screen_h / 2
  self.x = screen_w / 2
  self.y = screen_h / 2

  --self:drawStickPositions()
  self:drawCrankPositions()
end
