-- Carga de librerías externas desde /lib
Class  = require("lib.class")
Bump   = require("lib.bump")
Timer  = require("lib.timer")
Signal = require("lib.signal")
STI    = require("lib.sti")
-- Carga de clases de entidades
Mosca = require("entidades.Mosca")
Comida = require("entidades.Comida")
Ventana = require("entidades.Ventana")

-- Carga del módulo de eventos
require("eventos")