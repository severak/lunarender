-- count nodes shared with multiple paths and displays it
--
-- more shared nodes are darker

local function before(data, svg)
	print 'counting shared nodes...'
	for _, way in pairs(data.ways) do
		for _, node in ipairs(way) do
			node.tags.__shared = node.tags.__shared or 0
			node.tags.__shared = node.tags.__shared + 1
		end
	end
end

rule{
	type = 'way',
	match = 'true',
	style = 'fill: none; stroke: #ddd'
}

rule{
	type = 'node',
	match = 'tags.__shared and tags.__shared==1',
	style = 'fill: #ccc; stroke: none',
	r = 2
}

rule{
	type = 'node',
	match = 'tags.__shared and tags.__shared==2',
	style = 'fill: #888; stroke: none',
	r = 2
}

rule{
	type = 'node',
	match = 'tags.__shared and tags.__shared==3',
	style = 'fill: #444; stroke: none',
	r = 2
}

rule{
	type = 'node',
	match = 'tags.__shared and tags.__shared>3',
	style = 'fill: #000; stroke: none',
	r = 2
}

callbacks{
	before = before
}