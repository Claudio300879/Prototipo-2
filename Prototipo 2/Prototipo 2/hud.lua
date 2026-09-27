HUD = Class{}

function HUD:init()
    self.texto_vida = ""
    self.depurar = false

    love.handlers.modoDebug = function() 
        self:DebugToggle() 
    end
    
    love.handlers.actualizarVidas = function(vidas) 
        self:ActualizarVidas(vidas) 
    end
end

function HUD:DebugToggle()
    self.depurar = not self.depurar
end

function HUD:ActualizarVidas(vidas)
    self.texto_vida = "x" .. vidas
end

function HUD:Draw()
    -- Vidas en la interfaz si lo necesitas
end

function HUD:DrawGameData()
    if not self.depurar then return end

    love.graphics.setColor(0, 1, 0)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
    if atrapado then
        love.graphics.print("ATRAPADO", 100, 10)
    end
    love.graphics.setColor(1, 1, 1)
end

function HUD:DrawHitboxes()
    if not self.depurar then return end

    love.graphics.setColor(1, 0, 0)
    -- Hitbox del jugador
    if jugador then
        love.graphics.rectangle("line", redondear(jugador.hitbox_x), redondear(jugador.hitbox_y), jugador.ancho, jugador.alto)
        love.graphics.circle("fill", redondear(jugador.x), redondear(jugador.y), 1)
    end

    -- Hitboxes de enemigos
    for _, enemigo in ipairs(enemigos) do
        enemigo:Debug()
    end

    love.graphics.setColor(1, 1, 1, 1)
end