------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    冰雪女王的戒指

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
local function GetStringsTable(prefab_name)
    return TUNING["underworld_hana.fn"].GetStringsTable(prefab_name or "underworld_hana_equipment_ice_queen_ring")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/underworld_hana_equipment_ice_queen_ring.zip"),
    Asset( "IMAGE", "images/inventoryimages/underworld_hana_equipment_ice_queen_ring.tex" ),
    Asset( "ATLAS", "images/inventoryimages/underworld_hana_equipment_ice_queen_ring.xml" ),


}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function onequip(inst, owner)
    -- owner.AnimState:OverrideSymbol("swap_body", "underworld_hana_equipment_ice_queen_ring", "swap_body")

end

local function onunequip(inst, owner)
    -- owner.AnimState:ClearOverrideSymbol("swap_body")

end

------------------------------------------------------------------------------------------------------------------


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("underworld_hana_equipment_ice_queen_ring")
    inst.AnimState:SetBuild("underworld_hana_equipment_ice_queen_ring")
    inst.AnimState:PlayAnimation("idle",true)

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("underworld_hana_equipment_ice_queen_ring")

    MakeInventoryFloatable(inst)


    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    --- 
    -------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    ------------------------------------------------------------------------------

    ------------------------------------------------------------------------------
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("voidcloth_scythe")
        inst.components.inventoryitem.imagename = "underworld_hana_equipment_ice_queen_ring"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_equipment_ice_queen_ring.xml"
    ------------------------------------------------------------------------------
    ---- 
        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.equipslot = TUNING["underworld_hana.equip_slot"]:GetAmuletType() or EQUIPSLOTS.BODY
        -- inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL/2
        -- inst.components.equippable.is_magic_dapperness = true

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


    ------------------------------------------------------------------------------
    --- 位面防御
        inst:AddComponent("planardefense")
        inst.components.planardefense:SetBaseDefense(10)
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
    ---- 伤害增加10%. CD减少10％
        inst:ListenForEvent("equipped_by_player",function(inst,player)
            player.components.combat.externaldamagemultipliers:SetModifier(inst,1.1)
            player.components.hana_com_spell_cd_modifier:SetModifier(inst,TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 0 or 0.9)
        end)
        inst:ListenForEvent("unequipped_by_player",function(inst,player)
            player.components.combat.externaldamagemultipliers:RemoveModifier(inst)
            player.components.hana_com_spell_cd_modifier:RemoveModifier(inst)
        end)
    ------------------------------------------------------------------------------
    ---- player on hit other event
        local function player_on_hit_other_event(player,_table)
            local target = _table and _table.target
            local damage = _table and _table.damage or 0
            if target == nil or not target:IsValid() then
                return
            end
            if target.components.combat == nil then
                return
            end
            ----------------------------------------------------
            ---- 10%概率造成双倍伤害
                if damage > 0 and not inst:HasTag("double_hit_blocker") then
                    if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE or math.random(1000) <= 100 then
                        inst:AddTag("double_hit_blocker")
                        target.components.combat:GetAttacked(player,damage)
                        -- print("double attack",target,damage)
                    end
                else
                    inst:RemoveTag("double_hit_blocker")
                end
            ----------------------------------------------------
            ---- 添加潮湿标签
                target:AddTag("wet")
            ----------------------------------------------------
        end
        inst:ListenForEvent("equipped_by_player",function(inst,player)
            player:ListenForEvent("onhitother",player_on_hit_other_event)
        end)
        inst:ListenForEvent("unequipped_by_player",function(inst,player)
            player:RemoveEventCallback("onhitother",player_on_hit_other_event)
        end)
    ------------------------------------------------------------------------------

    return inst
end
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------

return Prefab("underworld_hana_equipment_ice_queen_ring", fn, assets)
