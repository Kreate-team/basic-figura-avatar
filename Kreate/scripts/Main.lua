-- Нанесение текстуры игрока на модель
models.model.root.Body.Body:setPrimaryTexture("SKIN")
models.model.root.Body.Jacket:setPrimaryTexture("SKIN")
models.model.root.Body.Head.Head:setPrimaryTexture("SKIN")
models.model.root.Body.Head.Hairs:setPrimaryTexture("SKIN")
models.model.root.Body.LeftArm:setPrimaryTexture("SKIN")
models.model.root.Body.RightArm:setPrimaryTexture("SKIN")
models.model.root.LeftLeg:setPrimaryTexture("SKIN")
models.model.root.RightLeg:setPrimaryTexture("SKIN")

function pings.mouthHeight(Y) -- Устанавливает высоту рта
    models.model.root.Body.Head.Face.Mouth:setPos(0, Y, 0)
end

function pings.setArms(isArmsSlim)
    models.model.root.Body.RightArm.RTopS:setVisible(not isArmsSlim)
    models.model.root.Body.RightArm.RABottom.RBottomS:setVisible(not isArmsSlim)
    models.model.root.Body.LeftArm.LTopS:setVisible(not isArmsSlim)
    models.model.root.Body.LeftArm.LABottom.LBottomS:setVisible(not isArmsSlim)

    models.model.root.Body.RightArm.RTopA:setVisible(isArmsSlim)
    models.model.root.Body.RightArm.RABottom.RBottomA:setVisible(isArmsSlim)
    models.model.root.Body.LeftArm.LTopA:setVisible(isArmsSlim)
    models.model.root.Body.LeftArm.LABottom.LBottomA:setVisible(isArmsSlim)
end

if host:isHost() then
    local ticksBeforeSync = 200 -- Отсчёт до синхронизации

    -- Отсчёт до синхронизации
    function events.tick()
        ticksBeforeSync = ticksBeforeSync - 1
        if ticksBeforeSync <= 0 then
            ticksBeforeSync = 200

            pings.setArms(config:load("isArmsSlim"))
            pings.mouthHeight(config:load("mouthHeight"))
        end
    end
end

--[[
    Кастомная именная табличка
]]--
function pings.setNameplate(value)
    nameplate.ALL:setText(
        toJson({
            text = value .. player:getName(),
            ["hoverEvent"] = {
                ["action"] = "show_text",
                ["contents"] = {
                    {text = " §l5|-|1z0|< \\/\\/45 |-|323", color = "#00FFFF"},
                    {text = "\n"},
                    {text = "§lDiscord:§f ", color = "#5662F6"}, {text = "@sh1zok_was_here\n"},
                    {text = "§lGit", color = "#F0F6FC"}, {text = "§lHub: ", color = "#394963"}, {text = "Sh1zok"}
                },
            },
        })
    )
end

if host:isHost() then
    local oldHostState = ""

    function events.tick()
        hostState = ""

        if host:isChatOpen() then hostState = hostState .. ":typing: " end
        if not client:isWindowFocused() then hostState = hostState .. ":zzz: " end
        if host:isContainerOpen() then hostState = hostState .. ":open_folder_paper: " end
        if isMicWorking then hostState = hostState .. ":speak: " end

        if hostState ~= oldHostState then
            pings.setNameplate(hostState)
            oldHostState = hostState
        end
    end
end



--[[
    Остальное
]]--
-- Убираем ванильную модель
vanilla_model.PLAYER:setVisible(false)
vanilla_model.CAPE:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

-- Скорости анимаций
function events.render()
    local speedXZ = math.sqrt(player:getVelocity().x ^ 2 + player:getVelocity().z ^ 2) * 4.63266 -- Скорость игрока в координатах X и Z
    local speedY = math.abs(player:getVelocity().y) -- Скорость игрока по координате Y
    local sprintingSpeed = speedXZ * 2.75 -- Скорость анимации бега

    -- Поправка скорости для бега в припрыжку
    if (host:isHost() == true) and (speedY > 0) then sprintingSpeed = sprintingSpeed * speedY * 1.8
    elseif (host:isHost() == false) and (speedY > 0.01) then sprintingSpeed = sprintingSpeed * speedY * 3.1 end

    -- Выставление скорстей анимаций
    animations.model.walking:setSpeed(speedXZ * 4.13)
    animations.model.walkingback:setSpeed(speedXZ * 4.13)
    animations.model.sprinting:setSpeed(sprintingSpeed)
    animations.model.crouchwalk:setSpeed(speedXZ * 5)
    animations.model.crouchwalkback:setSpeed(speedXZ * 5)
    animations.model.crawling:setSpeed(speedXZ * 5.5)
    animations.model.falling:setSpeed(speedY / -3.92)
end
