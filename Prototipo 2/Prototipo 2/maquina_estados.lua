MaquinaEstados = Class{}

function MaquinaEstados:init(estados)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end,
        keypressed = function() end
    }
    self.estados = estados or {}
    self.actual = self.empty
end

function MaquinaEstados:cambiar(nombreEstado, parametros)
    assert(self.estados[nombreEstado], "El estado no existe: " .. tostring(nombreEstado))
    self.actual:exit()
    self.actual = self.estados[nombreEstado]()
    self.actual:enter(parametros)
end

function MaquinaEstados:update(dt)
    self.actual:update(dt)
end

function MaquinaEstados:draw()
    self.actual:draw()
end

function MaquinaEstados:keypressed(key)
    self.actual:keypressed(key)
end