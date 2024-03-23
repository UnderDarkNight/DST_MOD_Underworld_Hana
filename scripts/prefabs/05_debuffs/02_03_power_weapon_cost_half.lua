------------------------------------------------------------------------------------------------------------------------------------------------

local function OnAttached(inst,target) -- 玩家得到 debuff 的瞬间。 穿越洞穴、重新进存档 也会执行。
    inst.entity:SetParent(target.entity)
    inst.Network:SetClassifiedTarget(target)
    local player = inst.entity:GetParent()
    -----------------------------------------------------
        local function add_modifier_2_equipment(inst,item)
            if item == inst then
                return
            end
            if item.components.weapon then
                item.components.weapon.attackwearmultipliers:SetModifier(inst,TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 0 or  0.7)
            end
            -- if item.components.armor then
            --     item.components.armor.conditionlossmultipliers:SetModifier(inst,TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 0 or 0.7)
            -- end
            -- print("++++++ add_modifier_2_equipment +++++",item)
        end
        local function remove_modifier_from_equipment(inst,item)
            if item.components.weapon then
                item.components.weapon.attackwearmultipliers:RemoveModifier(inst)
            end
            -- if item.components.armor then
            --     item.components.armor.conditionlossmultipliers:RemoveModifier(inst)
            -- end
            -- print("++++++ remove_modifier_from_equipment +++++",item)
        end
    -----------------------------------------------------
        if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
            TheNet:Announce(" 武器的耐久消耗降低30% ")
        end

        inst:ListenForEvent("equip",function(inst,_table)
            local item = _table and _table.item
            if item then
                add_modifier_2_equipment(inst,item)
            end
        end,player)
        inst:ListenForEvent("unequip",function(inst,_table)
            local item = _table and _table.item
            if item then
                remove_modifier_from_equipment(inst,item)
            end
        end,player)

        for k, temp_item in pairs(player.components.inventory.equipslots) do
            if temp_item then
                add_modifier_2_equipment(inst,temp_item)
            end
        end

        player.components.sanity.neg_aura_modifiers:SetModifier(inst,0.5)  --- 理智光环减半
        inst:ListenForEvent("underworld_hana_event.danger_music_stop",function()
            inst:Remove()
            if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
                TheNet:Announce(" 移除 武器的耐久消耗降低30% ")
            end
        end,player)
        inst:ListenForEvent("death",function()
            inst:Remove()
            if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
                TheNet:Announce(" 移除 武器的耐久消耗降低30% ")
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

return Prefab("underworld_hana_debuff_power_weapon_cost_half", fn)
