Fundamentos y Estructura Básica

Máquina de Estados: "MENU", "REGLAS", "JUGANDO", "PAUSA", "GAME_OVER" y "VICTORIA".

Estructuras de Datos y Tablas: mosca, comida, ventanas, pantalla, sonidos.

Ciclo de Vida de LÖVE2D y gestión de entradas: love.load(), love.update(dt), love.draw() , love.keypressed(key).

Sprites, Animaciones y Canvas Pixel-Art

Spritesheets y Quads: love.graphics.newQuad().

Procesamiento con ImageData:Funciones LimpiarFondoMosca y HacerTransparente hacen uso de imageData:mapPixel() en tiempo de ejecución para eliminar el fondo.

Escalado Pixel-Art: Configurado con love.graphics.setDefaultFilter("nearest", "nearest") y renderizado sobre un love.graphics.newCanvas(160, 240) escalado por 3.

Audio, Colisiones y Físicas Propias

Colisiones AABB: Comprueba la superposición de cajas delimitadoras.

Hitbox Ajustado y Física de Empuje: Aplica un margen (hitboxX, hitboxY, hitboxAlto) para detectar cuando la ventana empuja la mosca hacia abajo (mosca.y = posicionTopeY).

Sistema de Audio: Carga correcta de efectos en modo "static" (comiendo, derrota, victoria) y música de fondo continua en modo "stream" (fondo:setLooping(true)).