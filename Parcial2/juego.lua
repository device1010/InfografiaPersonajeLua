local composer = require( "composer" )
 
local scene = composer.newScene()
local physics = require "physics"

local CW = display.contentWidth
local CH = display.contentHeight

local grupoEscena = display.newGroup()
local grupoFondo = display.newGroup()
local grupoMedio = display.newGroup()
local grupoInterfaz = display.newGroup()

local nombre

physics.start()
physics.setDrawMode("hybrid")

grupoEscena:insert(grupoFondo)
grupoEscena:insert(grupoInterfaz)

local fondo = display.newImageRect(grupoFondo, "1.jpg", CW, CH) -- mover con el personaje
fondo.x = CW/2; fondo.y = CH/2

local fondo2 = display.newImageRect(grupoFondo, "1.jpg", CW, CH) -- mover con el personaje
fondo2.x = CW/2 + CW; fondo2.y = CH/2

local velocidad = 100
local escenario = 1

local options = {
    width = 300,
    height = 300,
    numFrames = 8
}
local options_special = {
    width = 1599/3,  -- 533
    height = 600/2,  -- 300
    numFrames = 6
}

local personaje_sprite = graphics.newImageSheet("avanzaD.png", options )
local personaje_special_sprite = graphics.newImageSheet("special.png", options_special)
local personaje_caminar_izquierda = graphics.newImageSheet("avanzaL.png", options)
local personaje_special_izquierda = graphics.newImageSheet("especialL.png", options_special)

local sequence = {
    {
        name = "correr",
        start = 1,
        count = 8,
       -- frames = {4,5,6,7,8,1,2,3,3,3,3,4,4,4,5 },
        time = 600,  --  1 segundo cada 12 cuadros   8/12  2/3 
        loopCount = 0,
        sheet = personaje_sprite
    },
    {
        name = "atacar",
        time = 1333,
        frames = {3,2,1,2,3},
        sheet = personaje_special_izquierda,
        loopCount = 1
    },{
        name = "golpe",
        frames = {1,2,3,1},
        loopCount = 1,
        time = 1000,
        sheet = personaje_special_sprite
    },
    {
        name = "left_move",
        frames = {4,3,2,1,8,7,6,5},
        time = 600,
        sheet = personaje_caminar_izquierda
    },
    {
        name = "saltar",
        frames = {6,5},
        time = 1300,
        sheet = personaje_special_sprite
    },
    {
        name = "saltar_left",
        frames = {4,5},
        time = 1300,
        sheet = personaje_special_izquierda
    },
    {
        name = "abajo",
        frames = {5,2,4},
        time = 1300,
        sheet = personaje_special_sprite
    },
    {
        name = "abajoL",
        frames = {5,2,6},
        time = 1300,
        sheet = personaje_special_izquierda
    }
}
local personaje = display.newSprite(grupoEscena,personaje_sprite, sequence)
personaje.x = CW/2; personaje.y = CH/2
personaje:scale(0.7, 0.7)
personaje:setSequence("left_move")
personaje:play()
local personaje_body = {
    halfWidth = 300 *0.3/ 2,
    halfHeight =300 *0.4 / 2,
    x=0,
    y=10,
    angle=00
}

physics.addBody(personaje, "dynami",{box=personaje_body,density = 3,friction=0.5, bounce = 0.1})
physics.setGravity(0,9.8)
--print(personaje.sequence, personaje.frame)


local piso = display.newRect(grupoFondo, CW/2, CH * 0.8, CW*3, 30)
piso:setFillColor(0,1,0,0)
physics.addBody(piso, "static",{ bounce = 0.1})


local boton_atacar = display.newImageRect(grupoInterfaz,"atacar.png", 100,100) --Izquierda
boton_atacar.x = CW/4; boton_atacar.y = 200
boton_atacar.animacion = "atacar"

local boton_golpe = display.newImageRect(grupoInterfaz,"atacar.png", 100,100) --Derecha
boton_golpe.x = CW*3/4; boton_golpe.y = boton_atacar.y
boton_golpe.animacion = "golpe"

local estaAtacando = false
local estaSaltando = false
local salto=0

function caminar(e)
    if (e.phase == "moved") then
        personaje:translate(1, 0 )
    end
    return true
end


function volverACmaniar()
    personaje:setSequence("correr")
    personaje:play()
    estaAtacando = false
end
function volverACmaniarleft()
    personaje:setSequence("left_move")
    personaje:play()
    estaAtacando = false
end

function animar(e)
    if e.phase == "ended" then
        if estaAtacando == false then
            estaAtacando = true
            local target = e.target
            print("Propiedad de animacion",  e.target.animacion)
            print(personaje.sequence)
            personaje:setSequence(e.target.animacion )
            personaje:play()
            timer.performWithDelay(2000, volverACmaniar)
        else
            print("ya esta atacando y debo esperar a que termine para ejectura de nuevo")
        end  
    end
    return true
end

local function onCollision(event)
    if event.phase == "began" and event.object1 == personaje and event.object2 == piso then
        estaSaltando=false 
    else
        estaSaltando=true
    end
end

function onKeyEvent(event)
    print(personaje.x)
    --print(event.phase, event.keyName)
    if event.keyName == "right" then
        if personaje.isPlaying == false then 
            personaje:setSequence("correr")
            personaje:play()
        end
        if personaje.sequence ~= "correr" then
            personaje:setSequence("correr")
        end
        if event.phase == "down" then
            personaje:setLinearVelocity(velocidad, 0)
          --personaje:translate(velocidad, 0 )
          --transition.to(personaje, {time = 0, x = personaje.x + velocidad})
        elseif event.phase =="up" then
            personaje:setLinearVelocity(0, 0)
            --transition.cancel(personaje)
            --personaje:translate(velocidad, 0 )
        
        end
        
    elseif event.keyName == "left" then
        
        if personaje.isPlaying == false then 
            personaje:setSequence("left_move")
            personaje:play()
        end
        if personaje.sequence ~= "left_move" then
            personaje:setSequence("left_move")
        end
        if event.phase == "down" then
            personaje:setLinearVelocity(-1*velocidad, 0)
            --personaje:translate(-1*velocidad, 0 )
            --grupoFondo:translate(velocidad,0)
        elseif event.phase =="up" then
            personaje:setLinearVelocity(0, 0)
            --transition.cancel(personaje)
            --personaje:translate(velocidad, 0 )
        
        end
    elseif event.keyName == "up" then
        
        if personaje.isPlaying == false then 
            if personaje.sequence == "correr" then
                personaje:setSequence("saltar")
            end
            if personaje.sequence == "left_move" then
                personaje:setSequence("saltar_left")
            end
            personaje:play()    
        end
        if personaje.sequence == "saltar"  and personaje.y == 700 then
            personaje:setSequence("correr")
        end
        if personaje.sequence == "saltar_left"  and personaje.y == 700 then
            personaje:setSequence("left_move")
        end
        if event.phase == "down" then
            salto=salto+1
            if salto<=2 then
                transition.to(personaje, {time = 650, y = personaje.y - 150})
                
                --personaje:translate(0, -150)  -- Mover hacia arriba
                --transition.to(personaje, {time = 650, y = personaje.y + 150})
                if personaje.sequence == "left_move"  then
                    personaje:setSequence("left_move")
                    timer.performWithDelay(1300, volverACmaniarleft)
                end
                if personaje.sequence == "correr"  then
                    personaje:setSequence("correr")
                    timer.performWithDelay(1300, volverACmaniar)
                end
            elseif salto>=3 and not estaSaltando then
                salto=0
            end
        end
    elseif event.keyName == "down" then
        if personaje.isPlaying == false then 
            if personaje.sequence == "correr" then
                personaje:setSequence("abajo")
            end
            if personaje.sequence == "left_move" then
                personaje:setSequence("abajoL")
            end
            personaje:play()    
        end
        if personaje.sequence == "abajo"  and personaje.y == 700 then
            personaje:setSequence("correr")
        end
        if personaje.sequence == "abajoL"  and personaje.y == 700 then
            personaje:setSequence("left_move")
        end
        if event.phase == "down" then
            transition.to(personaje, {time = 650, y = personaje.y + 150})
            --personaje:translate(0, -150)  -- Mover hacia arriba
            --transition.to(personaje, {time = 650, y = personaje.y + 150})
            if personaje.sequence == "left_move"  then
                personaje:setSequence("left_move")
                timer.performWithDelay(1300, volverACmaniarleft)
            end
            if personaje.sequence == "correr"  then
                personaje:setSequence("correr")
                timer.performWithDelay(1300, volverACmaniar)
            end
        end
    end
    
end

function nuevaPantalla()
    personaje.x = 20
    transition.to(grupoEscena,{alpha = 1, time =1000, delay=500})
    local paint = {
        type = "image",
        filename = "5.jpg"
    }
    fondo.fill = paint
end

function cambiarPantalla()
    if escenario == 1 then
        transition.to(grupoEscena, {alpha = 0.1, time = 1500, delay = 500, onComplete=nuevaPantalla})
        escenario = 2
    end
end

function camara(e)
    -- if personaje.x > CW then -- verificacion si nos salimos de pantalla
    --     print("Nos salimos de pantalla")
    --     cambiarPantalla() -- mover la pantalla cuando el personaje excede el limite y desplegar un escenario nuevo con un efecto.
    -- end
    if personaje.x>=CW/2 and personaje.x<=CW/2+CW then
        grupoEscena.x = -personaje.x  + CW/2 --defase 
        grupoInterfaz.x = -grupoEscena.x
    end
end
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    local icono = display.newImageRect(sceneGroup, "Icon.png",CW/2, CH/2 )
    icono.x = CW/2; icono.y =CH/2

end
 
-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        local params = event.params
        nombre = params.nombre
 
    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen
       
    end
end

Runtime:addEventListener("enterFrame", camara)

Runtime:addEventListener("collision", onCollision)
Runtime:addEventListener("key", onKeyEvent)
boton_atacar:addEventListener("touch", animar)
boton_golpe:addEventListener("touch", animar)

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene
