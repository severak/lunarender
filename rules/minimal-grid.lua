-- minimal grid-like rules

background 'black'

rule{
	type = 'way',
	match = ' (tags.highway or tags.railway) and not tags.tunnel ',
	style = 'stroke: white; stroke-width: 1px; fill: none'
}