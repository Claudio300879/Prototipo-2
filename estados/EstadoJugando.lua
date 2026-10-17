local Class = require("lib.class")
local EstadoJugando = Class:extend()

function EstadoJugando:init()
    self.mapa = STI("mapas/mapa1.lua")
end

function EstadoJugando:enter()
    if not self.mapa then
        self.mapa = STI("mapas/mapa1.lua")
    end

    if not desdePausa then
        ReiniciarJuego()
        Signal.emit('cambiar_oleada', 1)
        Signal.emit('actualizar_puntos', 0)
    else
        desdePausa = false
        if sonidos.fondo then sonidos.fondo:play() end
    end
end

function EstadoJugando:update(dt)
    if self.mapa then
        self.mapa:update(dt)
    end

    if mostrarBien or gestorOleadas.enPausaOleada then return end

    local cols, len = mosca:update(dt, world, pantalla.ancho, pantalla.alto)

    for i = 1, len do
        local col = cols[i]
        if col.other.tipo == "comida" then
            puntos = puntos + 1
            
            if puntos >= COMIDAS_OBJETIVO then
                gestorOleadas:detener()
                Signal.emit('juego_ganado')
            else
                Signal.emit('comida_atrapada', puntos)
                mostrarBien = true
                Timer.after(1.2, function()
                    mostrarBien = false
                    ReiniciarPosiciones()
                    
                    local nuevaOleada = puntos + 1
                    gestorOleadas:avanzarOleada(nuevaOleada)
                    Signal.emit('cambiar_oleada', nuevaOleada)
                end)
            end
        end
    end

    for i = #ventanas, 1, -1 do
        local v = ventanas[i]
        v:update(dt, world, mosca)

        if v.y > pantalla.alto then
            world:remove(v)
            table.remove(ventanas, i)
        end
    end

    if mosca.y + mosca.origen_y >= pantalla.alto then
        gestorOleadas:detener()
        Signal.emit('juego_perdido')
    end
end

function EstadoJugando:draw()
    love.graphics.setCanvas(lienzo)
        love.graphics.clear(0.2, 0.2, 0.25)

        if self.mapa then
            self.mapa:draw()
        end

        comida:draw()

        for _, v in ipairs(ventanas) do
            v:draw()
        end

        mosca:draw()

    love.graphics.setCanvas()
    love.graphics.draw(lienzo, 0, 0, 0, pantalla.escala, pantalla.escala)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print("P: Pausa | R: Reiniciar | ESC: Menú", 10, (pantalla.alto * pantalla.escala) - 25)

    if mostrarBien then
        love.graphics.setColor(0, 1, 0)
        love.graphics.print("¡BIEN!", (pantalla.ancho * pantalla.escala) / 2 - 25, (pantalla.alto * pantalla.escala) / 2)
    end

    gestorOleadas:draw()
end

function EstadoJugando:keypressed(key)
    if key == "p" then
        MaquinaEstados:cambiar("pausa")
    elseif key == "r" then
        ReiniciarJuego()
        Signal.emit('cambiar_oleada', 1)
        Signal.emit('actualizar_puntos', 0)
    elseif key == "escape" then
        gestorOleadas:detener()
        if sonidos.fondo then love.audio.stop(sonidos.fondo) end
        MaquinaEstados:cambiar("menu")
    end
end

return EstadoJugando