require 'dependencias'

-- Carga la librería HUMP Signal
Signal = require 'lib.signal'

ventana = {
    ancho  = 160,
    alto   = 144,
    escala = 4
}

enemigos = {}
atrapado = false
proyectiles = {}

intervalo_spawn = 0.5

oleada_actual = 0
esperando_oleada = false

function generarProyectil()
    local x = math.random(ventana.ancho * 0.25, ventana.ancho * 0.5)
    local y = math.random(ventana.alto  * 0.25, ventana.alto  * 0.5)
    local angulo = math.random() * math.pi * 2
    local velocidad = math.random(30, 70)
    local nuevo_proyectil = Proyectil(x, y, angulo, velocidad)
    table.insert(proyectiles, nuevo_proyectil)
end

function generarOleada(nivel)
    local cantidad = 2 + (nivel * 2)
    local patron = nivel % 3

    local centro_x = ventana.ancho / 2
    local centro_y = ventana.alto / 2

    if patron == 1 then
        local radio = 60
        for i = 1, cantidad do
            local angulo = (i / cantidad) * (math.pi * 2)
            local ex = centro_x + math.cos(angulo) * radio
            local ey = centro_y + math.sin(angulo) * radio
            table.insert(enemigos, Enemigo(ex, ey, "img/Esqueleto.png", 4 + nivel))
        end
    elseif patron == 2 then
        for i = 1, cantidad do
            local fraccion = i / (cantidad + 1)
            local ex = ventana.ancho * fraccion
            local ey = (i % 2 == 0) and 10 or (ventana.alto - 10)
            table.insert(enemigos, Caballero(ex, ey, "img/Caballero.png", 5 + nivel))
        end
    else
        for i = 1, cantidad do
            local progreso = i / cantidad
            local ex = progreso * ventana.ancho
            local ey = (i % 2 == 0) and (progreso * ventana.alto) or (ventana.alto - (progreso * ventana.alto))
            table.insert(enemigos, Samurai(ex, ey, "img/Samurai.png", 6 + nivel))
        end
    end
end

function redondear(n)
  return math.floor(n + 0.5)
end

-- =================== INICIALIZACION ===================
function love.load()
    love.window.setMode(ventana.ancho * ventana.escala, ventana.alto * ventana.escala)
    love.graphics.setDefaultFilter("nearest", "nearest")
    lienzo = love.graphics.newCanvas(ventana.ancho, ventana.alto)
    
    -- Tamaño 12px para que se lea perfecto sobre la ventana escalada
    fuentePequena = love.graphics.newFont(12)
    
    hud = HUD()
    jugador = Jugador(ventana.ancho / 2, ventana.alto / 2, 72)
    
    math.randomseed(os.time())
    Timer.every(intervalo_spawn, generarProyectil)

    gMaquinaEstados = MaquinaEstados({
        ['menu'] = function() return EstadoMenu() end,
        ['jugando'] = function() return EstadoJuego() end,
        ['pausa'] = function() return EstadoPausa() end
    })

    gMaquinaEstados:cambiar('menu')
end

-- =================== ESTADOS ===================
function love.keypressed(key, scancode, isrepeat)
    gMaquinaEstados:keypressed(key)
end

function love.update(dt)
    gMaquinaEstados:update(dt)
end

function love.draw()
    -- DIBUJO DEL MUNDO DE JUEGO (ESCALADO 160x144)
    love.graphics.push()
    love.graphics.scale(ventana.escala)
    
    -- Dibujo del jugador, los enemigo y los proyectiles
    gMaquinaEstados:draw()
    
    love.graphics.pop()

    -- 2. DIBUJO DEL HUD Y MENÚ DE AYUDA 
    if gMaquinaEstados.estado_actual_nombre == 'jugando' or gMaquinaEstados.estado_actual == gMaquinaEstados.estados['jugando'] then
        love.graphics.setColor(1, 1, 1, 1)
        
        -- Contadores principales
        love.graphics.print("Proyectiles activos: " .. #proyectiles, 10, 10)
        love.graphics.print("Oleada: " .. oleada_actual, 10, 25)

        -- Menú de ayuda / Controles (Dibujado en tamaño legible fuera del scale global)
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.print("F1: Debug", 10, 45)
        
        love.graphics.setColor(0, 0.6, 1, 1)
        love.graphics.print("F2: Stop", 10, 60)
        
        love.graphics.setColor(1, 1, 0, 1)
        love.graphics.print("F3: Go", 10, 75)
        
        love.graphics.setColor(1, 1, 1, 0.8)
        love.graphics.print("P: Pause", 10, 90)
    end
end