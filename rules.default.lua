-- default rules
--
-- act as demo of rendering possibilities
-- 
-- should be usable out of the box

-- background color:
background('white')
-- zoom forced by style
force_zoom(15)

-- layers definition: from bottom to top
layers{'background', 'ways', 'railways', 'buildings', 'stops', 'labels'}

-- rendering rules:
-- first defined, first drawed

-- water areas
rule{
	type = 'area',
	match = 'tags.natural and tags.natural=="water" ',
	style = 'fill: aqua',
	layer = 'background'
}


-- forests
rule{
	type = 'area',
	match = 'tags.landuse and tags.landuse=="forest" ',
	style = 'fill: green',
	layer = 'background'
}

-- parks and gardens
rule{
	type = 'area',
	match = 'tags.leisure and ( tags.leisure=="garden" or tags.leisure=="park") ',
	style = 'fill: lightgreen',
	layer = 'background'
}

-- meadows, farmlands etc
rule{
	type = 'area',
	match = 'tags.landuse and (tags.landuse=="grass" or tags.landuse=="farmland" or tags.landuse=="meadow") ',
	style = 'fill: lightgreen',
	layer = 'background'
}

-- industrial areas etc
rule{
	type = 'area',
	match = 'tags.landuse and (tags.landuse=="industrial" and tags.landuse=="railway" and tags.landuse=="brownfield") ',
	style = 'fill: tan',
	layer = 'background'
}

-- residential areas
rule{
	type = 'area',
	match = 'tags.landuse and (tags.landuse=="residential") ',
	style = 'fill: navajowhite',
	layer = 'background'
}

-- waterways

rule{
	type = 'area',
	match = 'tags.waterway ',
	style = 'fill: aqua',
	layer = 'background'
}

rule{
	type = 'way',
	match = 'tags.waterway and not tags.have_riverbank',
	style = 'stroke: aqua; stroke-width: 2; fill: none',
	layer = 'background'
}

-- ways
rule{
	type = 'way',
	match = 'tags.highway and not tags.tunnel',
	style = 'stroke: gray; fill: none',
	layer = 'ways'
}

-- ways in tunnel
rule{
	type = 'way',
	match = 'tags.highway and tags.tunnel',
	style = 'stroke: gray; fill: none; stroke-dasharray: 2, 2',
	layer = 'ways'
}

-- railways
rule{
	type = 'way',
	match = 'tags.railway and not tags.tunnel',
	style = 'stroke: brown; fill: none',
	layer = 'railways'
}

-- and in tunnel
rule{
	type = 'way',
	match = 'tags.railway and tags.tunnel',
	style = 'stroke: brown; fill: none; stroke-dasharray: 2, 2;',
	layer = 'railways'
}

-- buildings
rule{
	type = 'area',
	match = 'tags.building',
	style = 'fill: orange',
	layer = 'buildings'
}

-- bus stops 
rule{
	type = 'node',
	match = 'tags.highway and tags.highway=="bus_stop" ',
	draw = 'symbola',
	symbol = 'ℌ', -- bus symbol, need to installed symbola font,
	layer = 'stops'
}

-- place names

rule{
	type = 'node',
	match = 'tags.place',
	draw = 'text',
	style = 'text-anchor: middle; fill: black; fill-opacity: 0.5; stroke: none; font-size: 20px; font-family: sans-serif; font-weight: bold; font-style: italic; ',
	layer = 'labels'
}


