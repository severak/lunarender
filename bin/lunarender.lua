-- part of LunaRender 
-- (c) 2015 Mikoláš Štrajt
-- MIT licensed

local reader = require 'lunarender.reader'
local rules = require 'lunarender.rules'
local rendering = require 'lunarender.rendering'
local multipolygon = require 'lunarender.multipolygon'

local input_filename, rules_filename, zoom
local data, ruleset

local function endswith(String,End)
   return End=='' or string.sub(String,-string.len(End))==End
end

function die(msg)
	io.stderr:write('\n')
	io.stderr:write('Fatal error!\n')
	io.stderr:write(msg..'\n')
	os.exit()
end

input_filename = arg[1] or die 'Missing first command line argument: input filename'
rules_filename = arg[2] or 'rules/default.lua'
zoom = tonumber(arg[3]) or 15

print 'Lunarender v 0.1'
print '=========='
print 'by Severak'
print ''

print 'loading rules...'
ruleset = rules.load(rules_filename)

print 'loading data... (this takes a while)'
if endswith(input_filename, '.osm') then
	data = reader.read_osm(input_filename)
elseif endswith(input_filename, '.json') then
	data = reader.read_overpass_json(input_filename)
else
	die 'Bad format of input.'
end

data.multipolygons = multipolygon.build_multipolygons(data)

print 'drawing...'
rendering.render(data, ruleset, zoom, input_filename..'.svg')

print 'done.'
print('saved to '..input_filename..'.svg')
