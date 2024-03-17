------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    红莲刀

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function GetStringsTable(prefab_name)
        return TUNING["underworld_hana.fn"].GetStringsTable(prefab_name or "underworld_hana_weapon_red_lotus")
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local CD_TIME = TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 1 or 8
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local assets =
    {
        Asset("ANIM", "anim/underworld_hana_weapon_red_lotus.zip"),
        Asset("ANIM", "anim/underworld_hana_weapon_red_lotus_swap.zip"),
        Asset( "IMAGE", "images/inventoryimages/underworld_hana_weapon_red_lotus.tex" ),
        Asset( "ATLAS", "images/inventoryimages/underworld_hana_weapon_red_lotus.xml" ),


    }
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function onequip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "underworld_hana_weapon_red_lotus_swap", "swap_object")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end

    local function onunequip(inst, owner)
        owner.AnimState:ClearOverrideSymbol("swap_object")
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
    end
------------------------------------------------------------------------------------------------------------------
--- 
------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("underworld_hana_weapon_red_lotus")
    inst.AnimState:SetBuild("underworld_hana_weapon_red_lotus")
    inst.AnimState:PlayAnimation("idle",true)

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("underworld_hana_weapon_red_lotus")

    MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85})


    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    --- 技能
        inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_point_and_target_spell_caster",function(inst,replica_com)
            replica_com:SetText("underworld_hana_weapon_red_lotus",GetStringsTable()["spell_str"])
            replica_com:SetSGAction("underworld_hana_scythe_harvest")
            replica_com:SetDistance(20)
            replica_com:SetPriority(999)
            replica_com:SetAllowCanCastOnImpassable(true)
            replica_com:SetTestFn(function(inst,doer,target,pt,right_click)     --- 以30FPS 执行，注意CPU性能消耗
                if not inst:HasTag("dragon_scales") then
                    return false
                end
                -- pcall(function()
                --     print(inst.replica.inventoryitem.classified.recharge:value())
                -- end)
                if right_click and doer ~= target then
                    if inst.replica.inventoryitem.classified and inst.replica.inventoryitem.classified.recharge:value() == 180 then
                        return true
                    end
                end
                return false
            end)

        end)
        if TheWorld.ismastersim then
            inst:AddComponent("hana_com_point_and_target_spell_caster")
            inst.components.hana_com_point_and_target_spell_caster:SetSpellFn(function(inst,doer,target,pt)
                ------------------------------------------------------------------------------------
                --- 冷却
                    if not inst.components.rechargeable:IsCharged() then
                        return true
                    end
                ------------------------------------------------------------------------------------
                --- 基点坐标
                    local x,y,z = doer.Transform:GetWorldPosition()
                    if target then
                        x,y,z = target.Transform:GetWorldPosition()
                    end
                    if pt then
                        x,y,z = pt.x,pt.y,pt.z
                    end
                ------------------------------------------------------------------------------------
                --- 坐标和角度函数
                    doer:ForceFacePoint(x, y, z)

                    local player_pt = Vector3(doer.Transform:GetWorldPosition())
                    local delta_x,delata_y,delta_z = x-player_pt.x, 0 ,z-player_pt.z
                    local angle = math.deg(math.atan2(delta_z, delta_x))
                    -- local distance = 4

                    local function get_offset_pt_by_angle(angle,distance)
                        return Vector3(math.cos(math.rad(angle))*distance,0,math.sin(math.rad(angle))*distance )                    
                    end
                ------------------------------------------------------------------------------------
                ---- 扇形火焰特效，。 最大距离： 6.4
                    for i = 1, 8, 1 do
                        local color = Vector3(255,0,0)
                        local scale = (0.5/3)*i+0.5
                        local MultColour_Flag = true
                        inst:DoTaskInTime((i-1)*0.05,function()                        
                            local offset_pt = get_offset_pt_by_angle(angle,i*0.8)
                            SpawnPrefab("underworld_hana_fx_spell_flame"):PushEvent("Set",{
                                pt = player_pt+offset_pt,
                                -- time = 5,
                                color = color,
                                scale = scale,
                                type = math.random(3),
                                MultColour_Flag = MultColour_Flag,
                            })
                            local offset_pt2 = get_offset_pt_by_angle(angle+20,i*0.8)
                            SpawnPrefab("underworld_hana_fx_spell_flame"):PushEvent("Set",{
                                pt = player_pt+offset_pt2,
                                -- time = 5,
                                color = color,
                                scale = scale,
                                type = math.random(3),
                                MultColour_Flag = MultColour_Flag,
                            })
                            local offset_pt3 = get_offset_pt_by_angle(angle-20,i*0.8)
                            SpawnPrefab("underworld_hana_fx_spell_flame"):PushEvent("Set",{
                                pt = player_pt+offset_pt3,
                                -- time = 5,
                                color = color,
                                scale = scale,
                                type = math.random(3),
                                MultColour_Flag = MultColour_Flag,
                            })
                        end)

                    end
                ------------------------------------------------------------------------------------
                ---- 点火
                    inst:DoTaskInTime(0.3,function()                        
                            local flame_range = 4
                            local flame_base_pt = player_pt+get_offset_pt_by_angle(angle,3)
                            local musthavetags = nil
                            local canthavetags = {"burnt","player","INLIMBO", "notarget", "noattack", "flight", "invisible","companion"}
                            local musthaveoneoftags = nil
                            local ents = TheSim:FindEntities(flame_base_pt.x, 0, flame_base_pt.z, flame_range, musthavetags, canthavetags, musthaveoneoftags)
                            for k, temp_target in pairs(ents) do
                                if temp_target and temp_target:IsValid() then
                                    ----------------- 点燃
                                        if temp_target.components.burnable then
                                            if not temp_target.components.burnable:IsBurning() then
                                                temp_target.components.burnable:Ignite(true, doer)
                                            end
                                        end
                                    ----------------- 造成伤害
                                        if temp_target.components.combat then
                                            -- if temp_target.components.burnable then
                                            --     temp_target.components.combat:GetAttacked(doer,51,inst)
                                            -- else
                                            --     temp_target.components.combat:GetAttacked(doer,51*2,inst)                                                
                                            -- end
                                            doer.components.combat:DoAttack(temp_target,inst)
                                        end

                                end
                            end
                    end)
                ------------------------------------------------------------------------------------
                --- 声音
                    doer.SoundEmitter:PlaySound("rifts3/mutated_varg/blast_pre_f17")
                ------------------------------------------------------------------------------------
                --- CD
                    inst.components.rechargeable:Discharge(CD_TIME)
                ------------------------------------------------------------------------------------
                --- 耐久
                    inst.components.finiteuses:Use(3)
                ------------------------------------------------------------------------------------
                return true
            end)
        end
    -------------------------------------------------------------------------------------
    --- 物品接受 dragon_scales
        inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_acceptable",function(inst,replica_com)
            replica_com:SetSGAction("dolongaction")
            replica_com:SetTestFn(function(inst,item,doer)
                if item.prefab ~= "dragon_scales" then
                    return false
                end
                if inst:HasTag("dragon_scales") then
                    return false
                else
                    return true
                end
                return false
            end)
            replica_com:SetText("underworld_hana_weapon_red_lotus",GetStringsTable()["unlock_str"])
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("hana_com_acceptable")
            inst.components.hana_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
                if item.components.stackable then
                    item.components.stackable:Get():Remove()
                else
                    item:Remove()
                end
                inst:AddTag("dragon_scales")
                inst.components.hana_com_data:Set("dragon_scales",true)
                return true
            end)
            ---- 记录已经添加过 龙鳞
            inst:AddComponent("hana_com_data")
            inst.components.hana_com_data:AddOnLoadFn(function(com)
                if com:Get("dragon_scales") then
                    inst:AddTag("dragon_scales")
                end
            end)
        end
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    ------------------------------------------------------------------------------
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(51)
        local old_GetDamage = inst.components.weapon.GetDamage
        inst.components.weapon.GetDamage = function(self,attacker,target)
            local dmg, spdmg = old_GetDamage(self,attacker,target)
            if target then
                if target.components.burnable then
                    dmg = 51
                else
                    dmg = dmg*2
                end
            end
            return dmg, spdmg
        end
    ------------------------------------------------------------------------------
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("voidcloth_scythe")
        inst.components.inventoryitem.imagename = "underworld_hana_weapon_red_lotus"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_weapon_red_lotus.xml"

        inst:AddComponent("equippable")

        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)

        MakeHauntableLaunch(inst)

    ------------------------------------------------------------------------------
    --- 位面伤害
        inst:AddComponent("planardamage")
	    inst.components.planardamage:SetBaseDamage(25.5)
    ------------------------------------------------------------------------------
    --- rechargeable 冷却系统
        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetMaxCharge(CD_TIME)
        -- inst.components.rechargeable:SetOnChargedFn(function(inst)  ---- 冷却时间到了
        --     inst:AddTag("can_cast_spell")
        -- end)
        -- inst.components.rechargeable:SetOnDischargedFn(function(inst)  ---- 开始冷却计时
        --     inst:RemoveTag("can_cast_spell")
        -- end)
        -- inst:DoTaskInTime(0,function()
        --     if inst.components.rechargeable:IsCharged() then
        --         inst:AddTag("can_cast_spell")
        --     end
        -- end)
        
    ------------------------------------------------------------------------------
    --- 耐久度
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(600)
        inst.components.finiteuses:SetUses(600)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
    ------------------------------------------------------------------------------
    --- 落水影子
        local function shadow_init(inst)
            if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                -- inst.AnimState:Hide("SHADOW")
                inst.AnimState:PlayAnimation("water")
            else                                
                -- inst.AnimState:Show("SHADOW")
                inst.AnimState:PlayAnimation("idle")
            end
        end
        inst:ListenForEvent("on_landed",shadow_init)
        shadow_init(inst)
    ------------------------------------------------------------------------------

    ------------------------------------------------------------------------------

    return inst
end

return Prefab("underworld_hana_weapon_red_lotus", fn, assets)
