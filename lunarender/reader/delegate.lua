--- Delegate reader.
-- Delegates hard work to osmtogeojson node app.

local object = require 'lunarender.object'
local dkjson = require 'dkjson'
local lxp = require 'lxp'

local delegate = object:extend()

function delegate:set_params(params)
  if not params.input then
    return nil, 'Specify --input parameter'
  end
  
  local exists, tmpname, lxp_parser
	
	local function start_element(p, el, attr)
		if el == 'bounds' then
			self._bbox = {}
			self._bbox[1] = tonumber(attr.minlon)
			self._bbox[2] = tonumber(attr.minlat)
			self._bbox[3] = tonumber(attr.maxlon)
			self._bbox[4] = tonumber(attr.maxlat)
		end
	end
  
  exists = io.open(params.input)
  if not exists then
    return nil, 'File "'..params.input..'" not found'
  end
	
	lxp_parser = lxp.new{
		StartElement=start_element
	}
	
	for line in exists:lines() do
		lxp_parser:parse(line)
	end
	lxp_parser:parse('')
	
  exists:close()
  
  self._input = params.input
  return true
end

function delegate:read()
  local tmpname, tmpfile, json, data
  tmpname = 'tmp'..math.random(256)
	
  print('> osmtogeojson '..self._input..' > '..tmpname)
	print('...')
  os.execute('osmtogeojson '..self._input..' > '..tmpname)
  tmpfile = io.open(tmpname, 'r')
  json = tmpfile:read('*a')
  tmpfile:close()
	os.remove(tmpname)
  data = dkjson.decode(json)
	data.bbox = self._bbox
  return data
end

return delegate

