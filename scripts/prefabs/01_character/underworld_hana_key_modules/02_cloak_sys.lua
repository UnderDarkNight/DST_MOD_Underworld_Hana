--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    披风系统

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function cloak_event_setup(inst)
        -----------------------------------------------------------------------
        ------- 穿上
            local function spawn_cloak2player(inst,item)
                local cloak_datas = inst.components.hana_com_data:Get("cloak_datas") or {}
                local prefab = cloak_datas.prefab or "underworld_hana_equipment_cloak_1"
                ---------------------------------------------------------------
                ----
                    local cave_through = item ~= nil
                    local item = item or SpawnPrefab(prefab)

                ---------------------------------------------------------------
                --- contaienr
                    if not cave_through then
                        cloak_datas.slots = cloak_datas.slots or {}
                        for index, temp_record in pairs(cloak_datas.slots) do
                            if temp_record then
                                local temp_item = SpawnSaveRecord(temp_record)
                                item.components.container:GiveItem(temp_item, index)
                            end
                        end
                    end
                ---------------------------------------------------------------
                ---- 冰箱
                    if cloak_datas.fridge then
                        item:AddTag("fridge")
                    end
                ---------------------------------------------------------------
                ---- 护目镜
                    if cloak_datas.goggles then
                        item:AddTag("goggles")
                    end
                ---------------------------------------------------------------
                ---- 护甲减伤
                    if cloak_datas.armor_absorb_percent then
                        item.components.armor.absorb_percent = cloak_datas.armor_absorb_percent
                    end
                ---------------------------------------------------------------
                ---- 防水
                    if cloak_datas.waterproofer_effectiveness then
                        item.components.waterproofer:SetEffectiveness(cloak_datas.waterproofer_effectiveness)                
                    end
                ---------------------------------------------------------------
                ---------------------------------------------------------------
                --- 穿到玩家身上
                    if not cave_through then
                        inst.components.inventory:Equip(item)
                    end
                    inst.components.hana_com_tag_sys:AddTag("cloak_equipped")
                    inst.__cloak_item = item
                ---------------------------------------------------------------
                    -- print("info ++++++++++++++++ Add +++++++++++++++++++")
                    -- for k, v in pairs(cloak_datas) do
                    --     print(k,v)
                    -- end
                    -- print("----------------------------------------------")
                    -- for k, v in pairs(cloak_datas.slots or {}) do
                    --     print(k,v)
                    -- end
                    -- print("info ++++++++++++++++ Add +++++++++++++++++++")


                ---------------------------------------------------------------
            end
            inst:ListenForEvent("hana_cloak_do_equip",spawn_cloak2player)
        -----------------------------------------------------------------------
        ------ 脱下
            local function remove_cloak_from_player(inst,item)
                local cloak_datas = {}
                ---------------------------------------------------------------
                    cloak_datas.prefab = item.prefab
                ---------------------------------------------------------------
                ---- container  先丢掉独特物品
                    item.components.container:ForEachItem(function(temp_item)
                        if temp_item and temp_item:HasOneOfTags({"nosteal","irreplaceable"}) then
                            item.components.container:DropItemBySlot(item.components.container:GetItemSlot(temp_item))
                        end
                    end)

                    local slots = {}
                    for index, temp_item in pairs(item.components.container.slots) do
                        if temp_item then
                            slots[index] = temp_item:GetSaveRecord()
                        end
                    end
                    cloak_datas.slots = slots
                ---------------------------------------------------------------
                ---- 冰箱
                    if item:HasTag("fridge") then
                        cloak_datas.fridge = true
                    end
                ---------------------------------------------------------------
                ---- 护目镜
                    if item:HasTag("goggles") then
                        cloak_datas.goggles = true
                    end
                ---------------------------------------------------------------
                ---- 护甲减伤
                    cloak_datas.armor_absorb_percent = item.components.armor.absorb_percent
                ---------------------------------------------------------------
                ---- 防水
                    cloak_datas.waterproofer_effectiveness = item.components.waterproofer:GetEffectiveness()
                ---------------------------------------------------------------
                ---------------------------------------------------------------
                    inst.components.hana_com_data:Set("cloak_datas",cloak_datas)
                ---------------------------------------------------------------
                    item:Remove()
                    inst.components.hana_com_tag_sys:RemoveTag("cloak_equipped")
                    inst.__cloak_item = nil
                ---------------------------------------------------------------
                    -- print("info ++++++++++++++++ Remove +++++++++++++++++++")
                    -- for k, v in pairs(cloak_datas) do
                    --     print(k,v)
                    -- end
                    -- print("----------------------------------------------")
                    -- for k, v in pairs(cloak_datas.slots or {}) do
                    --     print(k,v)
                    -- end
                    -- print("info ++++++++++++++++ Remove +++++++++++++++++++")

                ---------------------------------------------------------------
            end
            inst:ListenForEvent("hana_cloak_do_unequip",function(inst,item)
                remove_cloak_from_player(inst, item)
            end)
        -----------------------------------------------------------------------
        ----- switch
            inst:ListenForEvent("hana_cloak_do_switch",function(inst)
                if inst.__cloak_item then
                    inst:PushEvent("hana_cloak_do_unequip",inst.__cloak_item)
                else
                    inst:PushEvent("hana_cloak_do_equip")
                end
            end)
        -----------------------------------------------------------------------
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)

    ---------------------------------------------------------------------------------------------
    --- 右键玩家自身的交互组件
        inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_workable",function(inst,replica_com)
            replica_com:SetSGAction("give")
            replica_com:SetText("hana_cloak_action","互动")

            replica_com:SetTestFn(function(inst,doer,right_click)
                if right_click and doer == inst then
                    return true
                end
                return false
            end)

            replica_com:SetTextUpdateFn(function(inst)
                if inst.replica.hana_com_tag_sys then
                    if inst.replica.hana_com_tag_sys:HasTag("cloak_equipped") then
                        replica_com:SetText("hana_cloak_action","脱下")
                    else
                        replica_com:SetText("hana_cloak_action","穿上披风")
                    end
                end
            end)

        end)
        if TheWorld.ismastersim then
            inst:AddComponent("hana_com_workable")
            inst.components.hana_com_workable:SetActiveFn(function(inst,doer)
                inst:PushEvent("hana_cloak_do_switch")
                return true
            end)
        end
    ---------------------------------------------------------------------------------------------
    ---- 安装 披风穿戴/脱下的event
        if TheWorld.ismastersim then
            cloak_event_setup(inst)
        end

    ---------------------------------------------------------------------------------------------
    ----- 屏蔽击飞
        if TheWorld.ismastersim then
            inst:ListenForEvent("newstate", function(_,_table)
                if _table and _table.statename == "knockback" and inst.sg and inst.replica.hana_com_tag_sys and inst.replica.hana_com_tag_sys:HasTag("cloak_equipped") then
                    inst.sg:GoToState("idle")
                end
            end)

        end
    ---------------------------------------------------------------------------------------------


end