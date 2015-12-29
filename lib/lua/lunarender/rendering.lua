-- part of LunaRender 
-- (c) 2015 Mikoláš Štrajt
-- MIT licensed

local proj = require 'lunarender.projection'
local xmlwriter = require 'lunarender.xmlwriter'
local push = table.insert

local _M = {}

local function path_d(way, zoom, fx, ty)
	local x, y
	local d={}
	for i, node in ipairs(way) do
		x,y = proj.wgs84_to_px(node.lat, node.lon, zoom)
		x = x-fx
		y = y-ty
		if i==1 then
			push(d, 'M')
			push(d, ' ')
			push(d, x)
			push(d, ' ')
			push(d, y)
		else
			push(d, ' L')
			push(d, ' ')
			push(d, x)
			push(d, ' ')
			push(d, y)
		end
	end
	return table.concat(d)
end

-- renders data to SVG file output_filename using ruleset
function _M.render(data, ruleset, zoom, output_filename)
	local id, rule, node, way
	if ruleset.zoom then
		zoom = ruleset.zoom
	end
	
	local x,y
	local fx, fy = proj.wgs84_to_px(data.minlat, data.minlon, zoom)
	local tx, ty = proj.wgs84_to_px(data.maxlat, data.maxlon, zoom)

	local svg = {[0]='svg', xmlns="http://www.w3.org/2000/svg", width=math.abs(tx-fx)..'px', height=math.abs(ty-fy)..'px' }
	
	for _, rule in ipairs(ruleset) do
		if rule.type=='node' then
			for id, node in pairs(data.nodes) do
				if rule.match(node.tags, zoom) then
					x,y = proj.wgs84_to_px(node.lat, node.lon, zoom)
					push(svg, {[0]='circle', id='n'..id, cx=x-fx, cy=y-ty, r=2, style=rule.style })
				end
			end
		elseif rule.type=='way' then
			for id, way in pairs(data.ways) do
				if not way.closed and rule.match(way.tags, zoom) then
					push(svg, { [0]='path', id='w'..id, d=path_d(way, zoom, fx, ty), style=rule.style} )
				end
			end
		elseif rule.type=='area' then
			for id, way in pairs(data.ways) do
				if way.closed and rule.match(way.tags, zoom) then
					push(svg, { [0]='path', id='w'..id, d=path_d(way, zoom, fx, ty), style=rule.style} )
				end
			end
		end
	end

	if ruleset.callbacks and ruleset.callbacks.after then
		ruleset.callbacks.after(data)
	end
	
	local out = io.open(output_filename, 'w+') or error('Error opening output file: '..output_filename)
	out:write(xmlwriter.write(svg))
	out:close()
end

return _M