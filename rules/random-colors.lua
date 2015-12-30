-- map colored with random colors

function selectRandomOne(...)
    t = {...}
    return t[math.random(1,#t)]
end

background('#fff')

-- derived from grey style

-- forest

-- changes color depending on zoom

rule{
	type = 'area',
	match = 'tags.landuse and tags.landuse=="forest" ',
	style = function(tags, zoom)
		if zoom==15 then
			return 'fill: #669900'
		elseif zoom>15 then
			return 'fill: #33FF00'
		elseif zoom<15 then
			return 'fill: #009900'
		end
	end
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

rule{
	type = 'area',
	match = 'tags.building',
	style = function(tags, zoom)
		return 'fill: ' .. selectRandomOne('#FF6600', '#FF9900', '#FF6633', '#FFCC33', '#FF9966', '#FFCC66') .. ''
	end
}

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

-- pick randomseed
math.randomseed(os.time())
