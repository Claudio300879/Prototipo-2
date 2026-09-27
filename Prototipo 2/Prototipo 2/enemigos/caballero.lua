Caballero = Class{__includes = Enemigo}

function Caballero:init(x, y, img, v)

    Enemigo.init(self, x, y, img, v)

    self.direccion = 1
    self.temporizador = 0
    self.tiempo_cambio = 2
end

function Caballero:Actualizar(x, y, a, dt)

    self.x = self.x + (self.velocidad * self.direccion * dt)
    self.temporizador = self.temporizador + dt

    if self.temporizador >= self.tiempo_cambio then
        self.direccion = self.direccion * -1
        self.temporizador = 0
    end

    self.hitbox_x = self.x - self.origen_x
    self.hitbox_y = self.y - self.origen_y
end