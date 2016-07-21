--- Base object for Lunarender.
-- Provides simple inheritence.
--
-- @module lunarender.object
-- @author Mikoláš Štrajt
-- @copyright 2016
-- @license MIT

local object = {}

--- Extends class.
function object:extend()
  return setmetatable({}, {__index = self})
end

--- Creates new instance of object.
function object:new(...)
  local obj = {}
  setmetatable(obj, {__index = self})
  if type(obj.init)=='function' then
    obj:init(...)
  end
  return obj
end

return object