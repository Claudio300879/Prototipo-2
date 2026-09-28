Enemigo = Class{}

function Enemigo:init(x, y, ancho, alto, fuerza)
    self.x = x
    self.y = y
    self.ancho = ancho or 70
    self.alto = alto or 60
    self.fuerza = fuerza or 150
    self.activa = true
end

function Enemigo:update(dt)
end

function Enemigo:draw()
    love.graphics.setColor(0.4, 0.5, 0.7)
    love.graphics.rectangle('fill', self.x, self.y, self.ancho, self.alto)
    
    love.graphics.setColor(0.8, 0.9, 1)
    love.graphics.rectangle('fill', self.x + 4, self.y + 4, self.ancho / 2 - 6, self.alto / 2 - 6)
    love.graphics.rectangle('fill', self.x + self.ancho / 2 + 2, self.y + 4, self.ancho / 2 - 6, self.alto / 2 - 6)
    love.graphics.rectangle('fill', self.x + 4, self.y + self.alto / 2 + 2, self.ancho / 2 - 6, self.alto / 2 - 6)
    love.graphics.rectangle('fill', self.x + self.ancho / 2 + 2, self.y + self.alto / 2 + 2, self.ancho / 2 - 6, self.alto / 2 - 6)

    love.graphics.setColor(0.7, 0.7, 0.8)
    love.graphics.rectangle('fill', self.x - 4, self.y + self.alto, self.ancho + 8, 6)

    love.graphics.setColor(1, 1, 1)
end

function Enemigo:colisiona(jugador)
    local jx, jy, jancho, jalto = jugador:getBox()
    return self.x < jx + jancho and
           self.x + self.ancho > jx and
           self.y < jy + jalto and
           self.y + self.alto > jy
end