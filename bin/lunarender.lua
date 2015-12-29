-- part of LunaRender 
-- (c) 2015 Mikoláš Štrajt
-- MIT licensed

local reader=require 'lunarender.reader'
local proj=require 'lunarender.projection'
local serpent=require 'serpent'
local xmlwriter=require 'lunarender.xmlwriter'
local push = table.insert

local ok, data, fname

fname = arg[1] or error 'missing first argument: input filename!'

print 'Lunarender dev'
print 'loading data...'
data=reader.read(fname)

print 'drawing...'

local zoom=11
local fx, fy = proj.wgs84_to_px(data.minlat, data.minlon, zoom)
local tx, ty = proj.wgs84_to_px(data.maxlat, data.maxlon, zoom)

local svg = {[0]='svg', xmlns="http://www.w3.org/2000/svg", width=math.abs(tx-fx)..'px', height=math.abs(ty-fy)..'px' }

local x,y

for _, node in pairs(data.nodes) do
	if node.tags.power and node.tags.power=='tower' then
		x,y = proj.wgs84_to_px(node.lat, node.lon, zoom)
		push(svg, {[0]='circle', cx=x-fx, cy=y-ty, r=2, style='fill: yellow' })
	end
	if node.tags.highway and node.tags.highway=='bus_stop' then
		x,y = proj.wgs84_to_px(node.lat, node.lon, zoom)
		push(svg, {[0]='circle', cx=x-fx, cy=y-ty, r=3, style='fill: red', ['data-name']=node.tags.name })
	end
	if node.tags['ref:ruian:addr'] then
		x,y = proj.wgs84_to_px(node.lat, node.lon, zoom)
		push(svg, {[0]='circle', cx=x-fx, cy=y-ty, r=2, style='fill: gray' })
	end
end

for _, way in pairs(data.ways) do
	if way.tags and way.tags.highway then
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
		push(svg, {[0]='path', d=table.concat(d), style='fill: none; stroke: gray; stroke-width: 1px; '})
	end
	
	if way.tags and way.tags.landuse and way.tags.landuse=='forest' then
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
		push(svg, {[0]='path', d=table.concat(d), style='fill: green; stroke: none; '})
	end
end

print 'saving file...'
local out = io.open(fname..'.svg', 'w+')
out:write(xmlwriter.write(svg))
out:close()

print 'done'