local Class = require("lib.class")
local EstadoReglas = Class:extend()

function EstadoReglas:enter()
end

function EstadoReglas:update(dt)
end

function EstadoReglas:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("=== REGLAS DEL JUEGO ===", 70, 80)
    love.graphics.print("- Usa las Flechas para mover la mosca.", 50, 130)
    love.graphics.print("- Esquiva las ventanas que caen.", 50, 160)
    love.graphics.print("- Alcanza la comida arriba para sumar puntos.", 50, 190)
    love.graphics.print("- Junta " .. COMIDAS_OBJETIVO .. " comidas para ganar.", 50, 220)
    
    love.graphics.setColor(0, 1, 0)
    love.graphics.print("Presiona ESPACIO o ESC para volver al menú", 40, 280)
end

function EstadoReglas:keypressed(key)
    if key == "escape" or key == "return" or key == "space" then
        MaquinaEstados:cambiar("menu")
    end
end

return EstadoReglas