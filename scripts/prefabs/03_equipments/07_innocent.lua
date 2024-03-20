------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    无邪

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
local function GetStringsTable(prefab_name)
    return TUNING["underworld_hana.fn"].GetStringsTable(prefab_name or "underworld_hana_weapon_innocent")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
local CD_TIME = TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 1 or 10
local BASE_DAMAGE = 34
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/underworld_hana_weapon_innocent.zip"),
    Asset("ANIM", "anim/underworld_hana_weapon_innocent_swap.zip"),
    Asset( "IMAGE", "images/inventoryimages/underworld_hana_weapon_innocent.tex" ),
    Asset( "ATLAS", "images/inventoryimages/underworld_hana_weapon_innocent.xml" ),


}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "underworld_hana_weapon_innocent_swap", "swap_object")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    
    inst:PushEvent("add_quick_pick_tag",owner)
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    inst:PushEvent("remove_quick_pick_tag",owner)
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

    inst.AnimState:SetBank("underworld_hana_weapon_innocent")
    inst.AnimState:SetBuild("underworld_hana_weapon_innocent")
    inst.AnimState:PlayAnimation("idle",true)

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")
    inst:AddTag("underworld_hana_weapon_innocent")

    MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85})


    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    --- 技能
        inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_point_and_target_spell_caster",function(inst,replica_com)
            replica_com:SetText("underworld_hana_weapon_innocent",GetStringsTable()["spell_str"])
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
                    local finiteuses_percent = inst.components.hana_com_data:Get("finiteuses_percent") or 1
                    inst:PushEvent("remove_quick_pick_tag",doer)
                    inst:Remove()
                    local ret_weapon = SpawnPrefab("underworld_hana_weapon_irradiance")
                    ret_weapon.components.finiteuses:SetPercent(finiteuses_percent)
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
    ---- 数据库
        inst:AddComponent("hana_com_data")
    ------------------------------------------------------------------------------
    ---- 快速采集
        inst:ListenForEvent("add_quick_pick_tag",function(inst,player)
            if not player:HasTag("player") then
                return
            end
            if player:HasTag("fastpicker") then
                inst:RemoveTag("need_2_remove_tag")
            else
                inst:AddTag("need_2_remove_tag")
                player:AddTag("fastpicker")
            end
        end)
        inst:ListenForEvent("remove_quick_pick_tag",function(inst,player)
            if not player:HasTag("player") then
                return
            end
            if inst:HasTag("need_2_remove_tag") then
                player:RemoveTag("fastpicker")
            end
            inst:RemoveTag("need_2_remove_tag")
        end)
    ------------------------------------------------------------------------------
    ------------------------------------------------------------------------------
        inst:AddComponent("weapon")
        inst.components.weapon:SetDamage(0)
        inst.components.weapon.GetDamage = function(self,attacker, target)
            if attacker and attacker.components.combat then
                return attacker.components.combat:CalcDamage(target) or 0
            end
            return 0
        end
    ------------------------------------------------------------------------------
    --- 位面伤害
        inst:AddComponent("planardamage")
        inst.components.planardamage:SetBaseDamage(0)
    ------------------------------------------------------------------------------
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("voidcloth_scythe")
        inst.components.inventoryitem.imagename = "underworld_hana_weapon_innocent"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_weapon_innocent.xml"

        inst:AddComponent("equippable")

        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.walkspeedmult = 1.2


        MakeHauntableLaunch(inst)


    ------------------------------------------------------------------------------

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

return Prefab("underworld_hana_weapon_innocent", fn, assets)
