local Class = require("lib.class")
local EstadoVictoria = Class:extend()

function EstadoVictoria:enter()
end

function EstadoVictoria:update(dt)
end

function EstadoVictoria:draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.print("¡JUEGO COMPLETADO!", (pantalla.ancho * pantalla.escala) / 2 - 80, (pantalla.alto * pantalla.escala) / 2 - 20)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Presiona Espacio o Enter para volver al menú", (pantalla.ancho * pantalla.escala) / 2 - 160, (pantalla.alto * pantalla.escala) / 2 + 20)
end

function EstadoVictoria:keypressed(key)
    if key == "r" or key == "space" or key == "return" or key == "escape" then
        MaquinaEstados:cambiar("menu")
    end
end

return EstadoVictoria