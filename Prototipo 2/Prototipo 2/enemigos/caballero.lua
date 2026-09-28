Caballero = Class{__includes = Enemigo}

function Caballero:init(x, y, ancho, alto)
    Enemigo.init(self, x, y, ancho or 70, alto or 60, 140)
end