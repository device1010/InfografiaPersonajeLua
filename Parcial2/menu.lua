local composer = require("composer")
local scene = composer.newScene()

local params = {
    nombre = "a"
}
function scene:create( event )
    local sceneGroup = self.view
    local background = display.newImageRect(sceneGroup,"fondo2.jpg", display.contentWidth, display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local options = {
        width = 300,
        height = 300,
        numFrames = 8
    }
    local options_special = {
        width = 512/4,  -- 533
        height = 192/2,  -- 300
        numFrames = 8
    }
    local personaje_sprite = graphics.newImageSheet("img/Enemy1/attack-A.png", options_special )
    
    local sequence = {
        {
          name = "animacion",
          frames = {1, 2, 3,4,5,6,7,8}, -- Índices de las imágenes en la hoja de sprites
          time = 900, -- Duración en milisegundos de cada frame
          loopCount = 0, -- 0 para bucle infinito, o un número para un número específico de repeticiones
          sheet = personaje_sprite
        }
    }
    
    local personaje = display.newSprite(sceneGroup,personaje_sprite, sequence)
    personaje.x = CW/2; personaje.y = CH/2
    personaje:scale(0.7, 0.7)
    personaje:setSequence("animacion")
    personaje:play()


    -- Crear el botón Fácil
    local btnFacil = display.newRoundedRect(sceneGroup, display.contentCenterX, 150, 200, 50,10)
    btnFacil:setFillColor(0, 1, 0) -- Verde
    btnFacil.strokeWidth = 2
    btnFacil:setStrokeColor(0, 0, 0)
    local txtFacil = display.newText(sceneGroup, "Facil", display.contentCenterX, btnFacil.y , "Consolas", 24)
    txtFacil:setFillColor(1, 1, 1) -- Blanco
    --btnFacil:addEventListener("touch", onFacilPressed)

    -- Crear el botón Medio
    local btnMedio = display.newRoundedRect(sceneGroup, display.contentCenterX, 250, 200, 50,10)
    btnMedio:setFillColor(1, 1, 0) -- Amarillo
    btnMedio.strokeWidth = 2
    btnMedio:setStrokeColor(0, 0, 0)
    local txtMedio = display.newText(sceneGroup, "Medio", display.contentCenterX, btnMedio.y,"Consolas", 24)
    txtMedio:setFillColor(0, 0, 0) -- Negro
    --btnMedio:addEventListener("touch", onMedioPressed)

    -- Crear el botón Dificil
    local btnDificil = display.newRoundedRect(sceneGroup, display.contentCenterX, 350, 200, 50,10)
    btnDificil:setFillColor(1, 0, 0) -- Rojo
    btnDificil.strokeWidth = 2
    btnDificil:setStrokeColor(0, 0, 0)
    local txtDificil = display.newText(sceneGroup, "Dificil", display.contentCenterX, btnDificil.y , "Consolas", 24)
    txtDificil:setFillColor(1, 1, 1) -- Blanco
   -- btnDificil:addEventListener("touch", onDificilPressed)

end


--composer.gotoScene("juego", "fade", {params = params})

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )

-- -----------------------------------------------------------------------------------
 
return scene