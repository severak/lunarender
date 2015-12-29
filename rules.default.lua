-- default rules

-- water
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

-- ways
rule{
	type = 'way',
	match = 'tags.highway',
	style = 'stroke: gray; fill: none'
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