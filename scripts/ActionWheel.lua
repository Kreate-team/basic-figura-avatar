if not host:isHost() then return end

local mainPage = action_wheel:newPage()
local settingsPage = action_wheel:newPage()
local actionsPage = action_wheel:newPage()

action_wheel:setPage(actionsPage)



mainPage:newAction()
    :title("Настройки")
    :item("minecraft:tnt_minecart")
    :hoverColor(vectors.hexToRGB("#ed7619"))
    :color(vectors.hexToRGB("#CF5C16"))
    :onLeftClick(function()
        action_wheel:setPage(settingsPage)
        sounds:playSound("block.calcite.place", player:getPos())
    end)
mainPage:newAction()
    :title("Действия")
    :item("minecraft:axolotl_bucket")
    :hoverColor(vectors.hexToRGB("#ed7619"))
    :color(vectors.hexToRGB("#CF5C16"))
    :onLeftClick(function()
        action_wheel:setPage(actionsPage)
        sounds:playSound("block.calcite.place", player:getPos())
    end)



actionsPage:newAction()
    :title("Назад")
    :item("minecraft:structure_void")
    :hoverColor(vectors.hexToRGB("#ed7619"))
    :color(vectors.hexToRGB("#962910"))
    :onLeftClick(function()
        action_wheel:setPage(mainPage)
        sounds:playSound("block.calcite.place", player:getPos())
    end)
actionsPage:newActionList()
    :title("Действия")
    :item("minecraft:brush")
    :hoverColor(vectors.hexToRGB("#f29d5a"))
    :color(vectors.hexToRGB("#ed7619"))
    :actionList({
        [1] = {
            title = "Приветствие",
            item = "minecraft:netherite_upgrade_smithing_template",
            onLeftClick = function() pings.playAnimation("player", "Arms", "armsWave") end,
            onRightClick = function() pings.stopAnimations("Arms") end
        },
        [2] = {
            title = "Указать рукой",
            item = "minecraft:spyglass",
            onLeftClick = function() pings.playAnimation("player", "Arms", "armsPointUp") end,
            onRightClick = function() pings.stopAnimations("Arms") end
        }
    })
    :onLeftClick(function() sounds:playSound("block.calcite.place", player:getPos()) end)
    :setOnScroll(function() sounds:playSound("block.lever.click", player:getPos(), 1, 2, false) end)



settingsPage:newAction()
    :title("Назад")
    :item("minecraft:structure_void")
    :hoverColor(vectors.hexToRGB("#ed7619"))
    :color(vectors.hexToRGB("#962910"))
    :onLeftClick(function()
        action_wheel:setPage(mainPage)
        sounds:playSound("block.calcite.place", player:getPos())
    end)
SetMouthHeightButton = settingsPage:newAction()
    :title("Высота рта: " .. (config:load("sync")["mouthHeight"] or 0) .. "\n  §8Управление высотой\n  рта производится\n  колёсиком мыши")
    :hoverColor(vectors.hexToRGB("#ed7619"))
    :color(vectors.hexToRGB("#CF5C16"))
    :item("minecraft:pufferfish")
    :onScroll(function(scrollDirection)
        local syncConfig = config:load("sync")
        syncConfig["mouthHeight"] = math.clamp((syncConfig["mouthHeight"] or 0) + scrollDirection * 0.25, -1.5, 6)
        config:save("sync", syncConfig)

        pings.setMouthHeight(syncConfig["mouthHeight"])
        SetMouthHeightButton:title("Высота рта: " .. tostring(syncConfig["mouthHeight"]) .. "\n  §8Управление высотой\n  рта производится\n  колёсиком мыши")

        sounds:playSound("block.calcite.place", player:getPos())
    end)