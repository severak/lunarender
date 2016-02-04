-- part of LunaRender 
-- (c) 2015 Mikoláš Štrajt
-- MIT licensed

local _M = {}
local push = table.insert

-- loads LunaRender ruleset 
function _M.load(fname)
	local env = {}
	local rules = {}
	local ruleset, err
	
	rules.layers = {}
	rules.symbola_style = 'font-family: symbola; font-size: 18px; text-anchor: middle; fill: black; stroke: none; '
	
	setmetatable(env, { __index=_G})
	
	function env.rule(args)
		if not (args.style or args.class) and not (args.draw and args.draw=='symbola') then
			die('Missing style in rule.')
		end
		local match_rule
		if type(args.match)=='string' then
			match_rule = loadstring('return function(tags, zoom) return ' .. args.match .. ' end')
			if not match_rule then
				die('Error while compilig match rule: '..args.match)
			end
			args.match = match_rule()
		elseif type(args.match)=='function' then
			-- ok
		else
			die('Invalid type of match rule.')
		end
		if args.type=='node' then
			args.draw = args.draw or 'circle'
			if args.draw=='circle' then
				args.r = args.r or 2
			end
			if args.draw=='text' then
				args.textkey = args.textkey or 'name'
			end
			if args.draw=='symbola' then
				args.symbol = args.symbol or die 'Symbol not defined for symbola rule.'
			end
			if not (args.draw=='text' or args.draw=='circle' or args.draw=='symbola') then
				die 'Invalid drawtype of node.'
			end
		elseif args.type=='way' then
			
		elseif args.type=='area' then
			
		else
			die('Invalid type of rule.')
		end
		push(rules, args)
	end
	
	function env.callbacks(args)
		rules.callbacks = args
	end
	
	function env.force_zoom(z)
		rules.zoom = z
	end
	
	function env.background(fill)
		rules.background = fill
	end
	
	function env.layers(L)
		rules.layers = L
	end
	
	ruleset, err = loadfile(fname, 't', env)
	
	if not ruleset then
		die('Error while loading ruleset: ' .. err)
	end
	
	ruleset()
	
	return rules
end

return _M