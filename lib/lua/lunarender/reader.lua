-- part of LunaRender 
-- (c) 2015 Mikoláš Štrajt
-- MIT licensed

local lxp = require 'lxp'
local dkjson = require 'dkjson'
local push = table.insert
local _M = {}

-- reads OSM XML using luaExpat
--
-- output is one big self-referencing table
--
function _M.read_osm(fname)
	local current, data, p
	data = { nodes = {}, ways = {}, relations = {} } 
	
	local function StartElement(p, el, attr)
		if el == 'bounds' then
			data.minlon = attr.minlon
			data.maxlon = attr.maxlon
			data.minlat = attr.minlat
			data.maxlat = attr.maxlat
		elseif el == 'node' then
			current = { lat=tonumber(attr.lat), lon=tonumber(attr.lon), tags={}}
			data.nodes[ tonumber(attr.id) ] = current
		elseif el == 'way' then
			current = { tags={}, closed=false }
			data.ways[ tonumber(attr.id) ] = current
		elseif el =='tag' then
			if current and current.tags then
				current.tags[attr.k] = attr.v
			end
		elseif el == 'nd' then
			if current then
				push(current, data.nodes[ tonumber(attr.ref) ] or die('Missing node id='..attr.ref) )
			end
		elseif el=='relation' then
			if attr.visible then
				current = { tags={} }
				data.relations[ tonumber(attr.id) ] = current
			end
		elseif el=='member' then
			if current then
				push(current, {type=attr.type, ref=tonumber(attr.ref), role=attr.role} )
			end
		end
	end
	
	local function EndElement(p, el)
		if el=='way' and (current and #current>1 and current[1]==current[#current]) then
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

-- reads overpass api json output
function _M.read_overpass_json(fname)
	local fh, content, json
	local data = {nodes = {}, ways={} }
	fh = io.open(fname, 'r') or die('File '..fname..' cannot be read.')
	content = fh:read('*a')
	fh:close()
	json = dkjson.decode(content)
	
	if not json then
		die 'Invalid input file.'
	end
	
	if not json.bounds then
		die 'Missing bounds in Overpass file.'
	end
	
	data.minlon = json.bounds.minlon
	data.maxlon = json.bounds.maxlon
	data.minlat = json.bounds.minlat
	data.maxlat = json.bounds.maxlat
	
	for _, node in ipairs(json.elements) do
		if node.type=='node' then
			-- AAAAAAARRRRRGH! seems nodes can be output more times on certain queries
			if not data.nodes[node.id] then
				data.nodes[node.id] = { lat=node.lat, lon=node.lon, tags = node.tags or {} }
			end
		end
	end
		
	for _, way in pairs(json.elements) do
		local nodes = {}
		if way.type=='way' then
			for _, id in ipairs(way.nodes or {}) do
				push(nodes, data.nodes[id] or die('Node id'..id..' missing in Overpass file.'))
			end
			nodes.closed = false
			if #way.nodes>1 and way.nodes[1]==way.nodes[#way.nodes] then
				nodes.closed = true
			end
			nodes.tags = way.tags or {}
			data.ways[way.id] = nodes
		end
	end
	
	return data
end

return _M