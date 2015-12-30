-- style for drawing tram system overview
--
-- WIP

layers {'tracks', 'labels'}

-- tracks
rule{
	type = 'way',
	match = 'tags.railway and tags.railway=="tram" ',
	style = 'stroke: red; stroke-width: 1px; fill: none',
	layer = 'tracks'
}

rule{
	type = 'node',
	match = 'tags.railway and tags.railway=="tram_stop" ',
	style = 'stroke: none; fill: black',
	layer = 'tracks',
	r = 3
}

rule{
	type = 'node',
	match = 'tags.railway and tags.railway=="tram_stop" ',
	style = 'stroke: none; fill: black; font-family: Arial; font-weight: bold; font-size: 12pt; dy: 1em;',
	transform = 'translate(10 5)',
	layer = 'labels',
	draw = 'text'
}
