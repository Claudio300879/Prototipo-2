local UI = {
    puntos = 0,
    objetivo = 3,
    oleadaActual = 1,
    mensajeNotificacion = "",
    tiempoNotificacion = 0
}

function UI.init()
    -- Suscribir la interfaz a eventos personalizados del juego
    if Signal then
        Signal.register('comida_atrapada', function(puntosActuales)
            UI.puntos = puntosActuales or (UI.puntos + 1)
            UI.mostrarMensaje("¡Comida Atrapada!", 1.5)
        end)

        Signal.register('actualizar_puntos', function(puntosActuales)
            UI.puntos = puntosActuales
        end)

        Signal.register('cambiar_oleada', function(numOleada)
            UI.oleadaActual = numOleada
        end)

        Signal.register('notificar_evento', function(texto, duracion)
            UI.mostrarMensaje(texto, duracion or 2)
        end)
    end
end

function UI.mostrarMensaje(texto, duracion)
    UI.mensajeNotificacion = texto
    UI.tiempoNotificacion = duracion or 2
end

function UI.update(dt)
    if UI.tiempoNotificacion > 0 then
        UI.tiempoNotificacion = UI.tiempoNotificacion - dt
        if UI.tiempoNotificacion <= 0 then
            UI.mensajeNotificacion = ""
        end
    end
end

function UI.draw()
    love.graphics.setColor(1, 1, 1, 1)
    
    -- Dibujar marcador unificado arriba a la izquierda (evita superposiciones)
    local textoHUD = string.format("Comida: %d / %d  |  Oleada: %d", UI.puntos, UI.objetivo, UI.oleadaActual)
    love.graphics.print(textoHUD, 10, 10)
    
    -- Dibujar notificación central si existe
    if UI.mensajeNotificacion ~= "" then
        love.graphics.setColor(1, 1, 0, 1) -- Texto amarillo para notificaciones de eventos
        love.graphics.print(UI.mensajeNotificacion, 10, 30)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return UI