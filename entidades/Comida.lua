local Class = require("lib.class")

local Comida = Class:extend()

function Comida:new(x, y, sprite)
    self.x = x or 80
    self.y = y or 25
    self.ancho = 8
    self.alto = 8
    self.origen_x = 4
    self.origen_y = 4
    self.sprite = sprite
    self.tipo = "comida"
end

function Comida:reposicionar(anchoPantalla, world)
    self.x = math.random(15, anchoPantalla - 15)
    if world then
        world:update(self, self.x - self.origen_x, self.y - self.origen_y)
    end
end

function Comida:draw()
    if self.sprite then
        local anchoOriginal = self.sprite:getWidth()
        local altoOriginal = self.sprite:getHeight()
        local escalaX = 16 / anchoOriginal
        local escalaY = 16 / altoOriginal

        love.graphics.draw(
            self.sprite,
            math.floor(self.x + 0.5),
            math.floor(self.y + 0.5),
            0,
            escalaX,
            escalaY,
            anchoOriginal / 2,
            altoOriginal / 2
        )
    end
end

return Comida