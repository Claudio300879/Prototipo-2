Proyectil = class{}

function Proyectil:init(x, y, angulo, velocidad)
    self.x = x
    self.y = y
    self.radio = 4
    self.dx = math.cos(angulo)
    self.dy = math.sin(angulo)
    self.velocidad = velocidad
    self.color = {math.random(), math.random(), math.random()}
end

function Proyectil:Actualizar(dt)
    self.x = self.x + self.dx * self.velocidad * dt
    self.y = self.y + self.dy * self.velocidad * dt
end

function Proyectil:Dibujar()
    --  color aleatorio asignado al proyectil
    love.graphics.setColor(self.color[1], self.color[2], self.color[3], 1)
    
    -- Dibuja el proyectil como un círculo relleno
    love.graphics.circle("fill", math.floor(self.x), math.floor(self.y), self.radio)
    
    -- resetea el color a blanco  del proyectil para no teñir los siguientes elementos dibujados
    love.graphics.setColor(1, 1, 1, 1)
end