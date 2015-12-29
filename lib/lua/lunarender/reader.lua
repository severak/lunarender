-- part of LunaRender 
-- (c) 2015 Mikoláš Štrajt
-- MIT licensed

local lxp = require 'lxp'
local push = table.insert
local _M = {}

-- reads OSM XML using luaExpat
--
-- output is one big self-referencing table
--
function _M.read(fname)
	local current, data, p
	data = { nodes = {}, ways = {} } 
	
	local function StartElement(p, el, attr)
		if el == 'bounds' then
			data.minlon = attr.minlon
			data.maxlon = attr.maxlon
			data.minlat = attr.minlat
			data.maxlat = attr.maxlat
		elseif el == 'node' then
			if attr.visible then
				current = { lat=tonumber(attr.lat), lon=tonumber(attr.lon), tags={}}
				data.nodes[ tonumber(attr.id) ] = current
			end
		elseif el == 'way' then
			if attr.visible then
				current = { tags={}, closed=false }
				data.ways[ tonumber(attr.id) ] = current
			end
		elseif el =='tag' then
			if current and current.tags then
				current.tags[attr.k] = attr.v
			end
		elseif el == 'nd' then
			if current then
				push(current, data.nodes[ tonumber(attr.ref) ] or error('Missing node id='..attr.ref) )
			end
		end
	end
	
	local function EndElement(p, el)
		if el=='way' and current[1]==current[#current] then
			current.closed = true
		end
		if el=='node' or el=='way' then
			current = nil
		end
	end
	
	
	p = lxp.new{
		StartElement=StartElement,
		EndElement=EndElement
	}

	for l in io.lines(fname) do  -- iterate lines
		p:parse(l)          -- parses the line
		p:parse("\n")       -- parses the end of line
	end
	p:parse()               -- finishes the document
	p:close()               -- closes the parser
	return data
end

return _M