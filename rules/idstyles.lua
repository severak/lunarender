-- style for exporting id-like classnames

local push = table.insert

-- rewrite of https://github.com/openstreetmap/iD/blob/master/js/id/svg/tag_classes.js

function class_name(tags, zoom)
	local classes = {}
	
	local primary = {
	    'building', 'highway', 'railway', 'waterway', 'aeroway',
            'motorway', 'boundary', 'power', 'amenity', 'natural', 'landuse',
            'leisure', 'place'
	}
	
	local secondary = {
            'oneway', 'bridge', 'tunnel', 'embankment', 'cutting', 'barrier',
            'surface', 'tracktype', 'crossing'
	}
	
	local statuses = {
		proposed=true,
		construction=true,
		disused=true,
		abandoned=true,
		dismantled=true,
		razed=true,
		demolished=true,
		obliterated=true
        }
	
	local status
	
	for _,key in ipairs(primary) do
		if tags[key] then
			if statuses[tags[key]] then
				push(classes, 'tag-'..key)
				status = tags[key] 
			else
				push(classes, 'tag-'..key)
				push(classes, 'tag-'..key..'-'..tags[key])
			end
			
		end
	end
	
	if status then
		push(classes, 'tag-status')
		push(classes, 'tag-status-'..status)
	end
	
	for _,key in ipairs(secondary) do
		if tags[key] then
			push(classes, 'tag-'..key)
			push(classes, 'tag-'..key..'-'..tags[key])
		end
	end
	
	return table.concat(classes, ' ')
end

function stroke_class(tags, zoom)
	return 'stroke ' .. class_name(tags, zoom) 
end

function casing_class(tags, zoom)
	return 'casing ' .. class_name(tags, zoom) 
end

function fill_class(tags, zoom)
	return 'fill ' .. class_name(tags, zoom) 
end

function before(data, svg)
	push(svg, {[0]='style', ' path { fill: none; stroke: none; }', type='text/css'}) -- css reset
--	push(svg, {[0]='style', '@import url(map.css);', type='text/css'}) -- css import of map.css
end

callbacks{
	before = before
}

-- drawing order:
-- landuse
-- water
-- embankments, cuttings, cliffs etc.
-- tunnels
-- ways and railways
-- buldings
-- bridges
-- symbols
-- names

-- # landuse

rule{
	type = 'area',
	match = 'tags.landuse or tags.leisure or tags.natural or tags.amenity',
	class = fill_class,
}

-- # waterways

rule{
	type = 'way',
	match = 'tags.waterway',
	class = stroke_class,
}

-- #tunnels

rule{
	type = 'way',
	match = 'tags.tunnel',
	class = casing_class,
}

rule{
	type = 'way',
	match = 'tags.tunnel',
	class = stroke_class,
}

-- # ways

rule{
	type = 'area',
	match = 'tags.highway',
	class = casing_class,
}

rule{
	type = 'area',
	match = 'tags.highway',
	class = fill_class,
}

rule{
	type = 'way',
	match = 'tags.highway',
	class = casing_class,
}

rule{
	type = 'way',
	match = 'tags.highway',
	class = stroke_class,
}

-- power lines
rule{
	type = 'way',
	match = 'tags.power',
	class = casing_class,
}

rule{
	type = 'way',
	match = 'tags.power',
	class = stroke_class,
}

-- railways

rule{
	type = 'way',
	match = 'tags.railway',
	class = casing_class,
}

rule{
	type = 'way',
	match = 'tags.railway',
	class = stroke_class,
}

-- #buildings

rule{
	type = 'area',
	match = 'tags.building',
	class = stroke_class,
}

rule{
	type = 'area',
	match = 'tags.building',
	class = fill_class,
}

-- #bridges

rule{
	type = 'area',
	match = 'tags.bridge',
	class = stroke_class,
}