Samurai = Class{__includes = Enemigo}

function Samurai:init(x, y, ancho, alto)
    Enemigo.init(self, x, y, ancho or 70, alto or 60, 180)
    self.vx = 60
end

function Samurai:update(dt)
    self.x = self.x + self.vx * dt
    if self.x <= 20 or self.x + self.ancho >= love.graphics.getWidth() - 20 then
        self.vx = -self.vx
    end
end