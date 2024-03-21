------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    爱之深

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function GetStringsTable(prefab_name)
        return TUNING["underworld_hana.fn"].GetStringsTable(prefab_name or "underworld_hana_weapon_deep_love")
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local CD_TIME = TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 1 or 10
    local BASE_DAMAGE = 34
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local assets =
    {
        Asset("ANIM", "anim/underworld_hana_weapon_deep_love.zip"),
        Asset("ANIM", "anim/underworld_hana_weapon_deep_love_swap.zip"),
        Asset( "IMAGE", "images/inventoryimages/underworld_hana_weapon_deep_love.tex" ),
        Asset( "ATLAS", "images/inventoryimages/underworld_hana_weapon_deep_love.xml" ),


    }
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function onequip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "underworld_hana_weapon_deep_love_swap", "swap_object")
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
    local function cast_spell(inst,doer,pt)
        local crash_flag,crash_reason = pcall(function()
                                
            ----------------------------------------------------------------------------------------------------------------
            local x,y,z = pt.x,pt.y,pt.z
            ----------------------------------------------------------------------------------------------------------------
                local range = 4

            ----------------------------------------------------------------------------------------------------------------
            ---- 能拆掉的东西
                local workable_ents = TheSim:FindEntities(x, 0, z, range, nil, nil, {"CHOP_workable","DIG_workable","HAMMER_workable","MINE_workable"})
                for i, v in ipairs(workable_ents) do
                    if v:IsValid() then
                        if v.components.workable then
                            v.components.workable:Destroy(doer)
                        end
                    end
                end
            ----------------------------------------------------------------------------------------------------------------
            ---- 地上的物品,晃动起来
                local function SmallLaunch(inst, launcher, basespeed)
                    local hp = inst:GetPosition()
                    local pt = launcher:GetPosition()
                    local vel = (hp - pt):GetNormalized()
                    local speed = basespeed * .5 + math.random()
                    local angle = math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
                    inst.Physics:Teleport(hp.x, .1, hp.z)
                    inst.Physics:SetVel(math.cos(angle) * speed, 3 * speed + math.random(), math.sin(angle) * speed)
                end

                local items_in_ground = TheSim:FindEntities(x, 0, z, range, { "_inventoryitem" }, { "locomotor", "INLIMBO" })
                for i, v in ipairs(items_in_ground) do
                    if v.components.mine ~= nil then
                        v.components.mine:Deactivate()
                    end
                    if not v.components.inventoryitem.nobounce and v.Physics ~= nil and v.Physics:IsActive() then
                        SmallLaunch(v, inst, 1.5)
                    end
                end
            ----------------------------------------------------------------------------------------------------------------
            ---- 造成伤害
                inst.components.weapon:SetDamage(BASE_DAMAGE*2) --- 伤害配置2倍
                local monsters = TheSim:FindEntities(x, y, z, range, nil, {"player","INLIMBO", "notarget", "noattack", "flight", "invisible","companion"}, nil)
                for k, temp_monster in pairs(monsters) do
                    if temp_monster and temp_monster:IsValid() and temp_monster.components.combat 
                        and temp_monster.components.combat:CanBeAttacked(doer) then
                            -- temp_monster.components.combat:GetAttacked(doer,damage,inst)
                            doer.components.combat:DoAttack(temp_monster)
                    end
                end
                inst.components.weapon:SetDamage(BASE_DAMAGE) -- 恢复原来的伤害

            ----------------------------------------------------------------------------------------------------------------
            ---- 特效
                SpawnPrefab("underworld_hana_fx_spell_antlion_hole"):PushEvent("Set",{
                    pt = pt,
                })
            ----------------------------------------------------------------------------------------------------------------
            ---- 让玩家1.5s无敌
                local tempInst = CreateEntity()
                doer.components.combat.externaldamagetakenmultipliers:SetModifier(tempInst, 0)
                doer:DoTaskInTime(1.5,function()
                    doer.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst)
                    tempInst:Remove()
                end)
            ----------------------------------------------------------------------------------------------------------------
            end)
            if not crash_flag then
                print("error",crash_reason)
            end
    end
------------------------------------------------------------------------------------------------------------------
---- 
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("underworld_hana_weapon_deep_love")
        inst.AnimState:SetBuild("underworld_hana_weapon_deep_love")
        inst.AnimState:PlayAnimation("idle",true)

        --weapon (from weapon component) added to pristine state for optimization
        inst:AddTag("weapon")
        inst:AddTag("underworld_hana_weapon_deep_love")

        MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85})


        inst.entity:SetPristine()
        -------------------------------------------------------------------------------------
        --- 技能
            inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_point_and_target_spell_caster",function(inst,replica_com)
                replica_com:SetText("underworld_hana_weapon_deep_love",GetStringsTable()["spell_str"])
                replica_com:SetSGAction("underworld_hana_sg_jump_split")    -- 施法的SG
                replica_com:SetDistance(20)
                replica_com:SetPriority(999)
                replica_com:SetAllowCanCastOnImpassable(false)
                replica_com:SetTestFn(function(inst,doer,target,pt,right_click)     --- 以30FPS 执行，注意CPU性能消耗
                    if not inst:HasTag("townportaltalisman") then
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
                    --- 施法
                        local x,y,z = 0,0,0
                        if target then
                            x,y,z = target.Transform:GetWorldPosition()
                        end
                        if pt then
                            x,y,z = pt.x,pt.y,pt.z
                        end
                        if doer.Physics then
                            doer.Physics:Teleport(x,y,z)
                        end
                        doer.Transform:SetPosition(x,y,z)
                        ---- 走RPC下发坐标传送，避免出闪现问题
                        doer:PushEvent("underworld_hana_event.player_teleport",{pt = Vector3(x,y,z)})
                    ------------------------------------------------------------------------------------
                    --- CD
                        local mult = doer.components.hana_com_spell_cd_modifier:GetMult()
                        inst.components.rechargeable:Discharge(CD_TIME*mult)
                    ------------------------------------------------------------------------------------
                    --- 耐久
                        inst.components.finiteuses:Use(3)
                    ------------------------------------------------------------------------------------
                    --- 执行法术
                        inst:DoTaskInTime(13 * FRAMES,function()
                            cast_spell(inst,doer,Vector3(x,y,z))
                        end)
                    ------------------------------------------------------------------------------------
                    return true
                end)
            end
        -------------------------------------------------------------------------------------
        --- 物品接受 townportaltalisman
            inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_acceptable",function(inst,replica_com)
                replica_com:SetSGAction("dolongaction")
                replica_com:SetTestFn(function(inst,item,doer)
                    if item.prefab ~= "townportaltalisman" then
                        return false
                    end
                    if inst:HasTag("townportaltalisman") then
                        return false
                    else
                        return true
                    end
                    return false
                end)
                replica_com:SetText("underworld_hana_weapon_deep_love",GetStringsTable()["unlock_str"])
            end)
            if TheWorld.ismastersim then
                inst:AddComponent("hana_com_acceptable")
                inst.components.hana_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst:AddTag("townportaltalisman")
                    inst.components.hana_com_data:Set("townportaltalisman",true)
                    return true
                end)
                ---- 记录已经添加过 沙之石
                inst:AddComponent("hana_com_data")
                inst.components.hana_com_data:AddOnLoadFn(function(com)
                    if com:Get("townportaltalisman") then
                        inst:AddTag("townportaltalisman")
                    end
                end)
            end
        -------------------------------------------------------------------------------------
        if not TheWorld.ismastersim then
            return inst
        end

        ------------------------------------------------------------------------------

        ------------------------------------------------------------------------------
            inst:AddComponent("weapon")
            inst.components.weapon:SetDamage(BASE_DAMAGE)
        ------------------------------------------------------------------------------
        --- 位面伤害
            inst:AddComponent("planardamage")
            inst.components.planardamage:SetBaseDamage(10)
        ------------------------------------------------------------------------------
            inst:AddComponent("inspectable")

            inst:AddComponent("inventoryitem")
            -- inst.components.inventoryitem:ChangeImageName("voidcloth_scythe")
            inst.components.inventoryitem.imagename = "underworld_hana_weapon_deep_love"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_weapon_deep_love.xml"

            inst:AddComponent("equippable")

            inst.components.equippable:SetOnEquip(onequip)
            inst.components.equippable:SetOnUnequip(onunequip)

            MakeHauntableLaunch(inst)


        ------------------------------------------------------------------------------
        --- rechargeable 冷却系统
            inst:AddComponent("rechargeable")
            inst.components.rechargeable:SetMaxCharge(CD_TIME)

            
        ------------------------------------------------------------------------------
        --- 耐久度
            inst:AddComponent("finiteuses")
            inst.components.finiteuses:SetMaxUses(800)
            inst.components.finiteuses:SetUses(800)
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
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------

return Prefab("underworld_hana_weapon_deep_love", fn, assets)
