
function love.conf(t)
  t.version = "11.3"
  t.identity = "Spillt"
  t.window.title = "Spillt"

  -- Playdate
  t.window.width = 400
  t.window.height = 240
  t.window.resizable = false

  --t.window.resizable = true
  t.window.msaa = 0
  t.window.highdpi = false
end
