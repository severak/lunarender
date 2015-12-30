-- example of stroked railway line style

rule{
	type = 'way',
	match = 'zoom>15 and tags.railway and tags.railway=="rail" and not tags.tunnel',
	style = 'stroke: black; stroke-width: 4px; fill: none'
}

rule{
	type = 'way',
	match = 'zoom>15 and tags.railway and tags.railway=="rail" and not tags.tunnel',
	style = 'stroke: white; stroke-width: 2px; fill: none'
}

rule{
	type = 'way',
	match = 'zoom>15 and tags.railway and tags.railway=="rail" and not tags.tunnel',
	style = 'stroke: black; stroke-width: 2px; stroke-dasharray: 8, 8; fill: none'
}

-- which is rendered solid under zoom 16

rule{
	type = 'way',
	match = 'zoom<16 and tags.railway and tags.railway=="rail" and not tags.tunnel',
	style = 'stroke: black; stroke-width: 1px; fill: none'
}