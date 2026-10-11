--[[
Copyright (c) 2013 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

local Timer = {}
Timer.__index = Timer

function Timer:new()
    return setmetatable({ functions = {} }, Timer)
end

function Timer:update(dt)
    local to_remove = {}
    for handle, t in pairs(self.functions) do
        t.time = t.time - dt
        if t.time <= 0 then
            t.func()
            if t.after then
                t.time = t.after
            else
                table.insert(to_remove, handle)
            end
        end
    end
    for _, handle in ipairs(to_remove) do
        self.functions[handle] = nil
    end
end

function Timer:after(delay, func)
    local handle = {}
    self.functions[handle] = { time = delay, func = func }
    return handle
end

function Timer:every(delay, func)
    local handle = {}
    self.functions[handle] = { time = delay, after = delay, func = func }
    return handle
end

function Timer:cancel(handle)
    self.functions[handle] = nil
end

function Timer:clear()
    self.functions = {}
end

local _global = Timer:new()

return setmetatable({
    new = function() return Timer:new() end,
    update = function(dt) _global:update(dt) end,
    after = function(delay, func) return _global:after(delay, func) end,
    every = function(delay, func) return _global:every(delay, func) end,
    cancel = function(handle) _global:cancel(handle) end,
    clear = function() _global:clear() end
}, {
    __call = function(_, ...) return _global:update(...) end
})