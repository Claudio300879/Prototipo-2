local Class = require("lib.class")

local Mosca = Class:extend()

function Mosca:new(x, y, velocidad)
    self.x = x or 80
    self.y = y or 215
    self.ancho = 10
    self.alto = 10
    self.origen_x = 5
    self.origen_y = 5
    self.velocidad = velocidad or 85
    self.animacion = nil
end

function Mosca:setAnimacion(anim)
    self.animacion = anim
end

function Mosca:update(dt, world, limiteAncho, limiteAlto)
    local dx, dy = 0, 0

    if love.keyboard.isDown("left") then
        dx = -self.velocidad * dt
    elseif love.keyboard.isDown("right") then
        dx = self.velocidad * dt
    end

    if love.keyboard.isDown("up") then
        dy = -self.velocidad * dt
    elseif love.keyboard.isDown("down") then
        dy = self.velocidad * dt
    end

    local cols, len = {}, 0

    -- Si se mueve, actualiza la  posición mediante Bump
    if dx ~= 0 or dy ~= 0 then
        local metaX = math.max(self.origen_x, math.min(limiteAncho - self.origen_x, self.x + dx))
        local metaY = math.max(self.origen_y, math.min(limiteAlto + 20, self.y + dy))

        
        local actualX, actualY, c, l = world:move(self, metaX - self.origen_x, metaY - self.origen_y, function(item, other)
            if other.tipo == "ventana" then
                return "touch"
            elseif other.tipo == "comida" then
                return "cross"
            end
            return nil
        end)

        self.x = actualX + self.origen_x
        self.y = actualY + self.origen_y
        cols, len = c, l
    end

    -- Actualiza la animación
    if self.animacion then
        ActualizarAnimacion(self.animacion, dt, false)
    end

    return cols, len
end

function Mosca:draw()
    if self.animacion and self.animacion.activado then
        local i = math.floor(self.animacion.indice)
        local anchoFrameReal = self.animacion.spritesheet:getWidth() / 2
        local altoFrameReal = self.animacion.spritesheet:getHeight()
        local escalaX = 16 / anchoFrameReal
        local escalaY = 16 / altoFrameReal
        
        love.graphics.draw(
            self.animacion.spritesheet,
            self.animacion.quads[i],
            math.floor(self.x + 0.5),
            math.floor(self.y + 0.5),
            0,
            escalaX,
            escalaY,
            anchoFrameReal / 2,
            altoFrameReal / 2
        )
    end
end

return Mosca