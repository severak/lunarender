-- part of LunaRender 
-- (c) 2016 Mikoláš Štrajt
-- MIT licensed

local _M = {}

local push = table.insert

-- see http://stackoverflow.com/questions/1165647/how-to-determine-if-a-list-of-polygon-points-are-in-clockwise-order
local function signed_area(way)
	local area = 0
	for i, point in ipairs(way) do
		local x1, y1, x2, y2
		x1 = point.lat
		y1 = point.lon
		if i==#way then
			x2 = way[1].lat
			y2 = way[2].lon
		else
			x2 = way[i+1].lat
			y2 = way[i+1].lon
		end
		area = area + (x1 * y2 - x2 * y1)
	end
	return area
end

local function is_clockwise(way)
	return signed_area(way)>0
end

local function is_closed(points)
	if #points>1 and points[1]==points[#points] then
		return true
	end
end

local function pairs_copy(original)
	local copy = {}
	for k,v in pairs(original) do
		copy[k] = v
	end
	return copy
end

local function reversed_copy(original)
	local copy = {}
	for i=#original,1 do
		push(copy, original[i])
	end
	return copy
end

-- very, very hacky multipolygon builder
local function build_multi1(relation, data)
	local poly = {}
	local reversed = 0
	if relation.tags.natural=="coastline" then
		return nil -- no coastlines yet
	end
	for _, member in ipairs(relation) do
		-- accepting all closed polygons
		-- but also unclosed riverbanks (this is really piggy solution)
		if data.ways[member.ref] and (is_closed(data.ways[member.ref]) or relation.tags.waterway=='riverbank' or true) then
			local way = data.ways[member.ref]
			-- if order of the way doesnot adhere svg spec for holes, i am reversing it
			if member.role=='outer' and not is_clockwise(way) then
				way = reversed_copy(way)
				reversed = reversed + 1
			end
			if member.role=='inner' and is_clockwise(way) then
				way = reversed_copy(way)
				reversed = reversed + 1
			end
			push(poly, pairs_copy(way))
		end
	end
	
	if #poly<1 then
		return nil
	end
	
	if reversed>0 then
		-- print('reversed '..reversed ..' ways')
	end
	
	poly.tags = relation.tags
	
	return poly
end

-- build multipolygons from relations
function _M.build_multipolygons(data)
	print 'building multipolygons...'
	local polygons = {}
	for id, relation in pairs(data.relations) do
		local poly
		if relation.tags.type=="multipolygon" then
			poly = build_multi1(relation, data)
			if poly then
				polygons[id] = poly
			end
		end
	end
	return polygons
end

return _M