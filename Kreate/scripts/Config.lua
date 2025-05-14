squapi = require("scripts.libraries.SquAPI") -- Подключение SquAPI
squapi.smoothHead:new({models.model.root.Body, models.model.root.Body.Head}, {0, 0.75}, nil, 1, false) -- Гладкий поворот головы



-- Настройка анимаций
animations.model.crouching:setPriority(1)
animations.model.spearR:setPriority(2)
animations.model.spearL:setPriority(2)
animations.model.bowR:setPriority(2)
animations.model.bowL:setPriority(2)
animations.model.crossR:setPriority(2)
animations.model.crossL:setPriority(2)
animations.model.mineR:setPriority(2)
animations.model.mineL:setPriority(2)
animations.model.spyglassR:setPriority(4)
animations.model.spyglassL:setPriority(4)
animations.model.actionHighFiveCheck:setPriority(4)



require("scripts.libraries.SAM")
stopingAnimsList = {
    ["walking"] = {
        animations.model.walking,
        animations.model.walkingback,
        animations.model.swimming,
        animations.model.waterup
    },
    ["sprinting"] = {
        animations.model.sprinting,
        animations.model.falling,
        animations.model.sleeping,
        animations.model.elytra
    },
    ["crouching"] = {
        animations.model.crouching,
        animations.model.crouchwalk,
        animations.model.crouchwalkback,
        animations.model.sitting
    },
    ["arms"] = {
        animations.model.attackR,
        animations.model.attackL,
        animations.model.spearL,
        animations.model.spearR,
        animations.model.crossL,
        animations.model.crossR,
        animations.model.bowL,
        animations.model.bowR,
        animations.model.spyglassR,
        animations.model.spyglassL,
        animations.model.mineR,
        animations.model.mineL
    },
    ["flying"] = {
        animations.model.flying,
        animations.model.flywalk,
        animations.model.flywalkback,
        animations.model.flyup,
        animations.model.flydown
    }
}
actionsList = {
    {"Приветствие", animations.model.actionWave, 3, {"arms"}},
    {"Указать на место", animations.model.actionPointUp, 3, {"arms"}},
    {"Хлопки", animations.model.actionClaps, 3, {"sprinting", "arms", "flying"}},
    {'Танец "Удар казачка"', animations.model.actionKazotskyKick, 3, {"crouching", "sprinting", "flying"}},
    {"Пятюня", animations.model.actionHighFive, 3, {"sprinting", "crouching", "arms", "flying"}}
}
blendActionAnimations(7.5)



--[[
    Специальные действия, переменные
]]--
local highFiveCheck = false
local clapSoundCooldown = 7


--[[
    Специальные действия
]]--
function events.render()
    if activeAction[1] == "Указать на место" then
        models.model.root.Body.LeftArm:setRot((vanilla_model.HEAD:getOriginRot() + 180) % 360 - 1800)
        models.model.root.Body.LeftArm:setRot(models.model.root.Body.LeftArm:getRot().x, -1 * models.model.root.Body.LeftArm:getRot().y, models.model.root.Body.LeftArm:getRot().z)
    else
        models.model.root.Body.LeftArm:setRot(0, 0, 0)
    end
end

function events.tick(delta)
    if activeAction[1] == "Пятюня" then
        local hand_pos = models.model.root.Body.RightArm.RABottom.RightItemPivot:partToWorldMatrix():apply()
        for _, player in pairs(world:getPlayers()) do
            local pos = player:getPos(delta) + vec(0, player:getEyeHeight(delta), 0)
            local dist = (hand_pos - pos):length()
            pos = pos + player:getLookDir(delta)*dist
            if player:isSwingingArm() and (hand_pos - pos):length() <= 0.3 and not animations.model.actionHighFiveCheck:isPlaying() then
                highFiveCheck = true
            end
        end
        if highFiveCheck then
            animations.model.actionHighFiveCheck:play()
            sounds:playSound("block.froglight.step", player:getPos(), 15, 1, false)

            highFiveCheck = false
        end
    end

    if activeAction[1] == "Хлопки" then
        if clapSoundCooldown <= 0 then
            sounds:playSound("block.froglight.step", player:getPos(), 15, 2, false)
            clapSoundCooldown = 7
        else
            clapSoundCooldown = clapSoundCooldown - 1
        end
    end
end

--[[
    Горячие клавиши
]]--
if host:isHost() then
    keybinds:newKeybind("Остановить действие", "key.keyboard.keypad.0"):onPress(function ()
        pings.stopAction()
    end)
    for index in pairs(actionsList) do
        keybinds:newKeybind(actionsList[index][1], "key.keyboard.keypad." .. index):onPress(function ()
            pings.playAction(index)
        end)
    end
end