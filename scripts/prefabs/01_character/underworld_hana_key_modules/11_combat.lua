--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    -- inst:ListenForEvent("underworld_hana_master_postinit",function()
        

    -- end)
        local tempInst = CreateEntity()
        inst:ListenForEvent("onremove",function()
            tempInst:Remove()
        end)
        local block_task = nil


        inst:ListenForEvent("attacked",function(inst)
            if block_task ~= nil then
                return
            end
            inst.components.combat.externaldamagetakenmultipliers:SetModifier(tempInst,0)
            block_task = inst:DoTaskInTime(2,function()
                inst.components.combat.externaldamagetakenmultipliers:RemoveModifier(tempInst)                
                block_task = nil
            end)
        end)

end