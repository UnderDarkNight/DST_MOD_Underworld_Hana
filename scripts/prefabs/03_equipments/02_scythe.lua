------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    冥界之镰

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function GetStringsTable(prefab_name)
        return TUNING["underworld_hana.fn"].GetStringsTable(prefab_name or "underworld_hana_weapon_scythe")
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local assets =
    {
        Asset("ANIM", "anim/underworld_hana_weapon_scythe.zip"),
    }
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function onequip(inst, owner)

        -- owner.AnimState:OverrideSymbol("swap_object", "scythe_voidcloth", "swap_scythe")
        owner.AnimState:OverrideSymbol("swap_object", "underworld_hana_weapon_scythe", "swap_object")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")

        -- owner:AddTag("underworld_scythe.equipped")
        -- owner:AddTag("underworld_hana_tag.scythe_attack_action")


        -- local fx = SpawnPrefab("cane_candy_fx")
        -- fx.entity:SetParent(owner.entity)
        -- fx.entity:AddFollower()
        -- fx.Follower:FollowSymbol(owner.GUID, "swap_object", 0, -200, 0)
        -- inst.__eq_fx = fx

    end

    local function onunequip(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")

        -- owner:RemoveTag("underworld_scythe.equipped")
        -- owner:RemoveTag("underworld_hana_tag.scythe_attack_action")

        -- if inst.__eq_fx then
        --     inst.__eq_fx:Remove()
        --     inst.__eq_fx = nil
        -- end
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

    inst.AnimState:SetBank("underworld_hana_weapon_scythe")
    inst.AnimState:SetBuild("underworld_hana_weapon_scythe")
    inst.AnimState:PlayAnimation("idle",true)

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("underworld_hana_weapon_scythe")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)


    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    --- 收割动作
        inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_point_and_target_spell_caster",function(inst,replica_com)
            replica_com:SetText("underworld_hana_weapon_scythe",GetStringsTable()["action_str"])
            replica_com:SetSGAction("underworld_hana_scythe_harvest")
            replica_com:SetDistance(1.5)
            replica_com:SetPriority(999)
            replica_com:SetTestFn(function(inst,doer,target,pt,right_click)
                if right_click and doer ~= target then

                    return true
                end
                return false
            end)

        end)
        if TheWorld.ismastersim then
            inst:AddComponent("hana_com_point_and_target_spell_caster")
            inst.components.hana_com_point_and_target_spell_caster:SetSpellFn(function(inst,doer,target,pt)

                local function work_target(doer,target)
                    ------------------------------------------------------------------------------------
                    ---- workable 组件的操作优先
                        if target.components.workable and target.components.workable:CanBeWorked() then
                            if target.components.workable:GetWorkAction() == ACTIONS.CHOP then
                                target.components.workable:Destroy(doer)
                                return
                            end
                            if target.components.workable:GetWorkAction() == ACTIONS.MINE then
                                target.components.workable:Destroy(doer)
                                return
                            end
                        end
                    ------------------------------------------------------------------------------------
                    ---- 采集（草、浆果、种植植物）
                        if target.components.pickable and target.components.pickable:CanBePicked() then
                                if target.components.pickable.picksound ~= nil then
                                    doer.SoundEmitter:PlaySound(target.components.pickable.picksound)
                                end
                                local success, loot = target.components.pickable:Pick(TheWorld)
                                if loot ~= nil then
                                    for i, item in ipairs(loot) do
                                        Launch(item, doer, 1.5)
                                    end
                                end
                            return
                        end
                    ------------------------------------------------------------------------------------
                end
                local x,y,z = doer.Transform:GetWorldPosition()
                if target then
                    x,y,z = target.Transform:GetWorldPosition()
                end
                if pt then
                    x,y,z = pt.x, pt.y, pt.z
                end
                local musthavetags = nil
                local canthavetags = nil
                local musthaveoneoftags = {"CHOP_workable","pickable","MINE_workable"}
                local range = TUNING.VOIDCLOTH_SCYTHE_HARVEST_RADIUS
                local ents = TheSim:FindEntities(x, 0, z, range, musthavetags, canthavetags, musthaveoneoftags)
                for k, temp_inst in pairs(ents) do
                    -- work_target(doer,target)
                    pcall(work_target,doer,temp_inst)
                end
                inst.components.finiteuses:Use(4)
                return true
            end)
        end
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(34)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("voidcloth_scythe")
    inst.components.inventoryitem.imagename = "underworld_hana_weapon_scythe"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_weapon_scythe.xml"

    inst:AddComponent("equippable")

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable.walkspeedmult = 1

    MakeHauntableLaunch(inst)

    ------------------------------------------------------------------------------
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(100)
        inst.components.finiteuses:SetUses(100)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
    ------------------------------------------------------------------------------
        inst:AddComponent("tool")
        -- inst.components.tool:SetAction(ACTIONS.HAMMER) --- 锤子
        inst.components.tool:SetAction(ACTIONS.MINE)  -- 矿锄
        inst.components.tool:SetAction(ACTIONS.CHOP)  -- 斧头
    ------------------------------------------------------------------------------
        -- inst:ListenForEvent("equipped",function(_,_table)
        --     if _table and _table.owner and _table.owner.prefab == "underworld_hana" then
        --         inst:AddComponent("tool")
        --         -- inst.components.tool:SetAction(ACTIONS.HAMMER) --- 锤子
        --         inst.components.tool:SetAction(ACTIONS.MINE)  -- 矿锄
        --         inst.components.tool:SetAction(ACTIONS.CHOP)  -- 斧头
        --     end
        -- end)
        -- inst:ListenForEvent("unequipped",function()
        --     if inst.components.tool then
        --         inst:RemoveComponent("tool")
        --     end
        -- end)
    ------------------------------------------------------------------------------

    ------------------------------------------------------------------------------

    return inst
end

return Prefab("underworld_hana_weapon_scythe", fn, assets)
