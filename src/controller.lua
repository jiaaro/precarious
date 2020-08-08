local Object = require 'classic'
local lume = require 'lume'


---@class Controller
local Controller = Object:extend()

local function getStickAngle(x, y)
  if math.abs(x) < .5 and math.abs(y) < .5 then
    return
  end
  return lume.angle(0, 0, x, y)
end

local AnalogStickCrank = Object:extend()

function AnalogStickCrank:new(joystick, axisx, axisy)
  self.joystick = joystick
  self.axisx = axisx
  self.axisy = axisy
  self.pos = 0
  self.rotation_this_frame = 0
  self.last_angle = nil
end

function AnalogStickCrank:update(dt)
  if not self.joystick then
    return
  end

  local x = self.joystick:getGamepadAxis(self.axisx)
  local y = self.joystick:getGamepadAxis(self.axisy)
  local angle = getStickAngle(x, y)
  if not angle then
    self.last_angle = angle
    self.rotation_this_frame = 0
    return
  end
  if not self.last_angle then
    self.last_angle = angle
  end

  self.rotation_this_frame = (angle - self.last_angle)
  self.pos = self.pos + self.rotation_this_frame
  self.last_angle = angle
end


function Controller:new(joystick)
  self.joystick = joystick
  self.crankl = AnalogStickCrank(self.joystick, 'leftx', 'lefty')
  self.crankr = AnalogStickCrank(self.joystick, 'rightx', 'righty')
end

function Controller:update(dt)
  self.crankl:update(dt)
  self.crankr:update(dt)
end


---@return Controller
return Controller
