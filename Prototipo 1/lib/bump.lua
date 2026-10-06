--[[
bump.lua v3.1.7 - Lua collision detection library for axis-aligned rectangles
Copyright (c) 2014 Enrique García Cota

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

local bump = {
  _VERSION     = 'bump v3.1.7',
  _URL         = 'https://github.com/kikito/bump.lua',
  _DESCRIPTION = 'A collision detection library for Lua',
  _LICENSE     = 'MIT'
}

local function rect_getNearestCorner(x, y, w, h, px, py)
  local nearestX = px < x and x or (px > x + w and x + w or px)
  local nearestY = py < y and y or (py > y + h and y + h or py)
  return nearestX, nearestY
end

local function rect_getSegmentIntersectionIndices(x,y,w,h, x1,y1,x2,y2, ti1,ti2)
  ti1, ti2 = ti1 or 0, ti2 or 1
  local dx, dy = x2 - x1, y2 - y1
  local nx, ny
  local p, q, r

  for i = 1, 4 do
    if     i == 1 then nx, ny, p, q = -1,  0, -dx, x1 - x
    elseif i == 2 then nx, ny, p, q =  1,  0,  dx, x + w - x1
    elseif i == 3 then nx, ny, p, q =  0, -1, -dy, y1 - y
    elseif i == 4 then nx, ny, p, q =  0,  1,  dy, y + h - y1
    end

    if p == 0 then
      if q < 0 then return nil end
    else
      r = q / p
      if p < 0 then
        if r > ti2 then return nil
        elseif r > ti1 then ti1 = r end
      else
        if r < ti1 then return nil
        elseif r < ti2 then ti2 = r end
      end
    end
  end

  return ti1, ti2
end

local function rect_detectCollision(x1,y1,w1,h1, x2,y2,w2,h2, goalX, goalY)
  goalX = goalX or x1
  goalY = goalY or y1

  local dx, dy = goalX - x1, goalY - y1
  local x, y, w, h = x2 - w1, y2 - h1, w1 + w2, h1 + h2

  local ti, nx, ny
  if dx == 0 and dy == 0 then
    local px, py = rect_getNearestCorner(x,y,w,h, x1,y1)
    ti = -math.max(math.abs(px - x1)/w1, math.abs(py - y1)/h1)
    if px == x then nx = -1 elseif px == x + w then nx = 1 else nx = 0 end
    if py == y then ny = -1 elseif py == y + h then ny = 1 else ny = 0 end
    return { item = nil, ti = ti, overlaps = true, normal = {x = nx, y = ny} }
  end

  local ti1, ti2 = rect_getSegmentIntersectionIndices(x,y,w,h, x1,y1, goalX,goalY, -math.huge, 1)

  if ti1 and ti1 < 1 and (ti1 >= 0 or (ti1 < 0 and ti2 > 0)) then
    local overlaps = ti1 < 0
    if overlaps then ti1 = 0 end

    local tx, ty = x1 + dx * ti1, y1 + dy * ti1
    if tx == x then nx = -1 elseif tx == x + w then nx = 1 else nx = 0 end
    if ty == y then ny = -1 elseif ty == y + h then ny = 1 else ny = 0 end

    return {
      ti = ti1,
      overlaps = overlaps,
      normal = {x = nx, y = ny},
      touch = {x = tx, y = ty}
    }
  end
end

local World = {}
World.__index = World

local defaultFilter = function() return "slide" end

function World:add(item, x,y,w,h)
  local rect = {x = x, y = y, w = w, h = h}
  self.rects[item] = rect
  return item
end

function World:remove(item)
  self.rects[item] = nil
end

function World:update(item, x,y,w,h)
  local rect = self.rects[item]
  if rect then
    rect.x, rect.y, rect.w, rect.h = x, y, w or rect.w, h or rect.h
  end
end

function World:move(item, goalX, goalY, filter)
  filter = filter or defaultFilter
  local rect = self.rects[item]
  local cols = {}
  
  for other, orect in pairs(self.rects) do
    if other ~= item then
      local response = filter(item, other)
      if response then
        local col = rect_detectCollision(rect.x, rect.y, rect.w, rect.h, orect.x, orect.y, orect.w, orect.h, goalX, goalY)
        if col then
          col.item = item
          col.other = other
          col.type = response
          table.insert(cols, col)
        end
      end
    end
  end

  rect.x, rect.y = goalX, goalY
  return goalX, goalY, cols, #cols
end

function bump.newWorld(cellSize)
  return setmetatable({ rects = {} }, World)
end

return bump