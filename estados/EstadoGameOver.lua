local Class = require("lib.class")
local EstadoGameOver = Class:extend()

function EstadoGameOver:enter()
end

function EstadoGameOver:update(dt)
end

function EstadoGameOver:draw()
    love.graphics.setColor(1, 0, 0)
    love.graphics.print("GAME OVER", (pantalla.ancho * pantalla.escala) / 2 - 45, (pantalla.alto * pantalla.escala) / 2 - 20)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Presiona R, Espacio o Enter para volver al menú", (pantalla.ancho * pantalla.escala) / 2 - 180, (pantalla.alto * pantalla.escala) / 2 + 20)
end

function EstadoGameOver:keypressed(key)
    if key == "r" or key == "space" or key == "return" or key == "escape" then
        MaquinaEstados:cambiar("menu")
    end
end

return EstadoGameOver