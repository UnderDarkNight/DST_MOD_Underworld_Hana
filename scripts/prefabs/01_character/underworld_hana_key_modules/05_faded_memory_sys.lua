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
    ----- 使用褪色的记忆
        inst:ListenForEvent("faded_memory_used",function()
            
        end)
    --------------------------------------------------------------------------------------------------------------------------------







end