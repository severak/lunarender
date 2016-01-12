--
-- style inspired by soviet military topographics maps
--
-- also inspired by handbook of czech military
--
-- overhead goal is to gather as much geospatial intelligence information as possible ;-) 
-- as soviet maps did

background('#fff')

layers{'topo', 'symbols', 'names'}

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

force_zoom(15) -- not optimised for smaller zooms yet

-- # landuse

-- rock,  bare_rock
rule{
	type = 'area',
	match = 'tags.natural=="rock" or tags.natural=="bare_rock" or tags.natural=="stone"  ',
	style = 'fill: #ccc',
	layer = 'topo'
}

-- forests and co
rule{
	type = 'area',
	match = 'tags.landuse and (tags.landuse=="forest" or tags.natural=="scrub" and tags.natural=="wood") ',
	style = 'fill: #00CC00',
	layer = 'topo'
}

-- parks and gardens
rule{
	type = 'area',
	match = 'tags.leisure=="garden" or tags.leisure=="park" ',
	style = 'fill: #99FF66',
	layer = 'topo'
}

-- cemeteries are sort of parks too
rule{
	type = 'area',
	match = 'tags.landuse=="cemetery" or tags.amenities=="grave_yard" ',
	style = 'fill: #99FF66',
	layer = 'topo'
}

-- meadows, farmlands etc
rule{
	type = 'area',
	match = 'tags.landuse and (tags.landuse=="grass" or tags.landuse=="farmland" or tags.landuse=="meadow") ',
	style = 'fill: #FFFFCC',
	layer = 'topo'
}

-- industrial areas etc
rule{
	type = 'area',
	match = 'tags.landuse and (tags.landuse=="industrial" or tags.landuse=="railway" or tags.landuse=="brownfield") ',
	style = 'fill: #ddd; stroke: none',
	layer = 'topo'
}

-- residential areas
rule{
	type = 'area',
	match = 'tags.landuse and (tags.landuse=="residential") ',
	style = 'fill: #FFFF99',
	layer = 'topo'
}

-- # water

-- as LunaRender cannot read relations, there is no way how to draw rivers properly :-P
-- 
-- so we use this hint for now:

rule{
	type = 'way',
	match = 'tags.waterway and tags.have_riverbank ',
	style = 'stroke: #0066FF; stroke-width: 5; stroke-dasharray: 5, 5; fill: none',
	layer = 'topo'
}

-- waterways
-- todo:  indicate direction of waterway on map as soviets did

rule{
	type = 'way',
	match = 'tags.waterway and not tags.have_riverbank',
	style = 'stroke: #0066FF; stroke-width: 2; fill: none',
	layer = 'topo'
}

-- water areas
rule{
	type = 'area',
	match = 'tags.natural and tags.natural=="water" ',
	style = 'fill: #0066FF',
	layer = 'topo'
}

rule{
	type = 'area',
	match = 'tags.waterway or tags.water',
	style = 'fill: #0066FF',
	layer = 'topo'
}

rule{
	type = 'area',
	match = 'tags.landuse and (tags.landuse=="reservoir" or tags.landuse=="basin") ',
	style = 'fill: #0066FF',
	layer = 'topo'
}

-- # cuttings and embankments

-- not tested:
--[[
rule{
	type = 'way',
	match = 'tags.cutting and (tags.railway or tags.highway)',
	style = 'stroke: yellow; stroke-width: 6; fill: none',
	layer = 'topo'
}

rule{
	type = 'way',
	match = 'tags.enbankment and (tags.railway or tags.highway)',
	style = 'stroke: yellow; stroke-width: 6; fill: none',
	layer = 'topo'
}
]]

-- cliff

rule{
	type = 'way',
	match  = 'tags.natural=="cliff" ',
	style = 'stroke: #ccc; fill: none',
	layer = 'topo'
}

-- #tunnels

rule{
	type = 'way',
	match = 'tags.highway and tags.tunnel and tags.highway~="proposed" ',
	style = 'stroke: #FFCC66; stroke-width: 3; stroke-dasharray: 3, 3; fill: none',
	layer = 'topo'
}

rule{
	type = 'way',
	match = 'tags.railway and tags.tunnel and tags.railway~="proposed" ',
	style = 'stroke: #000; stroke-width: 2; stroke-dasharray: 3, 3; fill: none',
	layer = 'topo'
}

-- # ways

-- roads

rule{
	type = 'area',
	match = 'tags.highway and area=="yes" ',
	style = 'stroke: #888; stroke-width: 1; fill: #fff',
	layer = 'topo'
}

-- roundabouts may be areas
rule{
	type = 'area',
	match = 'tags.highway and tags.junction=="roundabout" and not (tags.tunnel or tags.bridge)',
	style = 'stroke: #888; stroke-width: 4; fill: none',
	layer = 'topo'
}
rule{
	type = 'area',
	match = 'tags.highway and tags.junction=="roundabout" and not (tags.tunnel or tags.bridge)',
	style = 'stroke: #fff; stroke-width: 2; fill: none',
	layer = 'topo'
}

-- ways have bit verbose scheme, so we use this shortand sets:

_G.WAY_FOOT = {
	footway = true,
	steps = true,
	cycleway = true,
	pedestrian = true,
	living_street = true,
}

_G.WAY_G0 = {
	track = true,
	path = true,
	bridleway = true,
}

_G.WAY_G1 = {
	residential = true,
	road = true,
	service = true,
	unclassified = true,
}

_G.WAY_G2 = {
	trunk = true,
	primary = true,
	secondary = true,
	tertiary = true,
	
	
	motorway_link = true,
	trunk_link = true,
	primary_link = true,
	secodary_link = true,
	tertiary_link = true,
}

_G.WAY_G3 = {
	motorway = true,
}


rule{
	type = 'way',
	match = 'tags.highway and WAY_FOOT[tags.highway] and not (tags.tunnel or tags.bridge)',
	style = 'stroke: #CC9933; stroke-dasharray: 2, 3; fill: none',
	layer = 'topo'
}

rule{
	type = 'way',
	match = 'tags.highway and WAY_G0[tags.highway] and not (tags.tunnel or tags.bridge)',
	style = 'stroke: #CC9933; stroke-dasharray: 4, 3; fill: none',
	layer = 'topo'
}

-- road with outlines is drawn by two separate lines:
-- 1. grey stroke n+1px width
-- 2. white stroke  npx width

rule{
	type = 'way',
	match = 'tags.highway and WAY_G1[tags.highway] and not (tags.tunnel or tags.bridge)',
	style = 'stroke: #888; stroke-width: 4; fill: none',
	layer = 'topo'
}


rule{
	type = 'way',
	match = 'tags.highway and WAY_G2[tags.highway] and not (tags.tunnel or tags.bridge)',
	style = 'stroke: #888; stroke-width: 5; fill: none',
	layer = 'topo'
}

rule{
	type = 'way',
	match = 'tags.highway and WAY_G3[tags.highway] and not (tags.tunnel or tags.bridge)',
	style = 'stroke: #888; stroke-width: 5; fill: none',
	layer = 'topo'
}

-- fill

rule{
	type = 'way',
	match = 'tags.highway and WAY_G1[tags.highway] and not (tags.tunnel or tags.bridge)',
	style = 'stroke: #fff; stroke-width: 2; fill: none',
	layer = 'topo'
}

rule{
	type = 'way',
	match = 'tags.highway and WAY_G2[tags.highway] and not (tags.tunnel or tags.bridge)',
	style = 'stroke: #FFCC66; stroke-width: 3; fill: none',
	layer = 'topo'
}

rule{
	type = 'way',
	match = 'tags.highway and WAY_G3[tags.highway] and not (tags.tunnel or tags.bridge)',
	style = 'stroke: #FF9933; stroke-width: 3; fill: none',
	layer = 'topo'
}


-- power lines

rule{
	type = 'node',
	match = 'tags.power and tags.power=="tower" ',
	style = 'stroke: #222; fill: none',
	r = 2,
	layer = 'topo'
}

rule{
	type = 'way',
	match = 'tags.power and tags.power=="line" ',
	style = 'stroke: #222; fill: none',
	layer = 'topo'
}

-- railways

-- electrification for railways / note the possibility of electrified=no

rule{
	type = 'way',
	match = 'tags.railway and (tags.electrified and tags.electrified~="no") and (tags.railway=="rail" or tags.railway=="narrow_gauge") and not (tags.service=="spur" or tags.service=="sidings" or tags.service=="yard") and not (tags.tunnel or tags.bridge)',
	style = 'stroke: #000; stroke-width: 4; stroke-dasharray: 1, 10; fill: none',
	layer = 'topo'
}

-- trams

rule{
	type = 'way',
	match = 'tags.railway and tags.railway=="tram" and not (tags.tunnel or tags.bridge)',
	style = 'stroke: #660000; stroke-width: 1; fill: none',
	layer = 'topo'
}

-- railways

rule{
	type = 'way',
	match = 'tags.railway and (tags.railway=="disused" or tags.railway=="abandoned") and not (tags.tunnel or tags.bridge)',
	style = 'stroke: #444; stroke-width: 1; stroke-dasharray: 2, 2; fill: none',
	layer = 'topo'
}

rule{
	type = 'way',
	match = 'tags.railway and (tags.railway=="rail" or tags.railway=="narrow_gauge") and (tags.service=="spur" or tags.service=="sidings" or tags.service=="yard") and not (tags.tunnel or tags.bridge)',
	style = 'stroke: #000; stroke-width: 1; fill: none',
	layer = 'topo'
}

rule{
	type = 'way',
	match = 'tags.railway and (tags.railway=="rail" or tags.railway=="narrow_gauge") and not (tags.tunnel or tags.bridge or tags.service=="spur" or tags.service=="sidings" or tags.service=="yard")',
	style = 'stroke: #000; stroke-width: 2; fill: none',
	layer = 'topo'
}

-- #buildings

rule{
	type = 'area',
	match = 'tags.building',
	style = 'stroke: none; fill: #FFCC00',
	layer = 'topo'
}

-- #bridges

rule{
	type = 'way',
	match = 'tags.bridge and tags.highway and WAY_G1[tags.highway]',
	style = 'stroke: #000; stroke-width: 4; fill: none',
	layer = 'topo'
}
rule{
	type = 'way',
	match = 'tags.bridge and tags.highway and WAY_G1[tags.highway]',
	style = 'stroke: #fff; stroke-width: 2; fill: none',
	layer = 'topo'
}

rule{
	type = 'way',
	match = 'tags.bridge and tags.highway and WAY_G2[tags.highway]',
	style = 'stroke: #000; stroke-width: 5; fill: none',
	layer = 'topo'
}
rule{
	type = 'way',
	match = 'tags.bridge and tags.highway and WAY_G2[tags.highway]',
	style = 'stroke: #fff; stroke-width: 3; fill: none',
	layer = 'topo'
}

rule{
	type = 'way',
	match = 'tags.bridge and tags.highway and WAY_G3[tags.highway]',
	style = 'stroke: #000; stroke-width: 5; fill: none',
	layer = 'topo'
}
rule{
	type = 'way',
	match = 'tags.bridge and tags.highway and WAY_G3[tags.highway]',
	style = 'stroke: #fff; stroke-width: 3; fill: none',
	layer = 'topo'
}

-- railway bridge

rule{
	type = 'way',
	match = 'tags.bridge and tags.railway',
	style = 'stroke: #000; stroke-width: 4; fill: none',
	layer = 'topo'
}
rule{
	type = 'way',
	match = 'tags.bridge and tags.railway',
	style = 'stroke: #fff; stroke-width: 2; fill: none',
	layer = 'topo'
}

-- BIG TODO:  SYMBOLS LAYER

-- #names

-- peaks

rule{
	type = 'node',
	match = 'tags.natural=="peak" ',
	style = 'stroke: none; fill: #444',
	r = 2,
	layer = 'symbols'
}

rule{
	type = 'node',
	match = 'tags.natural=="peak" ',
	style = 'stroke: none; fill: #000; font-family: sans-serif; font-weight: bold; font-size: 12px;',
	draw = 'text',
	transform = 'translate(4 4)',
	layer = 'names',
	textkey = function(tags, zoom)
		if tags.name and tags.ele then
			return tags.name .. ' (' .. tags.ele .. 'm)'
		elseif tags.name then
			return tags.name
		elseif tags.ele then
			return '(' .. tags.ele .. 'm)'
		end
	end
}

-- tram stops

rule{
	type = 'node',
	match = 'tags.railway=="tram_stop" or (tags.public_transport=="stop_position" and tags.tram=="yes") ',
	style = 'stroke: none; fill: #660000',
	r = 3,
	layers = 'symbols'
}

-- railway = stop/station/halt

rule{
	type = 'node',
	match = 'tags.railway=="stop" or tags.railway=="halt" or tags.railway=="station"',
	style = 'stroke: none; fill: #000',
	r = 3,
	layers = 'symbols'
}

rule{
	type = 'node',
	match = ' tags.railway=="stop" or tags.railway=="halt" or tags.railway=="station" ',
	style = 'stroke: none; fill: #000; font-family: sans-serif; font-weight: bold; font-size: 12px;',
	draw = 'text',
	transform = 'translate(4 4)',
	layer = 'names',
}

-- place names

rule{
	type = 'node',
	match = 'tags.place and (tags.place=="hamlet" or tags.place=="isolated_dwelling")',
	draw = 'text',
	style = 'text-anchor: middle; fill: black; stroke: none; font-size: 16px; font-family: sans-serif; font-weight: bold; ',
	layer = 'names'
}

rule{
	type = 'node',
	match = 'tags.place and (tags.place=="city" or tags.place=="town" or tags.place=="village")',
	draw = 'text',
	style = 'text-anchor: middle; fill: black; stroke: none; font-size: 20px; font-family: sans-serif; font-weight: bold; ',
	layer = 'names'
}

rule{
	type = 'node',
	match = 'zoom>13 and tags.place and (tags.place=="suburb" or tags.place=="neighbourhood")',
	draw = 'text',
	style = 'text-anchor: middle; fill: black; stroke: none; font-size: 20px; font-family: sans-serif; font-weight: bold; font-variant: italic',
	layer = 'names'
}
