BaseEstado = Class{}
function BaseEstado:init() end
function BaseEstado:enter() end
function BaseEstado:exit() end
function BaseEstado:update(dt) end
function BaseEstado:draw() end
function BaseEstado:keypressed(key) end

EstadoInicio = Class{__includes = BaseEstado}

function EstadoInicio:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("PROTOTIPO MOSCA Y VENTANAS", 0, 220, love.graphics.getWidth(), 'center')
    love.graphics.printf("Presiona ENTER para Jugar", 0, 270, love.graphics.getWidth(), 'center')
end

function EstadoInicio:keypressed(key)
    if key == 'return' then
        gMaquinaEstados:cambiar('jugando')
    end
end

EstadoJugando = Class{__includes = BaseEstado}

function EstadoJugando:enter()
    self.nivel = 1
    self.recolectados = 0
    self.meta = 3
    self.enPausa = false
    self.jugador = Jugador(love.graphics.getWidth() / 2 - 14, love.graphics.getHeight() - 80)
    self.popo = Popo()
    self.hud = HUD()
    self:cargarNivel()
end

function EstadoJugando:cargarNivel()
    self.ventanas = {}
    self.recolectados = 0
    local sw = love.graphics.getWidth()
    
    if self.nivel == 1 then
        self.meta = 3
        table.insert(self.ventanas, Caballero(sw / 2 - 35, 220))
    elseif self.nivel == 2 then
        self.meta = 4
        table.insert(self.ventanas, Caballero(50, 160))
        table.insert(self.ventanas, Caballero(sw - 120, 280))
    elseif self.nivel == 3 then
        self.meta = 5
        table.insert(self.ventanas, Samurai(30, 140))
        table.insert(self.ventanas, Caballero(sw / 2 - 35, 260))
    end
end

function EstadoJugando:keypressed(key)
    if key == 'p' then
        self.enPausa = not self.enPausa
    elseif key == 'r' then
        self.jugador = Jugador(love.graphics.getWidth() / 2 - 14, love.graphics.getHeight() - 80)
        self:cargarNivel()
    end
end

function EstadoJugando:update(dt)
    if self.enPausa then return end

    self.jugador.fuerzaArrastre = 15

    for _, v in ipairs(self.ventanas) do
        v:update(dt)
        if v:colisiona(self.jugador) then
            self.jugador.fuerzaArrastre = self.jugador.fuerzaArrastre + v.fuerza
        end
    end

    self.jugador:update(dt)

    if self.popo:colisiona(self.jugador) then
        self.recolectados = self.recolectados + 1
        self.popo:reubicar()

        if self.recolectados >= self.meta then
            if self.nivel < 3 then
                self.nivel = self.nivel + 1
                self.jugador.x = love.graphics.getWidth() / 2 - 14
                self.jugador.y = love.graphics.getHeight() - 80
                self:cargarNivel()
            else
                gMaquinaEstados:cambiar('victoria')
            end
        end
    end

    if self.jugador.y + self.jugador.alto >= love.graphics.getHeight() - 30 then
        gMaquinaEstados:cambiar('gameover')
    end
end

function EstadoJugando:draw()
    for _, v in ipairs(self.ventanas) do
        v:draw()
    end
    self.popo:draw()
    self.jugador:draw()
    self.hud:draw(self.recolectados, self.meta)

    if self.enPausa then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("PAUSA", 0, love.graphics.getHeight() / 2 - 10, love.graphics.getWidth(), 'center')
    end
end

EstadoGameOver = Class{__includes = BaseEstado}

function EstadoGameOver:draw()
    love.graphics.setColor(1, 0.3, 0.3)
    love.graphics.printf("GAME OVER", 0, 220, love.graphics.getWidth(), 'center')
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Caiste al limite inferior", 0, 260, love.graphics.getWidth(), 'center')
    love.graphics.printf("Presiona ENTER para reintentar", 0, 300, love.graphics.getWidth(), 'center')
end

function EstadoGameOver:keypressed(key)
    if key == 'return' then
        gMaquinaEstados:cambiar('jugando')
    end
end

EstadoVictoria = Class{__includes = BaseEstado}

function EstadoVictoria:draw()
    love.graphics.setColor(0.3, 1, 0.3)
    love.graphics.printf("¡VICTORIA!", 0, 220, love.graphics.getWidth(), 'center')
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Completaste las 3 oleadas", 0, 260, love.graphics.getWidth(), 'center')
    love.graphics.printf("Presiona ENTER para volver al inicio", 0, 300, love.graphics.getWidth(), 'center')
end

function EstadoVictoria:keypressed(key)
    if key == 'return' then
        gMaquinaEstados:cambiar('inicio')
    end
end