function pings.playAnimation(modelName, animationTag, animationName, shouldntStopOtherAnimations)
    if not shouldntStopOtherAnimations then animations:getTags()[animationTag]:stop() end
    animations[modelName][animationName]:play()
end

function pings.stopAnimations(animationTag)
    if animationTag then
        animations:getTags()[animationTag]:stop()
        return
    end

    animations:stopAll()
end

function pings.setMouthHeight(Y) models.player.root.Center.Torso.Head.Mouth:setPos(nil, Y, nil) end
