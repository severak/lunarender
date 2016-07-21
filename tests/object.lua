local object = require 'lunarender.object'

local animal = object:extend()
animal.genus = 'animal'

function animal:init(name)
  self.name = name or self.genus
end

function animal:talk()
  print(self.genus .. ' does not talk.')
end

local dog = animal:extend()
dog.genus = 'dog'

function dog:talk()
  print(self.name .. ': woof')
end

local sth = animal:new()
sth:talk()

local Rex = dog:new 'Rex'
Rex:talk()

local laika = dog:new()
laika:talk()


