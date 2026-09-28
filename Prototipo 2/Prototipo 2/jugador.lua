Jugador = Class{}

function Jugador:init(x, y)
    self.x = x
    self.y = y
    self.ancho = 28
    self.alto = 24
    self.velocidad = 200
    self.fuerzaArrastre = 0
end

function Jugador:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('a') then
        self.x = self.x - self.velocidad * dt
    end
    if love.keyboard.isDown('right') or love.keyboard.isDown('d') then
        self.x = self.x + self.velocidad * dt
    end
    if love.keyboard.isDown('up') or love.keyboard.isDown('w') then
        self.y = self.y - self.velocidad * dt
    end
    if love.keyboard.isDown('down') or love.keyboard.isDown('s') then
        self.y = self.y + self.velocidad * dt
    end

    self.y = self.y + self.fuerzaArrastre * dt

    self.x = math.max(0, math.min(love.graphics.getWidth() - self.ancho, self.x))
end

function Jugador:draw()
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.ellipse('fill', self.x + 14, self.y + 14, 10, 8)
    
    love.graphics.setColor(0.8, 0.9, 1, 0.6)
    love.graphics.ellipse('fill', self.x + 8, self.y + 6, 8, 4)
    love.graphics.ellipse('fill', self.x + 20, self.y + 6, 8, 4)

    love.graphics.setColor(0.9, 0.1, 0.1)
    love.graphics.circle('fill', self.x + 10, self.y + 18, 3)
    love.graphics.circle('fill', self.x + 18, self.y + 18, 3)

    love.graphics.setColor(1, 1, 1)
end

function Jugador:getBox()
    return self.x, self.y, self.ancho, self.alto
end