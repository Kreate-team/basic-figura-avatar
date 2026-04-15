local skinModelParts = {
    models.player.root.Center.LeftLeg,
    models.player.root.Center.RightLeg,
    models.player.root.Center.Torso.RightArm,
    models.player.root.Center.Torso.LeftArm,
    models.player.root.Center.Torso.Body,
    models.player.root.Center.Torso.Head.Head,
    models.player.root.Center.Torso.Head.Hat
}
for _, modelPart in ipairs(skinModelParts) do modelPart:setPrimaryTexture("SKIN") end

vanilla_model.PLAYER:setVisible(false)

function events.entity_init()
    models.player.root.Center.Torso.LeftArm.WideLAT:setVisible(player:getModelType() == "DEFAULT")
    models.player.root.Center.Torso.LeftArm.SlimLAT:setVisible(player:getModelType() ~= "DEFAULT")
    models.player.root.Center.Torso.LeftArm.LeftElbow.WideLAB:setVisible(player:getModelType() == "DEFAULT")
    models.player.root.Center.Torso.LeftArm.LeftElbow.SlimLAB:setVisible(player:getModelType() ~= "DEFAULT")
    models.player.root.Center.Torso.RightArm.WideRAT:setVisible(player:getModelType() == "DEFAULT")
    models.player.root.Center.Torso.RightArm.SlimRAT:setVisible(player:getModelType() ~= "DEFAULT")
    models.player.root.Center.Torso.RightArm.RightElbow.WideRAB:setVisible(player:getModelType() == "DEFAULT")
    models.player.root.Center.Torso.RightArm.RightElbow.SlimRAB:setVisible(player:getModelType() ~= "DEFAULT")
end
