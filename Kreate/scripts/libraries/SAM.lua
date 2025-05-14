--[[
    ■■■■■
    ■   ■ Sh1zok's Actions Manager
    ■■■■  v2.2
]]--

--[[
    Non-host side
]]--
stopingAnimsList = {} -- Список анимаций несовместимых с действиями
actionsList = {} -- Список действий
activeAction = {"§cnil§f", nil, 0, {}} -- Активное действие

-- Функция для остоновки всех действий
function stopAllActions()
    for _, action in ipairs(actionsList) do
        if action[2] ~= nil then
            action[2]:stop()
        end
    end

    activeAction = {"§cnil§f", nil, 0, {}}
end

-- Функция для определения момента когда нужно остановить все действия
function events.tick()
    for _, group in ipairs(activeAction[4]) do
        for _, animation in ipairs(stopingAnimsList[group]) do
            if animation:isPlaying() then stopAllActions() end
        end
    end
end

-- Пинг проигрывающий действие
function pings.playAction(selection)
    stopAllActions() -- Остановка всех действий

    activeAction = actionsList[selection] -- Выбор активного действия

    if activeAction[2] ~= nil then
        activeAction[2]:play() -- Проигрывание активного действия
        activeAction[2]:setPriority(activeAction[3])
    end
end

-- Пинг останавливающий действие
function pings.stopAction()
    stopAllActions()
end

-- Функция для задания интерполяции анимаций действий если среди библиотек есть GSAnimBlend
function blendActionAnimations(blendValue)
    -- Находим GSAnimBlend
    local GSAnimBlendIsHere = false
    for _, key in ipairs(listFiles(nil,true)) do
        if key:find("GSAnimBlend$") then
            GSAnimBlendIsHere = true
            break
        end
    end

    -- Если GSAnimBlend найден, то устанавливаем анимациям действий интерполяцию
    if GSAnimBlendIsHere then
        for _, action in ipairs(actionsList) do
            if action[2] ~= nil then
                action[2]:setBlendTime(blendValue)
            end
        end
    end
end

if not host:isHost() then return end

--[[
    Host-only side
]]--
local selectedAction = 1 -- Выбор действия

-- Функция формирующая титул кнопки
function updateActionButtonTitle()
    -- Название кнопки и её описание
    local title = (actionButtonTitle or "Действие") .. ": " .. activeAction[1] .. "\n §7" .. (actionButtonDescription or "Прокручивание вниз: Следующее действие\n Прокручивание вверх: Предыдущее действие\n ЛКМ: Выбрать действие\n ПКМ: Остановить действие\n\n Список действий:\n")

    -- Определение нижнего и вернего индекса списка действий
    local descriptionListTop = selectedAction - math.floor((actionsListDescriptionSize or 99) / 2)
    local descriptionListBottom = selectedAction + math.floor((actionsListDescriptionSize or 99) / 2)
    if descriptionListTop < 1 then
        descriptionListTop = 1 
        descriptionListBottom = (actionsListDescriptionSize or 99)
    end
    if descriptionListBottom > #actionsList then
        descriptionListBottom = descriptionListBottom - (descriptionListBottom - #actionsList) + 1
        descriptionListTop = descriptionListBottom - (actionsListDescriptionSize or 99)
    end

    -- Список действий
    for index, value in ipairs(actionsList) do
        if index >= descriptionListTop and index <= descriptionListBottom then
            if index == selectedAction then -- Выделение выбираемого действия акцентным цветом
                title = title .. "\n " .. (actionButtonAccentColor or "§f") .. index .. ". " .. value[1]
            else -- Остальные более тусклым
                title = title .. "\n " .. (actionButtonCommonColor or "§8") .. index .. ". " .. value[1]
            end
        end
    end

    return(title) -- Возвращаем готовый титул кнопки
end

-- Функция для активации действий
function actionButtonPlay()
    pings.playAction(selectedAction) -- Активируем действие
    activeAction = actionsList[selectedAction] -- Активное действие
end

-- Функция для остановки действий
function actionButtonStop()
    pings.stopAction() -- Останавливаем действие
end

-- Функция для выбора действия
function actionButtonSelect(dir)
    if dir < 0 then -- При прокручивании вверх
        if selectedAction ~= #actionsList then
            selectedAction = selectedAction + 1
        else -- Переход в конец списка если выбор в начале списка
            selectedAction = 1
        end
    else -- При прокручивании вниз
        if selectedAction ~= 1 then
            selectedAction = selectedAction - 1
        else -- Переход в начало списка если выбор в конце списка
            selectedAction = #actionsList
        end
    end
end
