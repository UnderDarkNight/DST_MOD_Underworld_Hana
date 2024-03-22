--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    在坟区 不会有  San 的自然升降
    
    mound 坑
    gravestone  墓碑
    

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    -- inst:DoTaskInTime(0,function()
    --     inst.components.sanity.rate_modifier
    -- end)

    inst:DoPeriodicTask(5,function()
        
        local x,y,z = inst.Transform:GetWorldPosition()
        local canthavetags = nil
        local musthavetags = nil
        local musthaveoneoftags = {"grave"}
        local ents = TheSim:FindEntities(x, 0, z, 20, musthavetags, canthavetags, musthaveoneoftags)
        if #ents > 6 then
            inst.components.sanity.rate_modifier = 0
            -- if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
            --     print("哈娜进入坟区")
            -- end
        else
            inst.components.sanity.rate_modifier = 1
            -- if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
            --     print("哈娜离开坟区")
            -- end
        end

    end)

end