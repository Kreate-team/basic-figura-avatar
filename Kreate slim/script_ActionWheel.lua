-- Создание страниц колеса действий и включение основной страницы при инииализации
mainPage = action_wheel:newPage()
settingsPage = action_wheel:newPage()
actionsPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

-- Кнопки главной страницы
goToSettingsPage = mainPage:newAction() -- При нажатии ведёт на страницу настроек
    :title("Настройки")
    :item("minecraft:command_block")
    :hoverColor(1, 1, 1)
    :color(0.5, 0.5, 0.5)
    :onLeftClick(function()
        action_wheel:setPage(settingsPage)
        sounds:playSound("item.axe.strip", player:getPos())
    end) 
goToActionsPage = mainPage:newAction() -- При нажатии ведёт на страницу списка действий
    :title("Действия")
    :item("minecraft:light")
    :hoverColor(1, 0.5, 0.5)
    :color(0.5, 0.25, 0.25)
    :onLeftClick(function()
        action_wheel:setPage(actionsPage)
        sounds:playSound("item.axe.strip", player:getPos())
    end)

-- Кнопки страницы настроек
actionGoBack = settingsPage:newAction() -- При нажатии ведёт на главную страницу
    :title("Вернуться назад")
    :item("minecraft:spectral_arrow")
    :hoverColor(1, 1, 1)
    :color(0.5, 0.5, 0.5)
    :onLeftClick(function()
        action_wheel:setPage(mainPage)
        sounds:playSound("item.axe.strip", player:getPos())
    end)
settingToggleArmorVisibility = settingsPage:newAction() -- При нажатии переключает видимость брони
    :title("Сделать броню видимой")
    :toggleTitle("Сделать броню невидимой")
    :color(0.75, 0, 0)
    :toggleColor(0, 0.75, 0)
    :hoverColor(1, 1, 1)
    :item("minecraft:chainmail_chestplate")
    :toggleItem("minecraft:netherite_chestplate")
    :toggled(true)
    :onToggle(function()
        pings.ArmorVisibility(settingToggleArmorVisibility:isToggled())
        if settingToggleArmorVisibility:isToggled() then
            sounds:playSound("block.beacon.activate", player:getPos())
        else
            sounds:playSound("block.beacon.deactivate", player:getPos())
        end
    end)
settingCameraShouldBeOnShoulder = settingsPage:newAction() -- При нажатии переключает перенос камеры от третьего лица на плечо
    :title("Поместить камеру на плечо")
    :toggleTitle("Снять камеру с плеча")
    :color(0.75, 0, 0)
    :toggleColor(0, 0.75, 0)
    :hoverColor(1, 1, 1)
    :item("minecraft:spyglass")
    :onToggle(function()
        if settingCameraShouldBeOnShoulder:isToggled() then
            sounds:playSound("block.beacon.activate", player:getPos())
        else
            sounds:playSound("block.beacon.deactivate", player:getPos())
        end
    end)
mouthHeight = settingsPage:newAction()
    :title("Редактирование высоты рта")
    :item("minecraft:axolotl_bucket")
    :hoverColor(1, 1, 1)
    :color(0.5, 0.5, 0.5)
    :onScroll(function (dir)
        mouthPos = models.model.root.Body.Head.Mouth:getPos()[2]
        if dir > 0 and mouthPos < 6 then
            pings.changeMouthHeight(mouthPos + 0.5)
        elseif dir < 0 and mouthPos > -1.5 then
            pings.changeMouthHeight(mouthPos - 0.5)
        end
    end)

-- Кнопки страницы действий
actionGoBack = actionsPage:newAction() -- При нажатии ведёт на главную страницу
    :title("Вернуться назад")
    :item("minecraft:spectral_arrow")
    :hoverColor(1, 1, 1)
    :color(0.5, 0.5, 0.5)
    :onLeftClick(function()
        action_wheel:setPage(mainPage)
        sounds:playSound("item.axe.strip", player:getPos())
    end)
stopAllActions = actionsPage:newAction() -- При нажатии останавливает все действия
    :title("Остановить действие")
    :item("minecraft:tnt")
    :hoverColor(1, 0, 0)
    :color(0.75, 0, 0)
    :onLeftClick(function()
        pings.stopActions()
        sounds:playSound("block.calcite.place", player:getPos())
    end)
actionPointUp = actionsPage:newAction() -- При нажатии правая рука аватара будет указывать на место куда смотрит игрок
    :title("Указать на место")
    :setTexture(textures["assets.icons.pointUpIcon"])
    :hoverColor(0, 1, 1)
    :color(0, 0.75, 0.75)
    :onLeftClick(function()
        pings.pointUp()
        sounds:playSound("block.calcite.place", player:getPos())
    end)
actionWave = actionsPage:newAction() -- При нажатии воспроизводит анимацию помахивания рукой
    :title("Приветствие")
    :setTexture(textures["assets.icons.waveIcon"])
    :hoverColor(0, 1, 1)
    :color(0, 0.75, 0.75)
    :onLeftClick(function()
        pings.wave()
        sounds:playSound("block.calcite.place", player:getPos())
    end)
