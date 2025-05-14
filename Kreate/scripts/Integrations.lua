function pings.changeMouth(texture) -- Смена текстуры рта на заданную
    models.model.root.Body.Head.Face.Mouth:setPrimaryTexture("Custom", textures["textures.Misc." .. texture])
end

if not (client:isModLoaded("figurasvc") and host:isHost()) then return end -- Дальше скрипт читает только хост если у него установлена figurasvc
previousMouth = "0" -- Текстура рта в предыдущем тике
currentMouth = "0" -- Текстура рта в текущем тике
local oldVoiceLevel = 0
events["svc.microphone"] = function(pcm) -- Ивент исполняющийся во время использования микрофона
    local averageVL = 0 -- Средняя громкость голоса

    for i = 1, #pcm do -- Вычисление суммы
        averageVL = averageVL + math.abs(pcm[i])
    end

    voiceLevel = averageVL / (#pcm * 100) -- Вычисление средней громкости, сумма делённая на их количество

    -- Определение текстуры рта
    if voiceLevel < 2 then currentMouth = "0" end
    if voiceLevel > 2 and voiceLevel < 4 then currentMouth = "1" end
    if voiceLevel > 4 and voiceLevel < 10 then currentMouth = "2" end
    if voiceLevel > 10 and voiceLevel < 100 then currentMouth = "3" end
    if voiceLevel > 100 then currentMouth = "4" end
end

function events.tick()
    -- Оптимизация вызывания пинга, пинг вызывается только тогда когда текстура рта в этом тике не равна текстуре рта из предыдущего тика
    if currentMouth ~= previousMouth then
        pings.changeMouth(currentMouth)
        previousMouth = currentMouth
    end

    -- Определяем работает ли микрофон
    if oldVoiceLevel ~= voiceLevel then
        isMicWorking = true
        oldVoiceLevel = voiceLevel
    else
        isMicWorking = false
    end

    -- Если микрофон не работает а рот не закрыт то закрываем его
    if not isMicWorking and (currentMouth ~= "0" or previousMouth ~= "0") then
        currentMouth = "0"
        pings.changeMouth(currentMouth)
    end
end
