-- part of LunaRender 
-- (c) 2015 Mikoláš Štrajt
-- MIT licensed

-- based on https://msdn.microsoft.com/en-us/library/bb259689.aspx

local _M = {}

local sin = math.sin
local pow = math.pow
local log = math.log
local pi = math.pi

--[[
 sinLatitude = sin(latitude * pi/180)

pixelX = ((longitude + 180) / 360) * 256 * 2 level

pixelY = (0.5 – log((1 + sinLatitude) / (1 – sinLatitude)) / (4 * pi)) * 256 * 2 level 
]]


-- computes pixel coords from wgs84
function _M.wgs84_to_px(lat, lon, zoom)
	local sinLat, x, y
	sinLat = sin(lat * pi/180)
	x = ( (lon + 180) / 360) * 256 * 2^zoom
	y = (0.5 - log( (1+sinLat) / (1-sinLat)) / (4*pi) ) * 256 * 2^zoom
	return x, y
end

return _M