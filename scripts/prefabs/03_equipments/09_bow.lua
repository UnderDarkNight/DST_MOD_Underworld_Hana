------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    辐光

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
local function GetStringsTable(prefab_name)
    return TUNING["underworld_hana.fn"].GetStringsTable(prefab_name or "underworld_hana_equipment_bow")
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
    Asset("ANIM", "anim/underworld_hana_equipment_bow.zip"),
    Asset( "IMAGE", "images/inventoryimages/underworld_hana_equipment_bow.tex" ),
    Asset( "ATLAS", "images/inventoryimages/underworld_hana_equipment_bow.xml" ),


}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "underworld_hana_equipment_bow", "swap_body")

end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")

end

------------------------------------------------------------------------------------------------------------------
---
    local function player_night_vison_event_setup(inst)

        inst.__net_entity_for_night_vison = net_entity(inst.GUID, "underworld_hana_equipment_bow_night_vison", "underworld_hana_equipment_bow_night_vison")
        if not TheNet:IsDedicated() then
            inst:ListenForEvent("underworld_hana_equipment_bow_night_vison",function()
                local net_inst = inst.__net_entity_for_night_vison:value()
                if net_inst then
                        if net_inst:HasTag("player") and net_inst == ThePlayer then
                            ------------------------------------------
                            --- 开灯
                                if inst._light_fx then
                                    inst._light_fx:Remove()
                                end
                                inst._light_fx = CreateEntity()
                                inst._light_fx.entity:AddTransform()
                                inst._light_fx.entity:AddLight()
                                inst._light_fx.entity:SetParent(net_inst.entity)
                
                                inst._light_fx.Light:SetIntensity(0.9)		-- 强度
                                inst._light_fx.Light:SetRadius(5)			-- 半径 ，矩形的？？ --- SetIntensity 为1 的时候 成矩形
                                inst._light_fx.Light:SetFalloff(0.1)		-- 下降梯度
                                inst._light_fx.Light:SetColour(255 / 255, 255 / 255, 255 / 255)
                            ------------------------------------------
                        else
                            ------------------------------------------
                            --- 关灯
                                if inst._light_fx then
                                    inst._light_fx:Remove()
                                    inst._light_fx = nil
                                end
                            ------------------------------------------

                        end
                end
            end)
            inst:ListenForEvent("onremove",function()
                if inst._light_fx then
                    inst._light_fx:Remove()
                end
            end)
        end
        if TheWorld.ismastersim then
                inst:ListenForEvent("night_vison_on",function(inst,player)
                    -----------------------------------------------------
                        print("info night_vison_on",player)

                    -----------------------------------------------------
                    --- 耐久度消耗task
                        if inst.__night_vison_task then
                            return
                        end
                        inst.__night_vison_task = inst:DoPeriodicTask(1,function()
                            inst.components.finiteuses:Use()
                        end)
                    -----------------------------------------------------
                    --- 启动视野
                        if player.components.grue then
                            player.components.grue:AddImmunity("underworld_hana_equipment_bow")
                        end
                        inst.__net_entity_for_night_vison:set(player)
                    -----------------------------------------------------

                end)
                inst:ListenForEvent("night_vison_off",function(inst,player)
                    -----------------------------------------------------
                        print("info night_vison_off",player)
                    -----------------------------------------------------
                    --- 耐久度消耗task
                        if inst.__night_vison_task then
                            inst.__night_vison_task:Cancel()
                            inst.__night_vison_task = nil
                        end
                    -----------------------------------------------------
                    --- 关闭视野
                        if player.components.grue then
                            player.components.grue:RemoveImmunity("underworld_hana_equipment_bow")
                        end
                        inst.__net_entity_for_night_vison:set(inst)
                    -----------------------------------------------------
                end)
                inst:ListenForEvent("onremove",function()
                    if inst.owner then
                        inst:PushEvent("night_vison_off",inst.owner)
                    end
                end)
        end
    end
------------------------------------------------------------------------------------------------------------------
----
    local function right_click_action_setup(inst)
        inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_workable",function(inst,replica_com)
            replica_com:SetTestFn(function(inst,doer,right_click)
                if inst.replica.equippable:IsEquipped() then
                    return true
                end
                return false
            end)
            replica_com:SetSGAction("underworld_hana_sg_equip")
            replica_com:SetText("underworld_hana_equipment_bow",GetStringsTable()["action_str"])
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("hana_com_workable")
            inst.components.hana_com_workable:SetActiveFn(function(inst,doer)
                if inst:HasTag("night_vison_on") then
                    inst:RemoveTag("night_vison_on")
                    inst:PushEvent("night_vison_off",doer)
                else
                    inst:AddTag("night_vison_on")
                    inst:PushEvent("night_vison_on",doer)
                end
                return true
            end)
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

    inst.AnimState:SetBank("underworld_hana_equipment_bow")
    inst.AnimState:SetBuild("underworld_hana_equipment_bow")
    inst.AnimState:PlayAnimation("idle",true)

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("underworld_hana_equipment_bow")

    MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85})


    inst.entity:SetPristine()
    -------------------------------------------------------------------------------------
    --- 
        player_night_vison_event_setup(inst)
    -------------------------------------------------------------------------------------
    --- 右键使用
        right_click_action_setup(inst)
    -------------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    ------------------------------------------------------------------------------

    ------------------------------------------------------------------------------
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("voidcloth_scythe")
        inst.components.inventoryitem.imagename = "underworld_hana_equipment_bow"
        inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_equipment_bow.xml"
    ------------------------------------------------------------------------------
    ---- 
        inst:AddComponent("equippable")
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.equipslot = TUNING["underworld_hana.equip_slot"]:GetAmuletType() or EQUIPSLOTS.BODY
        inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL/2
        inst.components.equippable.is_magic_dapperness = true

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
        inst.components.finiteuses:SetMaxUses(TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 20 or 960)
        inst.components.finiteuses:SetUses(TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 20 or 960)
        inst.components.finiteuses:SetOnFinished(inst.Remove)
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
    --- 屏蔽帽子
        inst.ClearPlayerHatEvent = function(owner)
            owner.AnimState:ClearOverrideSymbol("headbase_hat") --it might have been overriden by _onequip
            if owner.components.skinner ~= nil then
                owner.components.skinner.base_change_cb = owner.old_base_change_cb
            end
            owner.AnimState:ClearOverrideSymbol("swap_hat")
            owner.AnimState:Hide("HAT")
            owner.AnimState:Hide("HAIR_HAT")
            owner.AnimState:Show("HAIR_NOHAT")
            owner.AnimState:Show("HAIR")

            if owner:HasTag("player") then
                owner.AnimState:Show("HEAD")
                owner.AnimState:Hide("HEAD_HAT")
                owner.AnimState:Hide("HEAD_HAT_NOHELM")
                owner.AnimState:Hide("HEAD_HAT_HELM")
            end
        end

        inst:ListenForEvent("equipped_by_player",function(_,player)
            player:ListenForEvent("equip",inst.ClearPlayerHatEvent)
            inst.ClearPlayerHatEvent(player)
        end)
        inst:ListenForEvent("unequipped_by_player",function(_,player)
            player:RemoveEventCallback("equip",inst.ClearPlayerHatEvent)            
        end)
        inst:ListenForEvent("onremove",function()
            if inst.owner then
                inst:PushEvent("unequipped_by_player",inst.owner)
            end
        end)
    ------------------------------------------------------------------------------

    return inst
end
------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------

return Prefab("underworld_hana_equipment_bow", fn, assets)
