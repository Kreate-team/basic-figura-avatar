animations.player.armsWave:addTags("Arms")
animations.player.armsPointUp:addTags("Arms")

--#region VoiceChatLib
local mouthModelPart = models.player.root.Center.Torso.Head.Mouth
function events.tick()
    if not player:isLoaded() then return end

    local mouthUV = 16
    if voiceChat.get.smoothHostVoiceVolume < 1.00 then mouthUV = 12 end
    if voiceChat.get.smoothHostVoiceVolume < 0.50 then mouthUV = 08 end
    if voiceChat.get.smoothHostVoiceVolume < 0.15 then mouthUV = 04 end
    if voiceChat.get.smoothHostVoiceVolume < 0.05 then mouthUV = 00 end

    if mouthUV ~= mouthModelPart:getUVPixels() then mouthModelPart:setUVPixels(mouthModelPart:getUVPixels()[1], mouthUV) end
end
--#endregion
