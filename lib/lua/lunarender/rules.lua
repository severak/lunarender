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
	
	setmetatable(env, { __index=_G})
	
	function env.rule(args)
		if not args.style then
			error('Missing style in rule.')
		end
		local match_rule
		if type(args.match)=='string' then
			match_rule = loadstring('return function(tags, zoom) return ' .. args.match .. ' end')
			if not match_rule then
				error('Error while compilig match rule: '..args.match)
			end
			args.match = match_rule()
		elseif type(args.match)=='function' then
			-- ok
		else
			error('Invalid type of match rule.')
		end
		if args.type=='node' then
			args.draw = args.draw or 'circle'
			if args.draw=='circle' then
				args.r = args.r or 2
			end
		elseif args.type=='way' then
			
		elseif args.type=='area' then
			
		else
			error('Invalid type of rule.')
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
	
	ruleset, err = loadfile(fname, 't', env)
	
	if not ruleset then
		error('Error while loading ruleset: ' .. err)
	end
	
	ruleset()
	
	return rules
end

return _M