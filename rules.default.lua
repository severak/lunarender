-- default rules
-- 
-- should be usable out of the box

-- first defined, first drawed

-- water areas
rule{
	type = 'area',
	match = 'tags.natural and tags.natural=="water" ',
	style = 'fill: aqua'
}


-- forests
rule{
	type = 'area',
	match = 'tags.landuse and tags.landuse=="forest" ',
	style = 'fill: green'
}

-- parks and gardens
rule{
	type = 'area',
	match = 'tags.leisure and ( tags.leisure=="garden" or tags.leisure=="park") ',
	style = 'fill: lightgreen'
}

-- meadows, farmlands etc
rule{
	type = 'area',
	match = 'tags.landuse and (tags.landuse=="grass" or tags.landuse=="farmland" or tags.landuse=="meadow") ',
	style = 'fill: lightgreen'
}

-- industrial areas etc
rule{
	type = 'area',
	match = 'tags.landuse and (tags.landuse=="industrial" and tags.landuse=="railway" and tags.landuse=="brownfield") ',
	style = 'fill: tan'
}

-- residential areas
rule{
	type = 'area',
	match = 'tags.landuse and (tags.landuse=="residential") ',
	style = 'fill: navajowhite'
}

-- waterways

rule{
	type = 'area',
	match = 'tags.waterway ',
	style = 'fill: aqua'
}

rule{
	type = 'way',
	match = 'tags.waterway and not tags.have_riverbank',
	style = 'stroke: aqua; stroke-width: 2; fill: none'
}

-- ways
rule{
	type = 'way',
	match = 'tags.highway and not tags.tunnel',
	style = 'stroke: gray; fill: none'
}

-- ways in tunnel
rule{
	type = 'way',
	match = 'tags.highway and tags.tunnel',
	style = 'stroke: gray; fill: none; stroke-dasharray: 2, 2'
}

-- railways
rule{
	type = 'way',
	match = 'tags.railway and not tags.tunnel',
	style = 'stroke: brown; fill: none'
}

-- and in tunnel
rule{
	type = 'way',
	match = 'tags.railway and tags.tunnel',
	style = 'stroke: brown; fill: none; stroke-dasharray: 2, 2;'
}

-- bus stops 
rule{
	type = 'node',
	match = 'tags.highway and tags.highway=="bus_stop" ',
	style = 'fill: red;',
	r = 3
}


-- buildings
rule{
	type = 'area',
	match = 'tags.building',
	style = 'fill: orange'
}