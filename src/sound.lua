
local channels = {
  strings = {
    sound = love.audio.newSource( "sounds/strings.wav", "static"),
    level = 1,
  },
  kick = {
    sound = love.audio.newSource( "sounds/kick.wav", "static"),
    level = 0,
  },
  synthpiano = {
    sound = love.audio.newSource( "sounds/synthpiano.wav", "static"),
    level = 0,
  },
}

for name, channel in pairs(channels) do
  channel.sound:setLooping(true)
  channel.sound:setVolume(channel.level)
end

---@class Music
local music = {}

function music:play()
  for name, channel in pairs(channels) do
    channel.sound:play()
  end
end

function music:pause()
  for name, channel in pairs(channels) do
    channel.sound:pause()
  end
end

function music:update(dt)
  for name, channel in pairs(channels) do
    channel.sound:setVolume(channel.level)
  end
end

function music:setDialogScene()
  channels.kick.level = 0
  channels.synthpiano.level = 0.01
end

function music:setPlatformingScene()
  channels.kick.level = 1
  channels.synthpiano.level = 1
end

---@return Music
return music
