local Signal = require 'lib.signal'

Enemigo = Class{}

-- =================== INICIALIZACION ===================
function Enemigo:init(x, y, img, v)
    self.x = x
    self.y = y
    self.sprite = love.graphics.newImage(img)
    self.ancho = self.sprite:getWidth()
    self.alto  = self.sprite:getHeight()
    self.origen_x = self.ancho / 2
    self.origen_y = self.alto / 2
    self.hitbox_x = 0
    self.hitbox_y = 0
    self.velocidad = v

    -- Estado de congelamiento y color predeterminado
    self.detenido = false
    self.color = {1, 1, 1, 1}

    -- Registro de oyentes con HUMP Signal
    self.signal_detener = Signal.register("detenerEnemigos", function() self:Detener() end)
    self.signal_restaurar = Signal.register("restaurarEnemigos", function() self:Restaurar() end)
end

-- =================== RESPUESTA A EVENTOS ===================
function Enemigo:Detener()
    self.detenido = true
    self.color = {0, 0, 1, 0.5} -- Cambia a azul semitransparente
end

function Enemigo:Restaurar()
    self.detenido = false
    self.color = {1, 1, 1, 1} -- Vuelve a su color normal
end

function Enemigo:Eliminar()
    -- Remueve las suscripciones al destruir el objeto para evitar fugas de memoria
    Signal.remove("detenerEnemigos", self.signal_detener)
    Signal.remove("restaurarEnemigos", self.signal_restaurar)
end

-- =================== ACTUALIZAR ===================
function Enemigo:Actualizar(x, y, a, dt)
    -- Si el enemigo fue detenido por la señal, interrumpe el movimiento
    if self.detenido then return end

    self.hitbox_x = self.x - self.origen_x
    self.hitbox_y = self.y - self.origen_y
end

-- =================== RENDERIZADO ===================
function Enemigo:Dibujar()
    love.graphics.setColor(self.color)
    love.graphics.draw(
        self.sprite,
        redondear(self.x),
        redondear(self.y),
        0,
        1,
        1,
        self.origen_x,
        self.origen_y
    )
    love.graphics.setColor(1, 1, 1, 1) -- Resetea el color neutro
end

-- =================== DEPURAR ===================
function Enemigo:Debug()
   
    love.graphics.rectangle("line", redondear(self.hitbox_x), redondear(self.hitbox_y), self.ancho, self.alto)
    
   
end