-- ==========================================
-- ESTADO MENU
-- ==========================================
EstadoMenu = Class{}

function EstadoMenu:init()
    self.opciones = { "Jugar", "Objetivo", "Controles" }
    self.seleccion = 1
    self.pantalla = "menu"
end

function EstadoMenu:keypressed(key)
    if self.pantalla == "menu" then
        if key == "up" or key == "w" then
            self.seleccion = self.seleccion - 1
            if self.seleccion < 1 then self.seleccion = #self.opciones end
        elseif key == "down" or key == "s" then
            self.seleccion = self.seleccion + 1
            if self.seleccion > #self.opciones then self.seleccion = 1 end
        elseif key == "return" or key == "space" then
            if self.seleccion == 1 then
                gMaquinaEstados:cambiar("jugando")
            elseif self.seleccion == 2 then
                self.pantalla = "objetivo"
            elseif self.seleccion == 3 then
                self.pantalla = "controles"
            end
        end
    else
        if key == "escape" or key == "return" or key == "space" then
            self.pantalla = "menu"
        end
    end
end

function EstadoMenu:draw()
    if self.pantalla == "menu" then
        -- Título principal
        love.graphics.setColor(1, 0.8, 0.2, 1) -- Dorado
        love.graphics.printf("PROTOTIPO 2", 0, 15, ventana.ancho, "center")
        love.graphics.setColor(1, 1, 1, 1)
        --love.graphics.printf("ARENA 2D", 0, 27, ventana.ancho, "center")

        -- Opciones del Menú
        for i, opc in ipairs(self.opciones) do
            if i == self.seleccion then
                love.graphics.setColor(0.2, 1, 0.3, 1) -- Verde resaltado
                love.graphics.printf("> " .. opc .. " <", 0, 52 + (i * 16), ventana.ancho, "center")
            else
                love.graphics.setColor(0.7, 0.7, 0.7, 1) -- Gris
                love.graphics.printf(opc, 0, 52 + (i * 16), ventana.ancho, "center")
            end
        end

        -- Instrucciones al pie
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
        love.graphics.printf("W/S: Navegar | ENTER: Ok", 0, 122, ventana.ancho, "center")

    elseif self.pantalla == "objetivo" then
        love.graphics.setColor(1, 0.8, 0.2, 1)
        love.graphics.printf("OBJETIVO", 0, 12, ventana.ancho, "center")
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Sobrevivir a las\noleadas evitando\nlos proyectiles.", 0, 38, ventana.ancho, "center")
        
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
        love.graphics.printf("ENTER / ESC: Volver", 0, 118, ventana.ancho, "center")

    elseif self.pantalla == "controles" then
        love.graphics.setColor(1, 0.8, 0.2, 1)
        love.graphics.printf("CONTROLES", 0, 10, ventana.ancho, "center")
        
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf("Mover: Flechas / WASD\nP: Pausa | C: Continuar\nF1: Debug\nF2: Detener | F3: Seguir", 0, 30, ventana.ancho, "center")
        
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
        love.graphics.printf("ENTER / ESC: Volver", 0, 118, ventana.ancho, "center")
    end

    love.graphics.setColor(1, 1, 1, 1) -- Restaura color blanco
end


-- ==========================================
-- ESTADO JUEGO
-- ==========================================
EstadoJuego = Class{}

function EstadoJuego:update(dt)
    Timer.update(dt)

    if #enemigos == 0 and not esperando_oleada then
        esperando_oleada = true

        Timer.after(2, function()
            oleada_actual = oleada_actual + 1
            generarOleada(oleada_actual)
            esperando_oleada = false
        end)
    end

    atrapado = false
    jugador:Actualizar(dt)

    for i = #enemigos, 1, -1 do
        local enemigo = enemigos[i]
        enemigo:Actualizar(jugador.x, jugador.y, jugador.ancho, dt)

        if jugador:Colision(
            enemigo.hitbox_x,
            enemigo.hitbox_y,
            enemigo.ancho,
            enemigo.alto
        ) then
            atrapado = true
            enemigo:Eliminar()
            table.remove(enemigos, i)
        end
    end

    for i = #proyectiles, 1, -1 do
        local p = proyectiles[i]
        p:Actualizar(dt)
        if p.x < 0 or p.x > ventana.ancho or p.y < 0 or p.y > ventana.alto then
            table.remove(proyectiles, i)
        end
    end
end

function EstadoJuego:keypressed(key)
    if key == "p" then
        gMaquinaEstados:cambiar("pausa")
    elseif key == "f1" then
        love.event.push('modoDebug')
    elseif key == "f2" then
        Signal.emit("detenerEnemigos")
    elseif key == "f3" then
        Signal.emit("restaurarEnemigos")
    end
end

function EstadoJuego:draw()
    -- Dibujar entidades
    jugador:Dibujar()
    for _, enemigo in ipairs(enemigos) do
        enemigo:Dibujar()
    end

    for _, p in ipairs(proyectiles) do
        p:Dibujar()
    end

    hud:DrawHitboxes()

    -- --- INDICADORES CON COLORES ---
    -- F1: Debug (Verde)
    love.graphics.setColor(0.2, 1, 0.3, 1)
    love.graphics.print("F1: Debug", 5, 26)

    -- F2: Stop (Azul / Cyan)
    love.graphics.setColor(0.2, 0.7, 1, 1)
    love.graphics.print("F2: Stop", 5, 38)

    -- F3: Go (Amarillo)
    love.graphics.setColor(1, 0.9, 0.2, 1)
    love.graphics.print("F3: Go", 5, 50)

    -- P: Pausa (Blanco/Gris suave)
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.print("P: Pausa", 5, 62)

    -- Restaurar color blanco por defecto
    love.graphics.setColor(1, 1, 1, 1)
end


-- ==========================================
-- ESTADO PAUSA
-- ==========================================
EstadoPausa = Class{}

function EstadoPausa:keypressed(key)
    if key == "c" or key == "p" or key == "escape" then
        gMaquinaEstados:cambiar("jugando")
    end
end

function EstadoPausa:draw()
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, ventana.ancho, ventana.alto)

    love.graphics.setColor(1, 0.8, 0.2, 1)
    love.graphics.printf("PAUSA", 0, 50, ventana.ancho, "center")

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Presiona 'C' para continuar", 0, 75, ventana.ancho, "center")
end