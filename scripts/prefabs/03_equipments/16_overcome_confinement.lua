------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    冥界之镰

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function GetStringsTable(prefab_name)
        return TUNING["underworld_hana.fn"].GetStringsTable(prefab_name or "underworld_hana_weapon_scythe_overcome_confinement")
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local CD_TIME = TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 5 or 20
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local assets =
    {
        Asset("ANIM", "anim/underworld_hana_weapon_scythe_overcome_confinement.zip"),
        Asset("ANIM", "anim/underworld_hana_weapon_scythe_overcome_confinement_swap.zip"),
    }
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function onequip(inst, owner)

        -- owner.AnimState:OverrideSymbol("swap_object", "scythe_voidcloth", "swap_scythe")
        owner.AnimState:OverrideSymbol("swap_object", "underworld_hana_weapon_scythe_overcome_confinement_swap", "swap_object")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")



    end

    local function onunequip(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")


    end
------------------------------------------------------------------------------------------------------------------
--- 攻击动作切换event安装
    local function attack_action_change_event_setup(inst)
        if not TheNet:IsDedicated() then
            inst:ListenForEvent("attack_action_scythe_client",function()
                inst.acttack_action_scythe = not inst.acttack_action_scythe
                -- print("info attack_action_scythe_client")
            end)
        end

        if TheWorld.ismastersim then
            inst:ListenForEvent("set_attack_action_scythe",function()
                for k, temp_player in pairs(AllPlayers) do
                    temp_player.components.hana_com_rpc_event:PushEvent("attack_action_scythe_client",nil,inst)
                end
            end)
        end
    end
------------------------------------------------------------------------------------------------------------------
---- spell action
    local function spell_action_setup(inst)
        inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_point_and_target_spell_caster",function(inst,replica_com)
            replica_com:SetText("underworld_hana_weapon_scythe_overcome_confinement",GetStringsTable()["spell_str"])
            replica_com:SetSGAction("underworld_hana_scythe_harvest")
            replica_com:SetDistance(30)
            replica_com:SetPriority(999)
            replica_com:SetTestFn(function(inst,doer,target,pt,right_click)
                if right_click and doer ~= target then
                    if inst.replica.inventoryitem.classified and inst.replica.inventoryitem.classified.recharge:value() ~= 180 then
                        return false
                    end
                    if inst.SPELL_COIN ~= nil and inst.SPELL_COIN > 0 then
                        return true
                    else
                        return false
                    end
                end
                return false
            end)
            replica_com:SetPreActionFn(function(inst,doer,target,pt)
                -- if TheWorld.ismastersim then                    
                --     doer:DoTaskInTime(0.3,function()
                        
                --     end)
                -- end
            end)

        end)
        if TheWorld.ismastersim then
            inst:AddComponent("hana_com_point_and_target_spell_caster")
            inst.components.hana_com_point_and_target_spell_caster:SetSpellFn(function(inst,doer,target,pt)
                -- inst:PushEvent("set_attack_action_scythe")
                -- inst.components.finiteuses:Use(4)

                -- if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
                --     inst:PushEvent("SPECIAL_AOE_SPELL_CAST",doer)
                --     return true
                -- end

                if inst.SPELL_COIN == nil then
                    return true
                end
                if inst.SPELL_COIN <= 0 then
                    return true
                end
                inst.SPELL_COIN = inst.SPELL_COIN - 1
                ------------------------------------------------------------------------------------------
                ---- 执行技能动作
                    -- print("执行技能动作")
                    inst:PushEvent("SPECIAL_AOE_SPELL_CAST",doer)
                ------------------------------------------------------------------------------------------
                --- CD
                    local mult = doer.components.hana_com_spell_cd_modifier:GetMult()
                    inst.components.rechargeable:Discharge(CD_TIME*mult)
                ------------------------------------------------------------------------------------------
                ---
                    SpawnPrefab("underworld_hana_fx_scythe_attack"):PushEvent("Set",{
                        target = doer,
                        speed = 1.5,
                        scale = 1,
                        color = Vector3(255,0,0),
                    })
                    for i = 1, 4, 1 do
                        SpawnPrefab("underworld_hana_fx_scythe_attack"):PushEvent("Set",{
                            target = doer,
                            speed = 1.5,
                            scale = 3*i,
                            color = Vector3(255,0,0),
                        })
                    end
                ------------------------------------------------------------------------------------------
                doer.components.hana_com_rpc_event:PushEvent("SPELL_COIN_REFRESH",inst.SPELL_COIN,inst)
                doer.components.hana_com_rpc_event:PushEvent("overcome_confinement_ui.refresh",inst.SPELL_COIN)
                return true
            end)
        end
    end
------------------------------------------------------------------------------------------------------------------
---- 重伤值 event 安装
    local function seriously_hurt_event_setup(inst)
        --------------------------------------------------------------------------------------
        --- 在客户端上 计数器
            if not TheNet:IsDedicated() then
                inst:ListenForEvent("SPELL_COIN_REFRESH",function(inst,spell_coin)
                    inst.SPELL_COIN = spell_coin
                end)
            end
        --------------------------------------------------------------------------------------
        if not TheWorld.ismastersim then
            return
        end
        --------------------------------------------------------------------------------------
        ---- 给目标上重伤值
            local seriously_hurt_delta_num = 10
            inst:ListenForEvent("seriously_hurt_target",function(inst,_table)
                if inst.owner == nil then
                    return
                end
                local target = _table.target
                local delta_num = _table.delta_num or seriously_hurt_delta_num
                if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
                    delta_num = delta_num*3
                end
                local player = inst.owner
                player.__overcome_confinement_seriously_hurt = player.__overcome_confinement_seriously_hurt or {}
                player.__overcome_confinement_seriously_hurt[target] = player.__overcome_confinement_seriously_hurt[target] or 0
                player.__overcome_confinement_seriously_hurt[target] = math.clamp(player.__overcome_confinement_seriously_hurt[target] + delta_num,0,100)
                inst:PushEvent("seriously_hurt_num_count")
            end)
        --------------------------------------------------------------------------------------
        ---- 根据重伤值 刷技能豆
            inst:ListenForEvent("seriously_hurt_num_count",function(inst)
                local player = inst.owner
                if player.__overcome_confinement_seriously_hurt == nil then
                    return
                end
                for monster, num in pairs(player.__overcome_confinement_seriously_hurt) do
                    if monster and monster:IsValid() and num >= 100 then
                        player.__overcome_confinement_seriously_hurt[monster] = 0
                        inst:PushEvent("ADD_SPELL_COIN")
                        if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
                            print("重伤值满",monster)
                        end
                    end
                end
            end)
        --------------------------------------------------------------------------------------
        ----- 
            inst:ListenForEvent("ADD_SPELL_COIN",function(inst)
                local max_coin_num = 3                
                inst.SPELL_COIN = inst.SPELL_COIN or 0
                inst.SPELL_COIN = math.clamp(inst.SPELL_COIN + 1,0,max_coin_num)
                if inst.owner then
                    inst.owner.components.hana_com_rpc_event:PushEvent("SPELL_COIN_REFRESH",inst.SPELL_COIN,inst)
                    inst.owner.components.hana_com_rpc_event:PushEvent("overcome_confinement_ui.refresh",inst.SPELL_COIN)
                end
                print("当前技能豆",inst.SPELL_COIN)

            end)
        --------------------------------------------------------------------------------------


    end
------------------------------------------------------------------------------------------------------------------
----- onhit other event setup   切换AOE 攻击
    local function on_hit_other_event_setup(inst)
        if not TheWorld.ismastersim then
            return
        end
        --------------------------------------------------------------------------------------------------
        --- 切换攻击动作
            inst:ListenForEvent("weapon_onhitother",function(inst,target)
                if inst:HasTag("aoe_attacking") then
                    return
                end
                if inst.attack_num == nil then
                    inst.attack_num = 1
                else
                    inst.attack_num = inst.attack_num + 1
                end
                if inst.attack_num == 3 then
                    inst:PushEvent("set_attack_action_scythe")
                end
                if inst.attack_num > 3 then
                    inst:PushEvent("weapon_aoe_target",target)
                end
                if inst.attack_num == 6 then
                    inst:PushEvent("set_attack_action_scythe")
                    inst.attack_num = 0
                end
            end)
        --------------------------------------------------------------------------------------------------
        --- AOE
            inst:ListenForEvent("weapon_aoe_target",function(inst,target)
                if inst:HasTag("aoe_attacking") then  
                    return
                end
                if inst.owner == nil then
                    return
                end
                local player = inst.owner
                local weapon = inst
                local x,y,z = player.Transform:GetWorldPosition()

                local musthavetags = { "_combat" }
                local canthavetags = {"INLIMBO", "notarget", "noattack", "flight", "invisible", "wall", "player", "companion","underworld_hana_tag.ignore_hana" }
                local musthaveoneoftags = nil
                local ents = TheSim:FindEntities(x,y,z,10,musthavetags,canthavetags,musthaveoneoftags)
                inst:AddTag("aoe_attacking")
                for k, temp_monster in pairs(ents) do
                    if temp_monster and temp_monster:IsValid() and temp_monster.components.combat and temp_monster.components.combat:CanBeAttacked(player) then
                        local damage = player.components.combat:CalcDamage(temp_monster,weapon)
                        -- print("+ aoe target",target,damage)
                        -- target.components.combat:GetAttacked(player,damage,weapon)
                        player.components.health:DoDelta(damage*0.1,true)
                        if target ~= temp_monster then
                            player.components.combat:DoAttack(temp_monster,inst)                            
                        end
                        inst:PushEvent("seriously_hurt_target",{
                            target = temp_monster,
                            num = 10,
                        }) --- 上重伤计数
                    end
                end
                inst:RemoveTag("aoe_attacking")
            end)
        --------------------------------------------------------------------------------------------------
        ---- 特效
            inst:ListenForEvent("weapon_aoe_target",function(inst)
                if inst.owner then
                    SpawnPrefab("underworld_hana_fx_scythe_attack"):PushEvent("Set",{
                        target = inst.owner,
                        speed = 1.5,
                        scale = 3,
                        -- color = Vector3(255,0,0),
                    })
                end
            end)
        --------------------------------------------------------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------
----- 技能AOE 全屏
    local function aoe_spell_event_setup(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:ListenForEvent("SPECIAL_AOE_SPELL_CAST",function(inst,player)
            inst:AddTag("aoe_attacking")
            inst:AddTag("aoe_spell_attacking")
            local x,y,z = player.Transform:GetWorldPosition()
            local musthavetags = { "_combat" }
            local canthavetags = {"INLIMBO", "notarget", "noattack", "flight", "invisible", "wall", "player", "companion","underworld_hana_tag.ignore_hana" }
            local musthaveoneoftags = nil
            local ents = TheSim:FindEntities(x,y,z, 20, musthavetags, canthavetags, musthaveoneoftags)
            for k, temp_monster in pairs(ents) do
                if temp_monster and temp_monster:IsValid() and temp_monster.components.combat and temp_monster.components.combat:CanBeAttacked(player) then

                    -- player.components.combat:DoAttack(temp_monster,inst)
                    local mult = player.components.combat.externaldamagemultipliers:Get()
                    local damage = player.components.combat:CalcDamage(temp_monster,inst) * mult
                    temp_monster.components.combat:GetAttacked(player,damage)
                    if temp_monster.components.health then
                        for i = 1, 5, 1 do
                            temp_monster:DoTaskInTime(i,function()
                                temp_monster.components.health:DoDelta(-damage)
                            end)
                        end
                    end
                    SpawnPrefab("underworld_hana_spell_shadowy_cage"):PushEvent("Set",{
                        target = temp_monster,
                        lock_time = 5,
                    })


                end
            end
            inst:RemoveTag("aoe_attacking")
            inst:RemoveTag("aoe_spell_attacking")

        end)
    end
------------------------------------------------------------------------------------------------------------------
----- equip ui event
    local function equip_ui_event_setup(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:ListenForEvent("equipped_by_player",function(inst,player)
            inst:DoTaskInTime(1,function()
                player.components.hana_com_rpc_event:PushEvent("overcome_confinement_ui.refresh",inst.SPELL_COIN or 0)
            end)
        end)
        inst:ListenForEvent("unequipped_by_player",function(inst,player)
            player.components.hana_com_rpc_event:PushEvent("overcome_confinement_ui.Hide")
        end)
    end
------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("underworld_hana_weapon_scythe_overcome_confinement")
    inst.AnimState:SetBuild("underworld_hana_weapon_scythe_overcome_confinement")
    inst.AnimState:PlayAnimation("idle",true)

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("underworld_hana_weapon_scythe_overcome_confinement")

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)


    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    --- 收割动作
        spell_action_setup(inst)
    -------------------------------------------------------------------------------------
    --- 安装 aoe event
        on_hit_other_event_setup(inst)
    -------------------------------------------------------------------------------------
    ---
        attack_action_change_event_setup(inst)
    -------------------------------------------------------------------------------------
    --- 重伤相关计数
        seriously_hurt_event_setup(inst)
    -------------------------------------------------------------------------------------
    ---- AOE技能
        aoe_spell_event_setup(inst)
    -------------------------------------------------------------------------------------
    ---- equip ui event setup
        equip_ui_event_setup(inst)
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    ------------------------------------------------------------------------------
    --- 伤害 
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(30)
        inst.components.weapon:SetOnAttack(function(inst,attacker,target)
            inst:PushEvent("weapon_onhitother",target)
        end)
        local old_GetDamage_fn = inst.components.weapon.GetDamage
        inst.components.weapon.GetDamage = function(self,attacker,target)
            local old_damage = old_GetDamage_fn(self,attacker,target)
            if self.inst:HasTag("aoe_spell_attacking") then
                return 4.7*old_damage
            end
            if self.inst:HasTag("aoe_attacking") then
                return old_damage
            elseif math.random(1000) <= 100 then
                if target then
                    self.inst:PushEvent("seriously_hurt_target",{
                        target = target,
                        num = 20,
                    })
                end
                return old_damage*2
            end
            return old_damage
        end
    ------------------------------------------------------------------------------
    --- 位面伤害
        inst:AddComponent("planardamage")
        inst.components.planardamage:SetBaseDamage(24)
    ------------------------------------------------------------------------------
    --- 检查
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("voidcloth_scythe")
        inst.components.inventoryitem.imagename = "underworld_hana_weapon_scythe_overcome_confinement"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_weapon_scythe_overcome_confinement.xml"
    ------------------------------------------------------------------------------
        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.walkspeedmult = 1
        inst.components.equippable.restrictedtag = "underworld_hana"

        inst:ListenForEvent("equipped",function(inst,_table)
            if _table and _table.owner and _table.owner:HasTag("player") then
                inst:PushEvent("equipped_by_player",_table.owner)
                inst.owner = _table.owner
            end
        end)
        inst:ListenForEvent("unequipped",function(inst,_table)
            if _table and _table.owner and _table.owner:HasTag("player") then
                inst:PushEvent("unequipped_by_player",_table.owner)
            end
            inst.owner = nil
        end)
    ------------------------------------------------------------------------------
        MakeHauntableLaunch(inst)

    ------------------------------------------------------------------------------
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(600)
        inst.components.finiteuses:SetUses(600)
        inst.components.finiteuses:SetOnFinished(function()
            inst:Remove()
        end)
    ------------------------------------------------------------------------------

    ------------------------------------------------------------------------------
    --- rechargeable 冷却系统
        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetMaxCharge(CD_TIME)
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

    return inst
end

return Prefab("underworld_hana_weapon_scythe_overcome_confinement", fn, assets)
