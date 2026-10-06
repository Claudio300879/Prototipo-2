local Class = require("lib.class")

local Ventana = Class:extend()

function Ventana:new(x, y, velocidad, sprite)
    self.x = x or 0
    self.y = y or -40
    self.ancho = 45
    self.alto = 35
    self.velocidad = velocidad or 70
    self.sprite = sprite
    self.tipo = "ventana"
end

function Ventana:update(dt, world, mosca)
    local desplazamientoY = self.velocidad * dt
    self.y = self.y + desplazamientoY

    if world then
        world:update(self, self.x, self.y)

        -- Si la ventana al caer toca a la mosca, la empuja hacia abajo
        if mosca then
            local mx = mosca.x - mosca.origen_x
            local my = mosca.y - mosca.origen_y
            
            -- Verificar si el rectángulo de la ventana colisiona con el de la mosca
            if self.x < mx + mosca.ancho and
               self.x + self.ancho > mx and
               self.y < my + mosca.alto and
               self.y + self.alto > my then
                
                -- Arrastra a la mosca hacia abajo
                mosca.y = mosca.y + desplazamientoY
                world:update(mosca, mosca.x - mosca.origen_x, mosca.y - mosca.origen_y)
            end
        end
    end
end

function Ventana:draw()
    if self.sprite then
        local escalaX = self.ancho / self.sprite:getWidth()
        local escalaY = self.alto / self.sprite:getHeight()
        love.graphics.draw(
            self.sprite,
            math.floor(self.x + 0.5),
            math.floor(self.y + 0.5),
            0,
            escalaX,
            escalaY
        )
    else
        love.graphics.setColor(0.3, 0.6, 0.9, 0.8)
        love.graphics.rectangle("fill", self.x, self.y, self.ancho, self.alto)
        love.graphics.setColor(1, 1, 1)
    end
end

return Ventana