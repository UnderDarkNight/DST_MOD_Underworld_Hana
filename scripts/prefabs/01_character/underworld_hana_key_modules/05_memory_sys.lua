--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end





    --------------------------------------------------------------------------------------------------------------------------------
    ---- 怪物死亡掉落

        local OnEntityDeath = function(inst,target)
            
            if target:HasTag("underword_hana_faded_memory.flag") then
                return
            end
            target:AddTag("underworld_hana_faded_memory.flag")
            target:ListenForEvent("onremove",function()
                local x,y,z = target.Transform:GetWorldPosition()


                SpawnPrefab("underworld_hana_projectile_faded_memory"):PushEvent("Set",{
                    pt = Vector3(x,0,z),
                    tail_time = 0.3,
                    speed = 8,
                })
            end)
        end

        inst:ListenForEvent("entity_death",function(src, data)
            -- print("+++++++++++++++++++++_faded_memory",src,data)
            -- pcall(function()
            --     for k, v in pairs(data) do
            --         print(k,v)
            --     end
            -- end)
            -- print("+++++++++++++++++++++")
            OnEntityDeath(inst, data.inst) 
        end,TheWorld)
    --------------------------------------------------------------------------------------------------------------------------------
    ----- 被碰撞
        inst:ListenForEvent("underworld_hana_projectile_faded_memory.onhit",function()
            inst.components.inventory:GiveItem(SpawnPrefab("underworld_hana_item_faded_memory"))
        end)
    --------------------------------------------------------------------------------------------------------------------------------
    ----- 使用褪色的记忆。使用20次 则 等级+1
        inst:ListenForEvent("faded_memory_used",function()
            inst.components.health:DoDelta(1)
            local faded_memory_used_num = inst.components.hana_com_data:Add("faded_memory_used",1)
            if faded_memory_used_num >= 20 then
                inst.components.hana_com_level_sys:LevelDoDelta(1)  ---- 等级+1
                inst.components.hana_com_data:Set("faded_memory_used",0)
            end
        end)
    --------------------------------------------------------------------------------------------------------------------------------
    ----- 使用幸福的记忆。 等级+1 ，-20San 。   50级的时候 能量点 +20
        inst:ListenForEvent("blissful_memory_used",function()
            inst.components.hana_com_level_sys:LevelDoDelta(1)  ---- 等级+1
            inst.components.sanity:DoDelta(-20)
            if inst.components.hana_com_level_sys:GetLevel() >= 50 then
                inst.components.hana_com_level_sys:PowerDoDelta(20)
            end
        end)
    --------------------------------------------------------------------------------------------------------------------------------







end