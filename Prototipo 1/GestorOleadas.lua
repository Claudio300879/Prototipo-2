local Class = require("lib.class")

local GestorOleadas = Class:extend()

function GestorOleadas:new()
    self.oleadaActual = 1
    self.enPausaOleada = false
    self.textoOleada = ""
    self.timerHandle = nil
    
    self.intervaloBase = 1.4
    self.velMinBase = 60
    self.velMaxBase = 85
end

function GestorOleadas:iniciar(numOleada)
    self.oleadaActual = numOleada or 1
    self:iniciarOleada()
end

function GestorOleadas:iniciarOleada()
    self.enPausaOleada = true
    self.textoOleada = "OLEADA " .. self.oleadaActual

    -- Pausa de 1.5 segundos antes de lanzar las ventanas
    Timer.after(1.5, function()
        self.enPausaOleada = false
        self:programarSpawner()
    end)
end

function GestorOleadas:programarSpawner()
    local intervaloActual = math.max(0.5, self.intervaloBase - (self.oleadaActual - 1) * 0.25)
    
    if self.timerHandle then
        Timer.cancel(self.timerHandle)
    end

    self.timerHandle = Timer.every(intervaloActual, function()
        if MaquinaEstados.actual == MaquinaEstados.estados["jugando"] and not mostrarBien and not self.enPausaOleada then
            self:generarVentana()
        end
    end)
end

function GestorOleadas:generarVentana()
    local x = math.random(2, pantalla.ancho - 47)
    local bonusVel = (self.oleadaActual - 1) * 15
    local vel = math.random(self.velMinBase + bonusVel, self.velMaxBase + bonusVel)
    
    local nuevaVentana = Ventana(x, -40, vel, ventanaSprite)
    table.insert(ventanas, nuevaVentana)
    world:add(nuevaVentana, nuevaVentana.x, nuevaVentana.y, nuevaVentana.ancho, nuevaVentana.alto)
end

function GestorOleadas:avanzarOleada(nuevaOleada)
    self.oleadaActual = nuevaOleada
    self:iniciarOleada()
end

function GestorOleadas:detener()
    if self.timerHandle then
        Timer.cancel(self.timerHandle)
        self.timerHandle = nil
    end
end

function GestorOleadas:draw()
    if self.enPausaOleada then
        love.graphics.setColor(1, 1, 0)
        love.graphics.print(self.textoOleada, (pantalla.ancho * pantalla.escala) / 2 - 35, (pantalla.alto * pantalla.escala) / 2 - 10)
        love.graphics.setColor(1, 1, 1)
    end
end

return GestorOleadas()