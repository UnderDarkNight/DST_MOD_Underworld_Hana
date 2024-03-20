------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    无邪

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
local function GetStringsTable(prefab_name)
    return TUNING["underworld_hana.fn"].GetStringsTable(prefab_name or "underworld_hana_weapon_irradiance")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
local CD_TIME = TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 1 or 10
local BASE_DAMAGE = 34
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/underworld_hana_weapon_irradiance.zip"),
    Asset("ANIM", "anim/underworld_hana_weapon_irradiance_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/underworld_hana_weapon_irradiance.tex" ),
    Asset( "ATLAS", "images/inventoryimages/underworld_hana_weapon_irradiance.xml" ),


}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "underworld_hana_weapon_irradiance_swap", "swap_object")
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
---- 
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("underworld_hana_weapon_irradiance")
    inst.AnimState:SetBuild("underworld_hana_weapon_irradiance")
    inst.AnimState:PlayAnimation("idle",true)

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("underworld_hana_weapon_irradiance")
    inst:AddTag("umbrella")

    MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85})


    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    --- 技能
        inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_point_and_target_spell_caster",function(inst,replica_com)
            replica_com:SetText("underworld_hana_weapon_irradiance",GetStringsTable()["spell_str"])
            replica_com:SetSGAction("underworld_hana_sg_equip")    -- 施法的SG
            replica_com:SetDistance(20)
            replica_com:SetPriority(999)
            replica_com:SetAllowCanCastOnImpassable(true)
            replica_com:SetTestFn(function(inst,doer,target,pt,right_click)     --- 以30FPS 执行，注意CPU性能消耗
                if right_click and inst.replica.equippable:IsEquipped() then
                    return true
                end
                return false
            end)

        end)
        if TheWorld.ismastersim then
            inst:AddComponent("hana_com_point_and_target_spell_caster")
            inst.components.hana_com_point_and_target_spell_caster:SetSpellFn(function(inst,doer,target,pt)
                ------------------------------------------------------------------------------------
                --- 
                    -- print("cast")
                    local finiteuses_percent = inst.components.finiteuses:GetPercent()
                    inst:Remove()
                    local ret_weapon = SpawnPrefab("underworld_hana_weapon_innocent")
                    ret_weapon.components.hana_com_data:Set("finiteuses_percent",finiteuses_percent)
                    doer.components.inventory:Equip(ret_weapon)
                ------------------------------------------------------------------------------------
                return true
            end)
        end
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    ------------------------------------------------------------------------------
    --- 耐久度消耗
        inst:ListenForEvent("equipped",function()
            inst.___finiteuses_task = inst:DoPeriodicTask(1,function()
                inst.components.finiteuses:Use()
            end)
        end)
        inst:ListenForEvent("unequipped",function()
            if inst.___finiteuses_task then
                inst.___finiteuses_task:Cancel()
                inst.___finiteuses_task = nil
            end
        end)
    ------------------------------------------------------------------------------
    --- 理智光环 减半 mult
        inst:ListenForEvent("equipped",function(inst,_table)
            if _table and _table.owner then
                if _table.owner.components.sanity then
                    _table.owner.components.sanity.neg_aura_modifiers:SetModifier(inst, 0.5)
                end
            end
        end)
        inst:ListenForEvent("unequipped",function(inst,_table)
            if _table and _table.owner then
                if _table.owner.components.sanity then
                    _table.owner.components.sanity.neg_aura_modifiers:RemoveModifier(inst)
                end
            end
        end)
        
    ------------------------------------------------------------------------------
    --- 耐久度
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(960)
        inst.components.finiteuses:SetUses(960)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
    ------------------------------------------------------------------------------
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(24)
    ------------------------------------------------------------------------------
    --- 位面伤害
        inst:AddComponent("planardamage")
        inst.components.planardamage:SetBaseDamage(30)
    ------------------------------------------------------------------------------
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("voidcloth_scythe")
        inst.components.inventoryitem.imagename = "underworld_hana_weapon_irradiance"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_weapon_irradiance.xml"

        inst:AddComponent("equippable")

        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)

        MakeHauntableLaunch(inst)

    ------------------------------------------------------------------------------
    --- 暗影阵营伤害 减少30%
        inst:AddComponent("damagetyperesist")
        inst.components.damagetyperesist:AddResist("shadow_aligned", inst, 0.7)
    ------------------------------------------------------------------------------
    --- 防水
        inst:AddTag("waterproofer")
        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_HUGE)
    ------------------------------------------------------------------------------
    -- --- 保暖？
    --     inst:AddComponent("insulator")
    --     inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)
    ------------------------------------------------------------------------------
    --- 防雷
        inst:AddTag("hana_thunder_blocker")
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

return Prefab("underworld_hana_weapon_irradiance", fn, assets)
