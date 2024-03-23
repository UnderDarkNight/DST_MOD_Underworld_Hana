------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    local player = inst.entity:GetParent()
    -----------------------------------------------------
        if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
            TheNet:Announce(" 骨甲的特殊效果 ")
        end

        local temp_apply_damage_fn = function(inventory_self,damage,attacker, weapon, spdamage,...)
            -----------------------------------------------------------------
                if inst.__cool_down_task then
                    return damage,attacker, weapon, spdamage,...
                end
            -----------------------------------------------------------------
                if inst.__protectting_task == nil then
                    inst.__protectting_task = inst:DoTaskInTime(1,function()
                        inst.__protectting_task = nil
                        inst.__cool_down_task = inst:DoTaskInTime(5,function()
                            inst.__cool_down_task = nil
                        end)
                    end)
                end
            -----------------------------------------------------------------
                damage = 0
                if spdamage then
                    spdamage = 0
                end
                player:SpawnChild("underworld_hana_fx_shadow_shell"):PushEvent("Set",{
                    pt = Vector3(0,0,0)
                })
                return damage,attacker,weapon,spdamage,...
            -----------------------------------------------------------------
        end
        player.components.inventory:Hana_Add_ApplyDamage_Fn(temp_apply_damage_fn)


        inst:ListenForEvent("underworld_hana_event.danger_music_stop",function()
            -- player.components.hana_com_tag_sys:AddTag("block_all_damage_by_shadow")
            player.components.inventory:Hana_Remove_ApplyDamage_Fn(temp_apply_damage_fn)
            inst:Remove()
            if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
                TheNet:Announce(" 移除：骨甲的特殊效果 ")
            end
        end,player)
        inst:ListenForEvent("death",function()
            -- player.components.hana_com_tag_sys:AddTag("block_all_damage_by_shadow")
            player.components.inventory:Hana_Remove_ApplyDamage_Fn(temp_apply_damage_fn)
            inst:Remove()
            if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
                TheNet:Announce(" 移除：骨甲的特殊效果 ")
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

return Prefab("underworld_hana_debuff_power_skeleton_protect", fn)
