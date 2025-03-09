--[[
    Глобальные переменные
]]--
isMouthShouldChange = true



--[[
    Инициализация
]]--
-- Убираем ванильную модель
vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

-- Горячая клавиша для действия "Приветствие"
keybinds:newKeybind("Wave", "key.keyboard.y", false):onPress(function ()
    pings.wave()
end)

pings.changeMouth("0") -- Устанавливаем текстуру рта

-- Создание страниц колеса действий
mainPage = action_wheel:newPage()
settingsPage = action_wheel:newPage()
actionsPage = action_wheel:newPage()
action_wheel:setPage(actionsPage) -- Задание активной страницы



--[[
    Анимации
]]--
-- SquAPI
local squapi = require("libraries.SquAPI") -- Подключение SquAPI
squapi.smoothHead:new({models.model.root.Body.Head, models.model.root.Body}, {0.9, 0.1}, nil, 3, false) -- Гладкий поворот головы

-- Нанесение текстуры игрока на модель
models.model.root.Body.Body:setPrimaryTexture("SKIN")
models.model.root.Body.BodySecond:setPrimaryTexture("SKIN")
models.model.root.Body.Head.Head:setPrimaryTexture("SKIN")
models.model.root.Body.Head.HeadSecond:setPrimaryTexture("SKIN")
models.model.root.Body.LeftArm.LeftArmTop:setPrimaryTexture("SKIN")
models.model.root.Body.LeftArm.LeftArmTopSecond:setPrimaryTexture("SKIN")
models.model.root.Body.LeftArm.LeftABottom.LeftArmBottom:setPrimaryTexture("SKIN")
models.model.root.Body.LeftArm.LeftABottom.LeftArmBottomSecond:setPrimaryTexture("SKIN")
models.model.root.Body.RightArm.RightArmTop:setPrimaryTexture("SKIN")
models.model.root.Body.RightArm.RightArmTopSecond:setPrimaryTexture("SKIN")
models.model.root.Body.RightArm.RightABottom.RightArmBottom:setPrimaryTexture("SKIN")
models.model.root.Body.RightArm.RightABottom.RightArmBottomSecond:setPrimaryTexture("SKIN")
models.model.root.LeftLeg.LeftLegTop:setPrimaryTexture("SKIN")
models.model.root.LeftLeg.LeftLegTopSecond:setPrimaryTexture("SKIN")
models.model.root.LeftLeg.LeftLBottom.LeftLegBottom:setPrimaryTexture("SKIN")
models.model.root.LeftLeg.LeftLBottom.LeftLegBottomSecond:setPrimaryTexture("SKIN")
models.model.root.RightLeg.RightLegTop:setPrimaryTexture("SKIN")
models.model.root.RightLeg.RightLegTopSecond:setPrimaryTexture("SKIN")
models.model.root.RightLeg.RightLBottom.RightLegBottom:setPrimaryTexture("SKIN")
models.model.root.RightLeg.RightLBottom.RightLegBottomSecond:setPrimaryTexture("SKIN")

-- Приоритеты
animations.model.spearR:setPriority(2)
animations.model.spearL:setPriority(2)
animations.model.spyglassR:setPriority(2)
animations.model.spyglassL:setPriority(2)
animations.model.bowR:setPriority(2)
animations.model.bowL:setPriority(2)
animations.model.crossR:setPriority(2)
animations.model.crossL:setPriority(2)
animations.model.mineR:setPriority(2)
animations.model.mineL:setPriority(2)
animations.model.wave:setPriority(3)
animations.model.glider:setPriority(4)

-- Скорости
function events.render()
    local speedXZ = math.sqrt(player:getVelocity().x ^ 2 + player:getVelocity().z ^ 2) -- Скорость игрока в координатах X и Z
    local speedY = math.abs(player:getVelocity().y) -- Скорость игрока по координате Y

    local walkingSpeed = speedXZ * 4.540071 * 4.25 -- Скорость анимации хотьбы
    local sprintingSpeed = speedXZ * 3.5637 * 3.75 -- Скорость анимации бега
    local crouchingSpeed = speedXZ * 15.442 * 1.35 -- Скорость анимации хотьбы в приседе
    local crawlingSpeed = speedXZ * 15.4465 * 2.85 -- Скорость анимации ползания

    -- Поправка скорости для бега в припрыжку
    if (host:isHost() == true) and (speedY > 0) then -- Скорсть бега у игрока установившего аватар
        sprintingSpeed = sprintingSpeed * speedY * 1.56
    elseif (host:isHost() == false) and (speedY > 0.01) then -- Скорость бега у наблюдающих игроков
        sprintingSpeed = sprintingSpeed * speedY * 3.1
    end

    -- Выставление скорстей анимаций
    animations.model.walking:setSpeed(walkingSpeed)
    animations.model.walkingback:setSpeed(walkingSpeed)
    animations.model.sprinting:setSpeed(sprintingSpeed)
    animations.model.crouchwalk:setSpeed(crouchingSpeed)
    animations.model.crouchwalkback:setSpeed(crouchingSpeed)
    animations.model.crawling:setSpeed(crawlingSpeed)
    animations.model.falling:setSpeed(player:getVelocity().y / -3.92)
end

-- Интеграция анимаций с модом Gliders
if client:isModLoaded("vc_gliders") then
    isGlidingInPreviousTick = false
    isGlidintInPrePreviousTick = false
    function events.tick()
        isGlidingInPresentTick = ((math.round(player:getVelocity().y * 100)) / 100 == -0.05)
        if isGlidingInPresentTick then
            if isGlidingInPresentTick and isGlidingInPreviousTick then
                if isGlidingInPresentTick and isGlidingInPreviousTick and isGlidintInPrePreviousTick then
                    animations.model.glider:setPlaying(true)
                else
                    isGlidintInPrePreviousTick = true
                end
            else
                isGlidingInPreviousTick = true
            end
        else
            isGlidingInPreviousTick = false
            isGlidintInPrePreviousTick = false
            animations.model.glider:setPlaying(false)
        end
    end
end



--[[
    Остальное
]]--
function events.tick() -- Постановка камеры на плечо
  if settingCameraShouldBeOnShoulder:getTitle() == "Снять камеру с плеча" and not renderer:isFirstPerson() then -- Постановка камеры на плечо игрока
      if renderer:isCameraBackwards() then
          renderer:setCameraPos(-1, 0, 0)
      else
          renderer:setCameraPos(-1, 0, -2.5)
      end
  else
      renderer:setCameraPos(0, 0, 0)
  end
end
