local syncingFunctions = {
    ["mouthHeight"] = function(Y) models.player.root.Center.Torso.Head.Mouth:setPos(nil, Y, nil) end,
}

function pings.synchronization(key, value) syncingFunctions[key](value) end



-- Host only instructions below
if not host:isHost() then return end

local syncCooldownTicks = 10
local syncedParameters = 0
if not config:load("sync") then config:save("sync", {}) end

function events.tick()
    syncCooldownTicks = syncCooldownTicks - 1
    if syncCooldownTicks > 0 then return end

    local syncTable = config:load("sync")
    for key, value in pairs(syncTable) do
        pings.synchronization(key, value)

        syncedParameters = syncedParameters + 1
        if syncedParameters > 5 then
            syncCooldownTicks = 20
            return nil
        end
    end

    syncedParameters = 0
    syncCooldownTicks = 1200
end
