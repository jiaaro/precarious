
function love.conf(t)
  t.version = "11.3"
  t.identity = "lfie"
  t.window.title = "lfie"

  -- Playdate
  --  t.window.width = 400
  --  t.window.height = 240

  -- Mac
  t.window.width = 400
  t.window.height = 240
  t.window.resizable = false

  --t.window.resizable = true
  t.window.msaa = 0
  t.window.highdpi = false
end
