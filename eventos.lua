Signal.register('comida_atrapada', function(puntosActuales)
    if sonidos.comiendo then
        love.audio.stop(sonidos.comiendo)
        love.audio.play(sonidos.comiendo)
    end
end)

Signal.register('juego_perdido', function()
    if sonidos.fondo then love.audio.stop(sonidos.fondo) end
    if sonidos.derrota then love.audio.play(sonidos.derrota) end
    MaquinaEstados:cambiar("game_over")
end)

Signal.register('juego_ganado', function()
    if sonidos.fondo then love.audio.stop(sonidos.fondo) end
    if sonidos.victoria then love.audio.play(sonidos.victoria) end
    MaquinaEstados:cambiar("victoria")
end)