require("dependencias")
MaquinaEstados = require("maquina_estados")
require("animaciones")
gestorOleadas = require("GestorOleadas")

--  módulos de estados
local EstadoMenu     = require("estados.EstadoMenu")
local EstadoReglas   = require("estados.EstadoReglas")
local EstadoJugando  = require("estados.EstadoJugando")
local EstadoPausa    = require("estados.EstadoPausa")
local EstadoGameOver = require("estados.EstadoGameOver")
local EstadoVictoria = require("estados.EstadoVictoria")

pantalla = {
    ancho  = 160,
    alto   = 240,
    escala = 3
}

COMIDAS_OBJETIVO = 3

world = nil
mosca = nil
comida = nil
ventanaSprite = nil
ventanas = {}

puntos = 0
mostrarBien = false
desdePausa = false
sonidos = {}

function LimpiarFondoMosca(imageData)
    imageData:mapPixel(function(x, y, r, g, b, a)
        if r > 0.92 and g > 0.92 and b > 0.92 then return 0, 0, 0, 0 end
        return r, g, b, a
    end)
    return love.graphics.newImage(imageData)
end

function HacerTransparente(imagenPath)
    local imageData = love.image.newImageData(imagenPath)
    imageData:mapPixel(function(x, y, r, g, b, a)
        if r > 0.95 and g > 0.95 and b > 0.95 then return 0, 0, 0, 0 end
        return r, g, b, a
    end)
    return love.graphics.newImage(imageData)
end

function ReiniciarPosiciones()
    world = Bump.newWorld(16)

    mosca.x = pantalla.ancho / 2
    mosca.y = pantalla.alto - 25
    world:add(mosca, mosca.x - mosca.origen_x, mosca.y - mosca.origen_y, mosca.ancho, mosca.alto)

    comida:reposicionar(pantalla.ancho, world)
    world:add(comida, comida.x - comida.origen_x, comida.y - comida.origen_y, comida.ancho, comida.alto)

    ventanas = {}
end

function ReiniciarJuego()
    puntos = 0
    mostrarBien = false
    ReiniciarPosiciones()
    gestorOleadas:iniciar(1)
    
    if sonidos.fondo then
        love.audio.stop(sonidos.fondo)
        sonidos.fondo:play()
    end
end

function love.load()
    love.window.setTitle("Prototipo 1")
    love.window.setMode(pantalla.ancho * pantalla.escala, pantalla.alto * pantalla.escala)
    love.graphics.setDefaultFilter("nearest", "nearest")
    lienzo = love.graphics.newCanvas(pantalla.ancho, pantalla.alto)
    
    math.randomseed(os.time())

    local comidaSprite = HacerTransparente("img/comida.png")
    ventanaSprite = HacerTransparente("img/ventana.png")

    local moscaImageData = love.image.newImageData("img/mosca.png")
    local imgMosca = LimpiarFondoMosca(moscaImageData)
    
    local anchoFrame = imgMosca:getWidth() / 2
    local altoFrame = imgMosca:getHeight()

    mosca = Mosca(80, 215, 85)
    local animMosca = CrearAnimacionConImage(imgMosca, 2, anchoFrame, altoFrame, 10, false)
    mosca:setAnimacion(animMosca)

    comida = Comida(80, 25, comidaSprite)

    sonidos.comiendo = love.audio.newSource("sounds/Comiendo.mp3", "static")
    sonidos.derrota  = love.audio.newSource("sounds/Derrota.mp3", "static")
    sonidos.victoria = love.audio.newSource("sounds/Victoria.mp3", "static")
    sonidos.fondo    = love.audio.newSource("sounds/Fondo.mp3", "stream")
    
    sonidos.fondo:setLooping(true)
    sonidos.fondo:setVolume(0.5)

    -- Carga de eventos
    require("eventos")

    -- Registro de estados
    MaquinaEstados:agregar("menu", EstadoMenu())
    MaquinaEstados:agregar("reglas", EstadoReglas())
    MaquinaEstados:agregar("jugando", EstadoJugando())
    MaquinaEstados:agregar("pausa", EstadoPausa())
    MaquinaEstados:agregar("game_over", EstadoGameOver())
    MaquinaEstados:agregar("victoria", EstadoVictoria())

    MaquinaEstados:cambiar("menu")
end

function love.keypressed(key)
    MaquinaEstados:keypressed(key)
end

function love.update(dt)
    Timer.update(dt)
    MaquinaEstados:update(dt)
end

function love.draw()
    MaquinaEstados:draw()
    love.graphics.setColor(1, 1, 1)
end