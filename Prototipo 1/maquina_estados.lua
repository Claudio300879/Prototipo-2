local Class = require("lib.class")

local MaquinaEstados = Class:extend()

function MaquinaEstados:new()
    self.estados = {}
    self.actual = nil
end

function MaquinaEstados:agregar(nombre, estado)
    self.estados[nombre] = estado
end

function MaquinaEstados:cambiar(nombre, ...)
    if self.estados[nombre] then
        if self.actual and self.actual.exit then
            self.actual:exit()
        end
        self.actual = self.estados[nombre]
        if self.actual and self.actual.enter then
            self.actual:enter(...)
        end
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

-- Devolvemos una instancia global única
return MaquinaEstados()