require 'dependencias'

function love.load()
    math.randomseed(os.time())
    
    gMaquinaEstados = MaquinaEstados({
        ['inicio'] = function() return EstadoInicio() end,
        ['jugando'] = function() return EstadoJugando() end,
        ['gameover'] = function() return EstadoGameOver() end,
        ['victoria'] = function() return EstadoVictoria() end
    })

    gMaquinaEstados:cambiar('inicio')
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    love.keyboard.keysPressed[key] = true
    gMaquinaEstados:keypressed(key)
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] == true
end

function love.update(dt)
    gMaquinaEstados:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    love.graphics.clear(0.18, 0.18, 0.23)
    gMaquinaEstados:draw()
end