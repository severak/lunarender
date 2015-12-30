-- simple wireframe-like render in four shades of gray
-- 
-- can be used as background for something else

background('#fff')

-- enables/disable buildings (disabled building simplifies map a lot)
local can_into_buildings  = true


-- forest
rule{
	type = 'area',
	match = 'tags.landuse and tags.landuse=="forest" ',
	style = 'fill: #aaa',
}

-- water
rule{
	type = 'area',
	match = 'tags.natural and tags.natural=="water" ',
	style = 'fill: #ccc;'
}

rule{
	type = 'area',
	match = 'tags.waterway ',
	style = 'fill: #ccc',
}

rule{
	type = 'way',
	match = 'tags.waterway and not tags.have_riverbank',
	style = 'stroke: #ccc; stroke-width: 2; fill: none',
}

-- bridges
rule{
	type = 'area',
	match = 'tags.bridge',
	style = 'fill: #fff; stroke: none'
}

rule{
	type = 'way',
	match = 'tags.bridge',
	style = 'fill: none; stroke: #fff; stroke-width: 4'
}

-- buildings

if can_into_buildings then
	rule{
		type = 'area',
		match = 'tags.building',
		style = 'fill: #ddd'
	}
end

-- ways
rule{
	type = 'way',
	match = 'tags.highway and not tags.tunnel',
	style = 'stroke: #666; fill: none',
}

-- railways
rule{
	type = 'way',
	match = 'tags.railway and not tags.tunnel',
	style = 'stroke: #333; fill: none',
}

-- on the top of monochrome render, there can be something else in colour

-- e.g. trams rendered in red
rule{
	type = 'way',
	match = 'tags.railway and (not tags.tunnel) and tags.railway=="tram" ',
	style = 'stroke: red; fill: none',
}

rule{
	type = 'node',
	match = 'tags.railway and tags.railway=="tram_stop" ',
	style = 'fill: red',
	r = 3
}

