------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    local player = inst.entity:GetParent()
    -----------------------------------------------------
        if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
            TheNet:Announce(" 每次攻击+1血量 ")
        end
        inst:ListenForEvent("onhitother",function()
            player.components.health:DoDelta(1,true)
        end,player)
        inst:ListenForEvent("underworld_hana_event.danger_music_stop",function()
            inst:Remove()
            if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
                TheNet:Announce(" 移除：每次攻击+1血量 ")
            end
        end,player)
        inst:ListenForEvent("death",function()
            inst:Remove()
            if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
                TheNet:Announce(" 移除：每次攻击+1血量 ")
            end
        end,player)
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

return Prefab("underworld_hana_debuff_power_health_up_by_onhitother", fn)
