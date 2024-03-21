------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    疯狂熊猫胸针

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
local function GetStringsTable(prefab_name)
    return TUNING["underworld_hana.fn"].GetStringsTable(prefab_name or "underworld_hana_equipment_panda_brooch")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/underworld_hana_equipment_panda_brooch.zip"),
    Asset( "IMAGE", "images/inventoryimages/underworld_hana_equipment_panda_brooch.tex" ),
    Asset( "ATLAS", "images/inventoryimages/underworld_hana_equipment_panda_brooch.xml" ),


}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "underworld_hana_equipment_panda_brooch", "swap_body")

end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

end

------------------------------------------------------------------------------------------------------------------


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("underworld_hana_equipment_panda_brooch")
    inst.AnimState:SetBuild("underworld_hana_equipment_panda_brooch")
    inst.AnimState:PlayAnimation("idle",true)

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("underworld_hana_equipment_panda_brooch")

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
        inst.components.inventoryitem.imagename = "underworld_hana_equipment_panda_brooch"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_equipment_panda_brooch.xml"
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
    --- 耐久度
        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses(TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 100 or 960)
        inst.components.finiteuses:SetUses(TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 100 or 960)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
    ------------------------------------------------------------------------------
    --- 穿上就开始计时
        inst:ListenForEvent("equipped_by_player",function()
            if inst.__finiteuses_task then
                return
            end
            inst.__finiteuses_task = inst:DoPeriodicTask(1,function()
                inst.components.finiteuses:Use()
            end)
        end)
        inst:ListenForEvent("unequipped_by_player",function()
            if inst.__finiteuses_task then
                inst.__finiteuses_task:Cancel()
                inst.__finiteuses_task = nil
            end
        end)
    ------------------------------------------------------------------------------
    --- 位面防御
        -- inst:AddComponent("planardefense")
        -- inst.components.planardefense:SetBaseDefense(10)
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
    ---- 减伤 50% . CD延长20％
        inst:ListenForEvent("equipped_by_player",function(inst,player)
            player.components.combat.externaldamagetakenmultipliers:SetModifier(inst,0.5)
            player.components.hana_com_spell_cd_modifier:SetModifier(inst,TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 0 or 1.2)
        end)
        inst:ListenForEvent("unequipped_by_player",function(inst,player)
            player.components.combat.externaldamagetakenmultipliers:RemoveModifier(inst)
            player.components.hana_com_spell_cd_modifier:RemoveModifier(inst)
        end)
    ------------------------------------------------------------------------------
    ---- 护甲耐久消耗减少的 event  消耗减少 20%
        local function add_modifier_2_equipment(inst,item)
            if item == inst then
                return
            end
            if item.components.weapon then
                item.components.weapon.attackwearmultipliers:SetModifier(inst,0.8)
            end
            if item.components.armor then
                item.components.armor.conditionlossmultipliers:SetModifier(inst,0.8)
            end
            -- print("++++++ add_modifier_2_equipment +++++",item)
        end
        local function remove_modifier_from_equipment(inst,item)
            if item.components.weapon then
                item.components.weapon.attackwearmultipliers:RemoveModifier(inst)
            end
            if item.components.armor then
                item.components.armor.conditionlossmultipliers:RemoveModifier(inst)
            end
            -- print("++++++ remove_modifier_from_equipment +++++",item)
        end

        local function equip_event_in_player(player,_table)
            local item = _table and _table.item
            if item then
                add_modifier_2_equipment(inst,item)
            end
        end
        local function unequip_event_in_player(player,_table)
            local item = _table and _table.item
            if item then
                remove_modifier_from_equipment(inst,item)
            end
        end
        inst:ListenForEvent("equipped_by_player",function(inst,player)
            player:ListenForEvent("equip",equip_event_in_player)
            player:ListenForEvent("unequip",unequip_event_in_player)
            inst:DoTaskInTime(0,function()                
                for k, temp_item in pairs(player.components.inventory.equipslots) do
                    if temp_item then
                        add_modifier_2_equipment(inst,temp_item)
                    end
                end
            end)
        end)
        inst:ListenForEvent("unequipped_by_player",function(inst,player)
            player:RemoveEventCallback("equip",equip_event_in_player)
            player:RemoveEventCallback("unequip",unequip_event_in_player)
            for k, temp_item in pairs(player.components.inventory.equipslots) do
                if temp_item then
                    remove_modifier_from_equipment(inst,temp_item)
                end
            end
        end)
    ------------------------------------------------------------------------------

    return inst
end
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------

return Prefab("underworld_hana_equipment_panda_brooch", fn, assets)
