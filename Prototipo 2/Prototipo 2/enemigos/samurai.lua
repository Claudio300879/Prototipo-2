Samurai = Class{__includes = Enemigo}

function Samurai:Actualizar(x,y,a,dt)
    -- Persecución
    local dist_x = math.abs(self.x - x)
    local dist_y = math.abs(self.y - y)

    if dist_x > dist_y then
        if dist_x > a then
            if self.x < x then
                self.x = self.x + (self.velocidad * dt)
            elseif self.x > x then
                self.x = self.x - (self.velocidad * dt)
            end
        end
    else
        if dist_y > a then
            if self.y < y then
                self.y = self.y + (self.velocidad * dt)
            elseif self.y > y then
                self.y = self.y - (self.velocidad * dt)
            end
        end
    end

    self.hitbox_x = self.x - self.origen_x
    self.hitbox_y = self.y - self.origen_y
end