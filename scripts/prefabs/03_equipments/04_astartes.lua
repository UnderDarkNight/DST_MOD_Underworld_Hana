------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    阿斯塔特

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function GetStringsTable(prefab_name)
        return TUNING["underworld_hana.fn"].GetStringsTable(prefab_name or "underworld_hana_weapon_astartes")
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 
    local CD_TIME = TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 3 or 20
    local WATER_SPELL_DAMAGE = 68
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local assets =
    {
        Asset("ANIM", "anim/underworld_hana_weapon_astartes.zip"),
        Asset("ANIM", "anim/underworld_hana_weapon_astartes_swap.zip"),
        Asset( "IMAGE", "images/inventoryimages/underworld_hana_weapon_astartes.tex" ),
        Asset( "ATLAS", "images/inventoryimages/underworld_hana_weapon_astartes.xml" ),


    }
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function onequip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "underworld_hana_weapon_astartes_swap", "swap_object")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end

    local function onunequip(inst, owner)
        owner.AnimState:ClearOverrideSymbol("swap_object")
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
    end
------------------------------------------------------------------------------------------------------------------
---  复制三叉戟的代码    
    local INITIAL_LAUNCH_HEIGHT = 0.1
    local SPEED = 8
    local function launch_away(inst, position)
        local ix, iy, iz = inst.Transform:GetWorldPosition()
        inst.Physics:Teleport(ix, iy + INITIAL_LAUNCH_HEIGHT, iz)

        local px, py, pz = position:Get()
        local angle = (180 - inst:GetAngleToPoint(px, py, pz)) * DEGREES
        local sina, cosa = math.sin(angle), math.cos(angle)
        inst.Physics:SetVel(SPEED * cosa, 4 + SPEED, SPEED * sina)
    end

    local function do_water_explosion_effect(inst, affected_entity, owner, position)
        if affected_entity.components.health then
            local ae_combat = affected_entity.components.combat
            if ae_combat then
                ae_combat:GetAttacked(owner, WATER_SPELL_DAMAGE, inst)
            else
                affected_entity.components.health:DoDelta(-WATER_SPELL_DAMAGE, nil, inst.prefab, nil, owner)
            end
        elseif affected_entity.components.oceanfishable ~= nil then
            if affected_entity.components.weighable ~= nil then
                affected_entity.components.weighable:SetPlayerAsOwner(owner)
            end

            local projectile = affected_entity.components.oceanfishable:MakeProjectile()

            local ae_cp = projectile.components.complexprojectile
            if ae_cp then
                ae_cp:SetHorizontalSpeed(16)
                ae_cp:SetGravity(-30)
                ae_cp:SetLaunchOffset(Vector3(0, 0.5, 0))
                ae_cp:SetTargetOffset(Vector3(0, 0.5, 0))

                local v_position = affected_entity:GetPosition()
                local launch_position = v_position + (v_position - position):Normalize() * SPEED
                ae_cp:Launch(launch_position, projectile, ae_cp.owningweapon)
            else
                launch_away(projectile, position)
            end
        elseif affected_entity.prefab == "bullkelp_plant" then
            local ae_x, ae_y, ae_z = affected_entity.Transform:GetWorldPosition()

            if affected_entity.components.pickable and affected_entity.components.pickable:CanBePicked() then
                local product = affected_entity.components.pickable.product
                local loot = SpawnPrefab(product)
                if loot ~= nil then
                    loot.Transform:SetPosition(ae_x, ae_y, ae_z)
                    if loot.components.inventoryitem ~= nil then
                        loot.components.inventoryitem:InheritWorldWetnessAtTarget(affected_entity)
                    end
                    if loot.components.stackable ~= nil
                            and affected_entity.components.pickable.numtoharvest > 1 then
                        loot.components.stackable:SetStackSize(affected_entity.components.pickable.numtoharvest)
                    end
                    launch_away(loot, position)
                end
            end

            local uprooted_kelp_plant = SpawnPrefab("bullkelp_root")
            if uprooted_kelp_plant ~= nil then
                uprooted_kelp_plant.Transform:SetPosition(ae_x, ae_y, ae_z)
                launch_away(uprooted_kelp_plant, position + Vector3(0.5*math.random(), 0, 0.5*math.random()))
            end

            affected_entity:Remove()
        elseif affected_entity.components.inventoryitem ~= nil then
            launch_away(affected_entity, position)
            affected_entity.components.inventoryitem:SetLanded(false, true)
        elseif affected_entity.waveactive then
            affected_entity:DoSplash()
        elseif affected_entity.components.workable ~= nil and affected_entity.components.workable:GetWorkAction() == ACTIONS.MINE then
            affected_entity.components.workable:WorkedBy(owner, TUNING.TRIDENT.SPELL.MINES)
        end
    end

    local PLANT_TAGS = {"tendable_farmplant"}
    local MUST_HAVE_SPELL_TAGS = nil
    local CANT_HAVE_SPELL_TAGS = {"INLIMBO", "outofreach", "DECOR"}
    local MUST_HAVE_ONE_OF_SPELL_TAGS = nil
    local FX_RADIUS = TUNING.TRIDENT.SPELL.RADIUS * 0.65
    local COST_PER_EXPLOSION = TUNING.TRIDENT.USES / TUNING.TRIDENT.SPELL.USE_COUNT
    local function create_water_explosion(inst, target, position)
        local owner = inst.components.inventoryitem:GetGrandOwner()
        if owner == nil then
            return
        end

        local px, py, pz = position:Get()

        -- Do gameplay effects.
        local affected_entities = TheSim:FindEntities(px, py, pz, TUNING.TRIDENT.SPELL.RADIUS, MUST_HAVE_SPELL_TAGS, CANT_HAVE_SPELL_TAGS, MUST_HAVE_ONE_OF_SPELL_TAGS)
        for _, v in ipairs(affected_entities) do
            if v:IsOnOcean(false) then
                inst:DoWaterExplosionEffect(v, owner, position)
            end
        end

        -- Spawn visual fx.
        local angle = GetRandomWithVariance(-45, 20)
        for _ = 1, 4 do
            angle = angle + 90
            local offset_x = FX_RADIUS * math.cos(angle * DEGREES)
            local offset_z = FX_RADIUS * math.sin(angle * DEGREES)
            local ox = px + offset_x
            local oz = pz - offset_z

            if TheWorld.Map:IsOceanTileAtPoint(ox, py, oz) and not TheWorld.Map:IsVisualGroundAtPoint(ox, py, oz) then
                local platform_at_point = TheWorld.Map:GetPlatformAtPoint(ox, oz)
                if platform_at_point ~= nil then
                    -- Spawn a boat leak slightly further in to help avoid being on the edge of the boat and sliding off.
                    local bx, by, bz = platform_at_point.Transform:GetWorldPosition()
                    if bx == ox and bz == oz then
                        platform_at_point:PushEvent("spawnnewboatleak", {pt = Vector3(ox, py, oz), leak_size = "med_leak", playsoundfx = true})
                    else
                        local p_to_ox, p_to_oz = VecUtil_Normalize(bx - ox, bz - oz)
                        local ox_mod, oz_mod = ox + (0.5 * p_to_ox), oz + (0.5 * p_to_oz)
                        platform_at_point:PushEvent("spawnnewboatleak", {pt = Vector3(ox_mod, py, oz_mod), leak_size = "med_leak", playsoundfx = true})
                    end

                    local boatphysics = platform_at_point.components.boatphysics
                    if boatphysics ~= nil then
                        boatphysics:ApplyForce(offset_x, -offset_z, 1)
                    end
                else
                    local fx = SpawnPrefab("crab_king_waterspout")
                    fx.Transform:SetPosition(ox, py, oz)
                end
            end
        end

        local x, y, z = owner.Transform:GetWorldPosition()
        for _, v in pairs(TheSim:FindEntities(x, y, z, TUNING.TRIDENT_FARM_PLANT_INTERACT_RANGE, PLANT_TAGS)) do
            if v.components.farmplanttendable ~= nil then
                v.components.farmplanttendable:TendTo(owner)
            end
        end


        -- inst.components.finiteuses:Use(COST_PER_EXPLOSION)
    end

------------------------------------------------------------------------------------------------------------------
--- spell casetr
    local function spell_cast_fn(inst,doer,target,pt)


        local function ocean_fn(x,y,z)
            create_water_explosion(inst, target, Vector3(x,y,z))
        end 
        local function buff_fn() ----- 单纯的buff 。 位面伤害、冰冻效果
            inst.components.planardamage:SetBaseDamage(17)
            inst.components.weapon:SetOnAttack(function(inst, attacker, target)
                if target.components.freezable ~= nil and target:IsValid() then
                    target.components.freezable:AddColdness(1)
                    target.components.freezable:SpawnShatterFX()
                end
            end)
            if inst.__buff_task ~= nil then
                inst.__buff_task:Cancel()
            end
            inst.__buff_task = inst:DoTaskInTime(10,function()
                inst.components.planardamage:SetBaseDamage(0)
                inst.components.weapon:SetOnAttack(nil)
            end)
        end


        local is_ocean_flag = false
        local x,y,z = 0,0,0
        if target then
            x,y,z = target.Transform:GetWorldPosition()
        end
        if pt then
            x,y,z = pt.x,pt.y,pt.z
        end

        if TheWorld.Map:IsOceanAtPoint(x, y, z) and  TheWorld.Map:GetPlatformAtPoint(x,z) == nil then
            is_ocean_flag = true
        end
        if is_ocean_flag then
            ocean_fn(x,y,z)
        else
            buff_fn()
        end
    end
------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("underworld_hana_weapon_astartes")
    inst.AnimState:SetBuild("underworld_hana_weapon_astartes")
    inst.AnimState:PlayAnimation("idle",true)

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("underworld_hana_weapon_astartes")

    MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85})


    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    --- 技能
        inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_point_and_target_spell_caster",function(inst,replica_com)
            replica_com:SetText("underworld_hana_weapon_astartes",GetStringsTable()["spell_str_a"])
            replica_com:SetSGAction("quickcastspell")
            replica_com:SetDistance(20)
            replica_com:SetPriority(999)
            replica_com:SetAllowCanCastOnImpassable(true)
            replica_com:SetTestFn(function(inst,doer,target,pt,right_click)     --- 以30FPS 执行，注意CPU性能消耗
                if not right_click then
                    return false
                end
                if not inst:HasTag("gnarwail_horn") then
                    return false
                end
                -- pcall(function()
                --     print(inst.replica.inventoryitem.classified.recharge:value())
                -- end)
                if right_click and doer ~= target then
                    if inst.replica.inventoryitem.classified and inst.replica.inventoryitem.classified.recharge:value() == 180 then
                        local is_ocean_flag = false
                        local x,y,z = 0,0,0
                        if target then
                            x,y,z = target.Transform:GetWorldPosition()
                        end
                        if pt then
                            x,y,z = pt.x,pt.y,pt.z
                        end

                        if TheWorld.Map:IsOceanAtPoint(x, y, z) and  TheWorld.Map:GetPlatformAtPoint(x,z) == nil then
                            is_ocean_flag = true
                        end
                        if is_ocean_flag then
                            replica_com:SetSGAction("quickcastspell")   --- 切换动作sg
                            replica_com:SetText("underworld_hana_weapon_astartes",GetStringsTable()["spell_str_a"]) --- 切换鼠标显示文本
                        else
                            replica_com:SetSGAction("castspell")    --- 切换动作sg
                            replica_com:SetText("underworld_hana_weapon_astartes",GetStringsTable()["spell_str_b"]) --- 切换鼠标显示文本
                        end


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
                ----
                    spell_cast_fn(inst,doer,target,pt)

                ------------------------------------------------------------------------------------
                --- CD
                    inst.components.rechargeable:Discharge(CD_TIME)
                ------------------------------------------------------------------------------------
                --- 耐久
                    inst.components.finiteuses:Use(4)
                ------------------------------------------------------------------------------------
                return true
            end)
        end
    -------------------------------------------------------------------------------------
    --- 物品接受 gnarwail_horn
        inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_acceptable",function(inst,replica_com)
            replica_com:SetSGAction("dolongaction")
            replica_com:SetTestFn(function(inst,item,doer)
                if item.prefab ~= "gnarwail_horn" then
                    return false
                end
                if inst:HasTag("gnarwail_horn") then
                    return false
                else
                    return true
                end
                return false
            end)
            replica_com:SetText("underworld_hana_weapon_astartes",GetStringsTable()["unlock_str"])
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("hana_com_acceptable")
            inst.components.hana_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
                if item.components.stackable then
                    item.components.stackable:Get():Remove()
                else
                    item:Remove()
                end
                inst:AddTag("gnarwail_horn")
                inst.components.hana_com_data:Set("gnarwail_horn",true)
                return true
            end)
            ---- 记录已经添加过 物品
            inst:AddComponent("hana_com_data")
            inst.components.hana_com_data:AddOnLoadFn(function(com)
                if com:Get("gnarwail_horn") then
                    inst:AddTag("gnarwail_horn")
                end
            end)
        end
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    ------------------------------------------------------------------------------
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(34)

    ------------------------------------------------------------------------------
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("voidcloth_scythe")
        inst.components.inventoryitem.imagename = "underworld_hana_weapon_astartes"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_weapon_astartes.xml"

        inst:AddComponent("equippable")

        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)

        MakeHauntableLaunch(inst)

    ------------------------------------------------------------------------------
    --- 位面伤害
        inst:AddComponent("planardamage")
	    inst.components.planardamage:SetBaseDamage(0)
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
        inst.DoWaterExplosionEffect = do_water_explosion_effect
    ------------------------------------------------------------------------------

    return inst
end

return Prefab("underworld_hana_weapon_astartes", fn, assets)
