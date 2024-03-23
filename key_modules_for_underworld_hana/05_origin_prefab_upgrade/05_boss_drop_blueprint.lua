-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
    local function common_dorp_fn(inst)
        -- if not (TUNING.UNDERWORLD_HANA_DEBUGGING_MODE or math.random(1000) <= 100 )then
        --     return
        -- end

        local item_prefab = {
            "underworld_hana_equipment_panda_brooch",									--- 熊猫胸针
            "underworld_hana_equipment_great_earth_brooch",								--- 大地胸针
            "underworld_hana_equipment_ice_queen_ring",									--- 冰雪女王指环
            "underworld_hana_weapon_minotaur_shield",									--- 牛头人盾牌
            "underworld_hana_weapon_legionnaire_magic_mirror_shield",					--- 军长魔镜盾
        }


        -- local ret_blueprint_item = item_prefab[math.random(#item_prefab)].."_blueprint"
        -- if PrefabExists(ret_blueprint_item) then
        --     inst.components.lootdropper:SpawnLootPrefab(ret_blueprint_item)
        -- end

        for k, temp_prefab in pairs(item_prefab) do
            local ret_blueprint_item = temp_prefab.."_blueprint"
            if PrefabExists(ret_blueprint_item) then
                if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE or math.random(1000) <= 100 then
                    inst.components.lootdropper:SpawnLootPrefab(ret_blueprint_item)
                end
            end
        end

    end
    local boss_list = {
        ["moose"] = function(inst)  --- 春季鹿鸭
            common_dorp_fn(inst)
        end,
        ["antlion"] = function(inst)    --- 蚁狮
            common_dorp_fn(inst)
            
        end,
        ["bearger"] = function(inst)    --- 熊
            common_dorp_fn(inst)
            
        end,
        ["mutatedbearger"] = function(inst)    --- 月亮熊
            common_dorp_fn(inst)
            
        end,
        ["deerclops"] = function(inst)    --- 冬鹿
            common_dorp_fn(inst)
            
        end,
        ["mutateddeerclops"] = function(inst)    --- 月亮冬鹿
            common_dorp_fn(inst)
            
        end,
        ["dragonfly"] = function(inst)    --- 龙蝇
            common_dorp_fn(inst)
            
        end,
    }
    local function drop_loot_check(inst)
        if boss_list[inst.prefab] then
            boss_list[inst.prefab](inst)
        end
    end
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddPrefabPostInit(
    "world",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end


        inst:ListenForEvent("entity_droploot",function(_,_table)
            if _table and _table.inst and _table.inst.prefab and _table.inst.components.lootdropper then
                drop_loot_check(_table.inst)
            end
        end)

        
    end
)

