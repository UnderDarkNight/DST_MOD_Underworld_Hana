------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    军团长魔镜盾

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/underworld_hana_weapon_legionnaire_magic_mirror_shield.zip"),
}
------------------------------------------------------------------------------------------------------------------------
---
    local function GetStringsTable(prefab_name)
        return TUNING["underworld_hana.fn"].GetStringsTable(prefab_name or "underworld_hana_weapon_legionnaire_magic_mirror_shield")
    end
------------------------------------------------------------------------------------------------------------------------
---
    local SPELL_CD_TIME = TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 2 or 10         --- 盾牌技能CD
    local SHELL_HOLDING_TIME = TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 5 or 2     --- 持盾格挡时间
------------------------------------------------------------------------------------------------------------------------
--- 指示器
    local function ReticuleTargetFn()
        return Vector3(ThePlayer.entity:LocalToWorldSpace(6.5, 0, 0))
    end

    local function ReticuleMouseTargetFn(inst, mousepos)
        if mousepos ~= nil then
            local x, y, z = inst.Transform:GetWorldPosition()
            local dx = mousepos.x - x
            local dz = mousepos.z - z
            local l = dx * dx + dz * dz
            if l <= 0 then
                return inst.components.reticule.targetpos
            end
            l = 6.5 / math.sqrt(l)
            return Vector3(x + dx * l, 0, z + dz * l)
        end
    end

    local function ReticuleUpdatePositionFn(inst, pos, reticule, ease, smoothing, dt)
        local x, y, z = inst.Transform:GetWorldPosition()
        reticule.Transform:SetPosition(x, 0, z)
        local rot = -math.atan2(pos.z - z, pos.x - x) / DEGREES
        if ease and dt ~= nil then
            local rot0 = reticule.Transform:GetRotation()
            local drot = rot - rot0
            rot = Lerp((drot > 180 and rot0 + 360) or (drot < -180 and rot0 - 360) or rot0, rot, dt * smoothing)
        end
        reticule.Transform:SetRotation(rot)
    end

------------------------------------------------------------------------------------------------------------------------
---- 穿戴
    local function OnEquip(inst, owner)
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Show("lantern_overlay")
        owner.AnimState:Hide("ARM_normal")
        owner.AnimState:HideSymbol("swap_object")


        owner.AnimState:OverrideSymbol("lantern_overlay", "underworld_hana_weapon_legionnaire_magic_mirror_shield", "swap_shield")
        owner.AnimState:OverrideSymbol("swap_shield",     "underworld_hana_weapon_legionnaire_magic_mirror_shield", "swap_shield")
        

        if inst.components.rechargeable:GetTimeToCharge() < SPELL_CD_TIME then
            inst.components.rechargeable:Discharge(SPELL_CD_TIME)
        end
    end

    local function OnUnequip(inst, owner)
        owner.AnimState:ClearOverrideSymbol("lantern_overlay")
        owner.AnimState:ClearOverrideSymbol("swap_shield")

        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Hide("lantern_overlay")
        owner.AnimState:Show("ARM_normal")
        owner.AnimState:ShowSymbol("swap_object")

    end

------------------------------------------------------------------------------------------------------------------------
---- 盾牌格挡技能
    local function SpellFn(inst, doer, pos)
        -- print(" +++ SpellFn +++ ")
        local temp_holding_time = SHELL_HOLDING_TIME
        if inst:HasTag("townportaltalisman") then
            temp_holding_time = SHELL_HOLDING_TIME + 3
        end
        if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
            print("SHELL HOLDING TIME",temp_holding_time)
        end

        inst.components.parryweapon:EnterParryState(doer, doer:GetAngleToPoint(pos), temp_holding_time)

        local spell_cd_time = SPELL_CD_TIME
        if inst._parry_succeed then --- 如果上一次成功格挡
            spell_cd_time = spell_cd_time * (TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 0.1 or 0.9)
            inst._parry_succeed = nil
        end
        inst.components.rechargeable:Discharge(spell_cd_time)

    end

    local function OnParry(inst, doer, attacker, damage)  ----- 成功格挡
        ----- 镜头震动
            doer:ShakeCamera(CAMERASHAKE.SIDE, 0.1, 0.03, 0.3)
        ----- 成功格挡
            inst._parry_succeed = true
        ----- 启动伤害倍增计时器
            if inst._damage_multiplier_timer then
                inst._damage_multiplier_timer:Cancel()
            end
            inst._damage_multiplier_timer = inst:DoTaskInTime(5,function()
                inst._damage_multiplier_timer = nil
            end)
    end

    local function DamageFn(inst) ------ 盾牌伤害        
        local damage = 51
        if inst._damage_multiplier_timer then
            damage = damage * 1.1
        end
        return damage
    end

    local function OnAttackFn(inst, attacker, target)  --- 主动拿盾抡目标的时候
        inst.components.armor:TakeDamage(1)    ---- 造成伤害的时候 减少盾牌耐久
    end

    local function OnDischarged(inst)
        inst.components.aoetargeting:SetEnabled(false)
    end

    local function OnCharged(inst)
        inst.components.aoetargeting:SetEnabled(true)
    end

------------------------------------------------------------------------------------------------------------------------
---- 物品接受
    local function acceptable_com_setup(inst)

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
                replica_com:SetText("underworld_hana_weapon_deep_love",GetStringsTable()["accept_str"])
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
                inst.components.hana_com_data:AddOnLoadFn(function(com)
                    if com:Get("townportaltalisman") then
                        inst:AddTag("townportaltalisman")
                    end
                end)
            end

    end
------------------------------------------------------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("underworld_hana_weapon_legionnaire_magic_mirror_shield")
    inst.AnimState:SetBuild("underworld_hana_weapon_legionnaire_magic_mirror_shield")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("toolpunch")
    inst:AddTag("battleshield")
    inst:AddTag("shield")

    --parryweapon (from parryweapon component) added to pristine state for optimization
    inst:AddTag("parryweapon")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")

    --rechargeable (from rechargeable component) added to pristine state for optimization
    inst:AddTag("rechargeable")

    MakeInventoryFloatable(inst, nil, 0.2, {1.1, 0.6, 1.1})
    ---------------------------------------------------------------------------------------------------------------
    --- 技能地面指示器组件
        inst:AddComponent("aoetargeting")
        inst.components.aoetargeting:SetAlwaysValid(true)
        inst.components.aoetargeting:SetAllowRiding(false)
        inst.components.aoetargeting.reticule.reticuleprefab = "reticulearc"
        inst.components.aoetargeting.reticule.pingprefab = "reticulearcping"
        inst.components.aoetargeting.reticule.targetfn = ReticuleTargetFn
        inst.components.aoetargeting.reticule.mousetargetfn = ReticuleMouseTargetFn
        inst.components.aoetargeting.reticule.updatepositionfn = ReticuleUpdatePositionFn
        inst.components.aoetargeting.reticule.validcolour = { 1, .75, 0, 1 }
        inst.components.aoetargeting.reticule.invalidcolour = { .5, 0, 0, 1 }
        inst.components.aoetargeting.reticule.ease = true
        inst.components.aoetargeting.reticule.mouseenabled = true
    ---------------------------------------------------------------------------------------------------------------
    inst.entity:SetPristine()
    ---------------------------------------------------------------------------------------------------------------
    ---
        if TheWorld.ismastersim then
            inst:AddComponent("hana_com_data")
        end
    ---------------------------------------------------------------------------------------------------------------
    --- acceptable_com_setup
        acceptable_com_setup(inst)
    ---------------------------------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    ---------------------------------------------------------------------------------------------------------------
    ---- 
        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("voidcloth_scythe")
        inst.components.inventoryitem.imagename = "underworld_hana_weapon_legionnaire_magic_mirror_shield"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_weapon_legionnaire_magic_mirror_shield.xml"
    ---------------------------------------------------------------------------------------------------------------
    ---- 
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(DamageFn)
        inst.components.weapon:SetOnAttack(OnAttackFn)

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(   300   ,    0.3    )
                        ---                   耐久度     减伤系数
    ---------------------------------------------------------------------------------------------------------------
    ---- 
        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(OnEquip)
        inst.components.equippable:SetOnUnequip(OnUnequip)
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
    ---------------------------------------------------------------------------------------------------------------
    ---- aoe 技能组件
        inst:AddComponent("aoespell")
        inst.components.aoespell:SetSpellFn(SpellFn)
    ---------------------------------------------------------------------------------------------------------------
    ---- 格挡武器组件
        inst:AddComponent("parryweapon")
        inst.components.parryweapon:SetParryArc(TUNING.WATHGRITHR_SHIELD_PARRY_ARC)     --- 格挡角度？
        --inst.components.parryweapon:SetOnPreParryFn(OnPreParry)
        inst.components.parryweapon:SetOnParryFn(OnParry)
    ---------------------------------------------------------------------------------------------------------------
    ---- 冷却时间组件
        inst:AddComponent("rechargeable")
        inst.components.rechargeable:SetOnDischargedFn(OnDischarged)
        inst.components.rechargeable:SetOnChargedFn(OnCharged)
    ---------------------------------------------------------------------------------------------------------------
        MakeHauntableLaunch(inst)
    ---------------------------------------------------------------------------------------------------------------
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
    ---------------------------------------------------------------------------------------------------------------
    return inst
end

return Prefab("underworld_hana_weapon_legionnaire_magic_mirror_shield", fn, assets)