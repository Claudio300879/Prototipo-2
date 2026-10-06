local Class = require("lib.class")
local EstadoPausa = Class:extend()

function EstadoPausa:enter()
    if sonidos.fondo then sonidos.fondo:pause() end
end

function EstadoPausa:update(dt)
end

function EstadoPausa:draw()
    -- Dibujamos la pantalla del juego de fondo
    MaquinaEstados.estados["jugando"]:draw()

    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, pantalla.ancho * pantalla.escala, pantalla.alto * pantalla.escala)
    
    love.graphics.setColor(1, 1, 0)
    love.graphics.print("PAUSA", (pantalla.ancho * pantalla.escala) / 2 - 25, (pantalla.alto * pantalla.escala) / 2 - 30)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Presiona P para reanudar", (pantalla.ancho * pantalla.escala) / 2 - 90, (pantalla.alto * pantalla.escala) / 2 + 10)
    love.graphics.print("Presiona R para reiniciar", (pantalla.ancho * pantalla.escala) / 2 - 90, (pantalla.alto * pantalla.escala) / 2 + 30)
    love.graphics.print("Presiona ESC para salir al menú", (pantalla.ancho * pantalla.escala) / 2 - 100, (pantalla.alto * pantalla.escala) / 2 + 50)
end

function EstadoPausa:keypressed(key)
    if key == "p" then
        desdePausa = true
        MaquinaEstados:cambiar("jugando")
    elseif key == "r" then
        MaquinaEstados:cambiar("jugando")
    elseif key == "escape" then
        if sonidos.fondo then love.audio.stop(sonidos.fondo) end
        MaquinaEstados:cambiar("menu")
    end
end

return EstadoPausa