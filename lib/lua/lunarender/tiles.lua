local tiles={}

local function num2deg(x, y, z)
    local n = 2 ^ z
    local lon_deg = x / n * 360.0 - 180.0
    local lat_rad = math.atan(math.sinh(math.pi * (1 - 2 * y / n)))
    local lat_deg = lat_rad * 180.0 / math.pi
    return lon_deg, lat_deg
end


function tiles.generate(params)
	local zoom, x, y, zoom_from, zoom_to, x_from, x_to, y_from, y_to
	local input_name = params.input or error 'Missing input file.'
	local rules = params.rules or 'rules/default.lua'
	local workdir = 'wd'
	local output = params.output or 'out'
	
	zoom_from = params.zoom_from or params.zoom or error 'Missing zoom_from in params!'
	zoom_to = params.zoom_to or params.zoom or error 'Missing zoom_to in params!'
	
	y_from = params.from_y or error 'Missing from_y'
	x_from = params.from_x or error 'Missing from_x'
	
	
	y_to = params.to_y or error 'Missing to_y'
	x_to = params.to_x or error 'Missing to_x'
	
	os.execute('md '..workdir..' > nul 2> nul')
	
	for zoom=zoom_from, zoom_to do
		for y=y_from, y_to do
			os.execute('md "'..output..'/'..zoom..'/'..y..'"  > nul 2> nul')
			for x=x_from, x_to do
				print('Rendering '..zoom..'/'..y..'/'..x)
				
				local tfx, tfy, ttx, tty, tmpname
				
				tmpname = zoom ..'_'..y..'_'..x
				
				tfx, tfy = num2deg(y+1, x+1, zoom)
				ttx, tty = num2deg(y, x, zoom)
				
				-- data selection
				os.execute('osmconvert '..input_name..' -b='..ttx..','..tfy..','..tfx..','..tty..' -o='..workdir..'/'..tmpname..'.osm --complete-ways > nul 2> nul')
				
				-- rendering
				os.execute('lunarender '..workdir..'/'..tmpname..'.osm '.. rules .. ' ' .. zoom .. ' > nul 2> nul')
				
				-- svg2png
				os.execute('convert '..workdir..'/'..tmpname..'.osm.svg '..output..'/'..zoom..'/'..y..'/'..x..'.png')
				
			end
		end
	end
	
	
end


return tiles