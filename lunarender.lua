--- Lunarender
-- @author Mikoláš Štrajt
-- @copyright 2015-16
-- @license MIT

local pretty = require 'pl.pretty'

local function parse_args(args)
	local params = {}
	for _, param in ipairs(args) do
		local key, val
		if string.match(param, '^[/-]*[%w_-]+=.+$') then
			key, val = string.match(param, '^[/-]+([%w_-]+)=(.+)$')
			if val=='true' then
				val = true
			elseif val=='false' then
				val = 'false'
			elseif tonumber(val) then
				val = tonumber(val)
			end
			params[key] = val
		elseif string.match(param, '^[/-]*[%w_-]+$') then
			key = string.match(param, '^[/-]*([%w_-]+)$')
			params[key] = true
		end
	end
	return params
end

local function get_module(name)
  local ok, ret
  ok, ret = pcall(require, name)
  if ok then
    return ret:new()
  end
end

local function die(msg, heading)
  io.stderr:write( (heading or 'Error') .. ':\n')
  io.stderr:write(msg)
  os.exit(2)
end

local params, reader, writer, ok, errormsg 

print 'lunarender 2.0'
params = parse_args(arg)
params.reader = params.reader or params.r or die('Missing --reader parameter')
params.writer = params.writer or params.w or die('Missing --writer parameter')

reader = get_module('lunarender.reader.'..params.reader)
if not reader then
  die('Unable to load reader "'..params.reader..'"')
end

ok, errormsg = reader:set_params(params)
if not ok then
  die(errormsg, 'File reading error')
end

print(pretty.dump(reader:read()))