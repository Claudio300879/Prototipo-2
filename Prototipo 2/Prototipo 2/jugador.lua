Jugador = Class{}
-- =================== INICIALIZACION ===================
function Jugador:init(x, y, v)
    self.sprite = love.graphics.newImage("img/Ninja.png")
    self.ancho = self.sprite:getWidth()
    self.alto  = self.sprite:getHeight()
    self.origen_x = self.ancho/2
    self.origen_y = self.alto/2
    self.x = x
    self.y = y
    self.hitbox_x =  self.x - self.origen_x
    self.hitbox_y =  self.y - self.origen_y
    self.velocidad = v
end
-- =================== ACTUALIZAR ===================
function Jugador:Actualizar(dt)

    if love.keyboard.isDown("right") then
        self.x = self.x + (self.velocidad * dt)
    elseif love.keyboard.isDown("left") then
        self.x = self.x - (self.velocidad * dt)
    elseif love.keyboard.isDown("down") then
        self.y = self.y + (self.velocidad * dt)
    elseif love.keyboard.isDown("up") then
        self.y = self.y - (self.velocidad * dt)
    end

    self.hitbox_x = self.x - self.origen_x
    self.hitbox_y = self.y - self.origen_y
end
-- =================== Colision ===================
function Jugador:Colision(otro_hitbox_x,otro_hitbox_y, otro_ancho, otro_alto)
   return  self.hitbox_x < otro_hitbox_x + otro_ancho and
           otro_hitbox_x < self.hitbox_x + self.ancho and
           self.hitbox_y < otro_hitbox_y + otro_alto and
           otro_hitbox_y < self.hitbox_y + self.alto
end
-- =================== RENDERIZADO ===================
function Jugador:Dibujar()
    love.graphics.setColor(1, 1, 1, 1) -- Resetea color a blanco neutro
    love.graphics.draw(
        self.sprite,
        math.floor(self.x),
        math.floor(self.y),
        0,
        1,
        1,
        self.origen_x,
        self.origen_y
    )
end