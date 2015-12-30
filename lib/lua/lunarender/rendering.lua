-- part of LunaRender 
-- (c) 2015 Mikoláš Štrajt
-- MIT licensed

local proj = require 'lunarender.projection'
local xmlwriter = require 'lunarender.xmlwriter'
local push = table.insert

local _M = {}

local function apply_style(style, tags, zoom)
	if type(style)=='function' then
		return style(tags, zoom)
	end
	return style
end

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

-- todo: refactor folowing god function

-- renders data to SVG file output_filename using ruleset
function _M.render(data, ruleset, zoom, output_filename)
	local id, rule, node, way, textval
	local target
	if ruleset.zoom then
		zoom = ruleset.zoom
	end
	
	local x,y
	local fx, fy = proj.wgs84_to_px(data.minlat, data.minlon, zoom)
	local tx, ty = proj.wgs84_to_px(data.maxlat, data.maxlon, zoom)

	local layers = {}
	local svg = {[0]='svg', xmlns="http://www.w3.org/2000/svg", ['xmlns:inkscape']='http://www.inkscape.org/namespaces/inkscape', width=math.abs(tx-fx)..'px', height=math.abs(ty-fy)..'px' }
	
	if ruleset.background then
		push(svg, {[0]='rect', width='100%', height='100%', fill=ruleset.background } )
	end
	
	for _, id in ipairs(ruleset.layers) do
		layers[id] = {[0]='g', ['inkscape:groupmode']='layer', id=id, ['inkscape:label']=id}
		push(svg, layers[id] )
	end
	
	if ruleset.callbacks and ruleset.callbacks.before then
		ruleset.callbacks.before(data, svg)
	end
	
	for _, rule in ipairs(ruleset) do
		target = svg
		if rule.layer then
			target = layers[rule.layer] or error('Undefined layer named: '..rule.layer)
		end
		if rule.type=='node' then
			for id, node in pairs(data.nodes) do
				if rule.match(node.tags, zoom) then
					x,y = proj.wgs84_to_px(node.lat, node.lon, zoom)
					if rule.draw=='circle' then
						push(target, {[0]='circle', cx=x-fx, cy=y-ty, r=rule.r, style=apply_style(rule.style, node.tags, zoom) })
					elseif rule.draw=='text' then
						if type(rule.textkey)=='string' and node.tags[rule.textkey] then
							textval = node.tags[rule.textkey]
						end
						if type(rule.textkey)=='function' then
							textval = rule.textkey(node.tags, zoom)
						end
						if textval then
							push(target, {[0]='text', x=x-fx, y=y-ty, style=apply_style(rule.style, node.tags, zoom), transform=rule.transform, textval})
						end
					elseif rule.draw=='symbola' then
						push(target, {[0]='text', x=x-fx, y=y-ty, style=apply_style(rule.style or ruleset.symbola_style, node.tags, zoom), rule.symbol})
					end
				end
			end
		elseif rule.type=='way' then
			for id, way in pairs(data.ways) do
				if not way.closed and rule.match(way.tags, zoom) then
					push(target, { [0]='path', d=path_d(way, zoom, fx, ty), style=apply_style(rule.style, way.tags, zoom) } )
				end
			end
		elseif rule.type=='area' then
			for id, way in pairs(data.ways) do
				if way.closed and rule.match(way.tags, zoom) then
					push(target, { [0]='path', d=path_d(way, zoom, fx, ty), style=apply_style(rule.style, way.tags, zoom) } )
				end
			end
		end
	end

	if ruleset.callbacks and ruleset.callbacks.after then
		ruleset.callbacks.after(data, svg)
	end
	
	local out = io.open(output_filename, 'w+') or error('Error opening output file: '..output_filename)
	out:write(xmlwriter.write(svg))
	out:close()
end

return _M