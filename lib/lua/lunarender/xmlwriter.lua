-- part of LunaRender 
-- (c) 2015 Mikoláš Štrajt
-- MIT licensed

local _M = {}

local push = table.insert

-- XML character entity escaping and unescaping
local function escape(s)
  local map = { ['<'] = '&lt;',
                ['>'] = '&gt;',
                ['&'] = '&amp;',
                ['"'] = '&quot;',
                ['\'']= '&#39;' }
  return s:gsub("[<>&\"']", function(x) return map[x] end)
end

-- writes data as XML
function _M.write(data)
	local out={}
	
	local function node(out, data)
		push(out, '<')
		push(out, data[0])
		for k,v in pairs(data) do
			if type(k)=='string' then
				push(out, ' ')
				push(out, k )
				push(out, '="')
				push(out, tostring(v) )
				push(out, '"')
			end
		end
		if #data>0 then
			push(out, '>\n')
			for k,v in ipairs(data) do
				if type(v)=='table' then
					node(out, v)
				elseif type(v)=='string' then
					push(out, v)
				end
			end
			push(out, '</')
			push(out, data[0])
			push(out, '>\n')
		else
			push(out, '/>\n')
		end
	end
	
	node(out, data)
	
	return table.concat(out)
end

return _M