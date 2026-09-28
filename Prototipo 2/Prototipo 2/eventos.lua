Popo = Class{}

function Popo:init()
    self.ancho = 22
    self.alto = 22
    self:reubicar()
end

function Popo:reubicar()
    local sw = love.graphics.getWidth()
    self.x = math.random(30, sw - 50)
    self.y = math.random(40, 90)
end

function Popo:draw()
    love.graphics.setColor(0.5, 0.3, 0.1)
    love.graphics.circle('fill', self.x + 11, self.y + 14, 10)
    love.graphics.circle('fill', self.x + 11, self.y + 8, 7)
    love.graphics.circle('fill', self.x + 11, self.y + 3, 4)
    love.graphics.setColor(1, 1, 1)
end

function Popo:colisiona(jugador)
    local jx, jy, jancho, jalto = jugador:getBox()
    return self.x < jx + jancho and
           self.x + self.ancho > jx and
           self.y < jy + jalto and
           self.y + self.alto > jy
end