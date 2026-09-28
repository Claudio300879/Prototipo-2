HUD = Class{}

function HUD:init() end

function HUD:draw(recolectados, meta)
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Comidas: " .. tostring(recolectados) .. " / " .. tostring(meta), 10, 10)
    love.graphics.print("P: Pausa | R: Reiniciar | ESC: Menú", 10, love.graphics.getHeight() - 25)
end