-- part of LunaRender 
-- (c) 2015 Mikoláš Štrajt
-- MIT licensed

local reader = require 'lunarender.reader'
local rules = require 'lunarender.rules'
local rendering = require 'lunarender.rendering'

local input_filename, rules_filename, zoom
local data, ruleset

input_filename = arg[1] or error 'missing first argument: input filename!'
rules_filename = arg[2] or 'rules.default.lua'
zoom = arg[3] or 15

print 'Lunarender dev version'
print '=========='
print 'by Severak'
print ''

print 'loading rules...'
ruleset = rules.load(rules_filename)

print 'loading data... (this takes a while)'
data=reader.read_osm(input_filename)

print 'drawing...'
rendering.render(data, ruleset, zoom, input_filename..'.svg')

print 'done.'
print('saved to '..input_filename..'.svg')
