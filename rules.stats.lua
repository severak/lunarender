-- rules to make some stats and debug

-- beware of output - can produce veryu large files easily

-- all nodes
rule{
	type = 'node',
	match = 'true',
	style = 'stroke: black',
	r = 1.5
}

-- all ways
rule{
	type = 'way',
	match = 'true',
	style = 'stroke: gray; fill: none'
}

local function stats(data, svg)
	local sn = {}
	local sw = {}
	local sa = {}
	
	print 'counting stats...'
	
	-- various junk which creates unique tag values
	local skips = {
		name = true,
		['addr:conscriptionnumber'] = true,
		['addr:housenumber'] = true,
		['addr:provisionalnumber'] = true,
		['ref:ruian'] = true,
		['ref:ruian:building'] = true,
		['addr:streetnumber'] = true,
		['ref:ruian:addr'] = true,
		['uir_adr:ADRESA_KOD'] = true,
		start_date = true,
		ref = true
	}
	
	for id, node in pairs(data.nodes) do
		for k,v in pairs(node.tags) do
			if not skips[k] then
				if sn[k] and sn[k][v] then
					sn[k][v] = sn[k][v] + 1
				else
					sn[k] = sn[k] or {}
					sn[k][v] = 1
				end
			end
		end
	end
	
	for id, way in pairs(data.ways) do
		if not way.closed then
			for k,v in pairs(way.tags) do
				if not skips[k] then
					if sw[k] and sw[k][v] then
						sw[k][v] = sw[k][v] + 1
					else
						sw[k] = sw[k] or {}
						sw[k][v] = 1
					end
				end
			end
		end
	end

	for id, area in pairs(data.ways) do
		if area.closed then
			for k,v in pairs(area.tags) do
				if not skips[k] then
					if sa[k] and sa[k][v] then
						sa[k][v] = sa[k][v] + 1
					else
						sa[k] = sa[k] or {}
						sa[k][v] = 1
					end
				end
			end
		end
	end
	
	print ' '
	print 'Tags statistics:'
	print '  nodes:'
	for k, vals in pairs(sn) do
		for v, c in pairs(vals) do
			print('    ' .. k .. ' = ' .. v .. ' - ' .. c .. ' x')
		end
	end
	print '  ways:'
	for k, vals in pairs(sw) do
		for v, c in pairs(vals) do
			print('    ' .. k .. ' = ' .. v .. ' - ' .. c .. ' x')
		end
	end
	print '  areas:'
	for k, vals in pairs(sa) do
		for v, c in pairs(vals) do
			print('    ' .. k .. ' = ' .. v .. ' - ' .. c .. ' x')
		end
	end
end

callbacks{
	after = stats
}