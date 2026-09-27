MaquinaEstados = Class{}

function MaquinaEstados:init(estados)
    self.estados = estados or {}
    self.actual = nil
end

function MaquinaEstados:cambiar(nombreEstado, parametros)
    assert(self.estados[nombreEstado], "El estado " .. tostring(nombreEstado) .. " no existe.")
    if self.actual and self.actual.salir then
        self.actual:salir()
    end
    self.actual = self.estados[nombreEstado]()
    if self.actual.entrar then
        self.actual:entrar(parametros)
    end
end

function MaquinaEstados:update(dt)
    if self.actual and self.actual.update then
        self.actual:update(dt)
    end
end

function MaquinaEstados:draw()
    if self.actual and self.actual.draw then
        self.actual:draw()
    end
end

function MaquinaEstados:keypressed(key)
    if self.actual and self.actual.keypressed then
        self.actual:keypressed(key)
    end
end