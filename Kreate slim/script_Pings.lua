--[[
    МЕНЯЮЩИЕ ТЕКСТУРЫ
]]--
function pings.changeMouth(texture) -- Смена текстуры рта на заданную
    if player:isLoaded() and not host:isHost() then
        models.model.root.Body.Head.Mouth:setPrimaryTexture("Custom", textures["assets.mouth." .. texture])
    end

end
function pings.stopActions() -- Останавливает все действия
    pointUpShouldPlay = false

    animations.model.wave:stop()
end



--[[
    ДЕЙСТВИЯ
]]--
function pings.pointUp() -- Направляет руку игрока в сторону его взгляда
    pointUpShouldPlay = true
    function events.render()
        if pointUpShouldPlay and not animations.model.sprinting:isPlaying() and not animations.model.crouching:isPlaying() then
            local headrotation = (vanilla_model.HEAD:getOriginRot() + 180) % 360 - 180
            headrotation[1] = headrotation[1] + 90
            models.model.root.Body.RightArm:setRot(headrotation)
        else 
            models.model.root.Body.RightArm:setRot(0, 0, 0)
            pointUpShouldPlay = false
        end
    end
end
function pings.wave() -- Воспроизводит анимации помахивания рукой
    animations.model.wave:play()
    function events.tick() -- Условие для преждевременной остановки анимации
        if animations.model.sprinting:isPlaying() or
        animations.model.crouchwalk:isPlaying() or
        animations.model.crouchwalkback:isPlaying() then
            animations.model.wave:stop()
        end
    end
end



--[[
    Остальное
]]--
function pings.ArmorVisibility(value) -- Устанавливает видимость брони
    vanilla_model.ARMOR:setVisible(value)
end
function pings.changeMouthHeight(Y) -- Устанавливает высоту рта
    models.model.root.Body.Head.Mouth:setPos(0, Y, 0)
end