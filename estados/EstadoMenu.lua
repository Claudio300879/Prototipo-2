local Class = require("lib.class")
local EstadoMenu = Class:extend()

function EstadoMenu:enter()
end

function EstadoMenu:update(dt)
end

function EstadoMenu:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("=== MOSCA VS VENTANAS ===", 60, 100)
    love.graphics.print("1. Jugar (Espacio / Enter)", 100, 170)
    love.graphics.print("2. Ver Reglas del Juego", 100, 200)
    love.graphics.print("[ESC] Salir del juego", 100, 240)
end

function EstadoMenu:keypressed(key)
    if key == "1" or key == "return" or key == "space" then
        MaquinaEstados:cambiar("jugando")
    elseif key == "2" then
        MaquinaEstados:cambiar("reglas")
    elseif key == "escape" then
        love.event.quit()
    end
end

return EstadoMenu