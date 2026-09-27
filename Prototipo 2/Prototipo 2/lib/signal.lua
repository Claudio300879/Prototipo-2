--[[
Copyright (c) 2012-2013 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

EXCEPT AS CONTAINED IN THIS NOTICE, THE NAME(S) OF THE ABOVE COPYRIGHT HOLDERS
SHALL NOT BE USED IN ADVERTISING OR OTHERWISE TO PROMOTE THE SALE, USE OR
OTHER DEALINGS IN THIS SOFTWARE WITHOUT PRIOR WRITTEN AUTHORIZATION.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

local Signal = {}
Signal.__index = Signal

function Signal.new()
	return setmetatable({ registry = {} }, Signal)
end

function Signal:register(s, f)
	if not self.registry[s] then
		self.registry[s] = {}
	end
	table.insert(self.registry[s], f)
	return f
end

function Signal:emit(s, ...)
	if not self.registry[s] then return end
	for _, f in ipairs(self.registry[s]) do
		f(...)
	end
end

function Signal:remove(s, f)
	if not self.registry[s] then return end
	for i = #self.registry[s], 1, -1 do
		if self.registry[s][i] == f then
			table.remove(self.registry[s], i)
		end
	end
end

function Signal:clear(s)
	if s then
		self.registry[s] = nil
	else
		self.registry = {}
	end
end

-- Instancia global por defecto
local default = Signal.new()

return setmetatable({
	new      = Signal.new,
	register = function(...) return default:register(...) end,
	emit     = function(...) return default:emit(...) end,
	remove   = function(...) return default:remove(...) end,
	clear    = function(...) return default:clear(...) end,
}, { __call = function(_, ...) return Signal.new(...) end })