------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    local player = inst.entity:GetParent()
    -----------------------------------------------------
        if not TheWorld.ismastersim then
            return
        end

        if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
            TheNet:Announce("【不死权能】 buff 添加")
        end

        local dmg_percent_num  = TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 0.5 or 0.3
        player.components.combat.externaldamagemultipliers:SetModifier(inst,dmg_percent_num + 1)

        local speed_percent_num  = TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 0.5 or 0.3
        player.components.locomotor:SetExternalSpeedMultiplier(inst, "underworld_hana_debuff_reinforcement", speed_percent_num+1)




        inst:DoTaskInTime(10,function()
            inst:Remove()
            player.components.combat.externaldamagemultipliers:RemoveModifier(inst)
            player.components.locomotor:RemoveExternalSpeedMultiplier(inst, "underworld_hana_debuff_reinforcement")
            if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
                TheNet:Announce("【不死权能】 buff 到期")
            end
        end)

    -----------------------------------------------------
end

local function OnDetached(inst) -- 被外部命令  inst:RemoveDebuff 移除debuff 的时候 执行
    local player = inst.entity:GetParent()
end

local function OnUpdate(inst)
    local player = inst.entity:GetParent()

end

local function ExtendDebuff(inst)
    -- inst.countdown = 3 + (inst._level:value() < CONTROL_LEVEL and EXTEND_TICKS or math.floor(TUNING.STALKER_MINDCONTROL_DURATION / FRAMES + .5))
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("debuff")
    inst.components.debuff:SetAttachedFn(OnAttached)
    inst.components.debuff.keepondespawn = false -- 是否保持debuff 到下次登陆
    -- inst.components.debuff:SetDetachedFn(inst.Remove)
    inst.components.debuff:SetDetachedFn(OnDetached)
    -- inst.components.debuff:SetExtendedFn(ExtendDebuff)
    -- ExtendDebuff(inst)

    inst:DoPeriodicTask(1, OnUpdate, nil, TheWorld.ismastersim)  -- 定时执行任务


    return inst
end

return Prefab("underworld_hana_debuff_reinforcement", fn)
