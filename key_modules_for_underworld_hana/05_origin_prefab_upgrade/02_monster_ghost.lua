------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    幽灵将不会攻击哈娜

    幽灵被攻击后  恢复正常

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddPrefabPostInit(
    "ghost",
    function(inst)
        if not TheWorld.ismastersim then
            return
        end
        inst:AddTag("underworld_hana_tag.ignore_hana")

        -----------------------------------------------------------------------------
        --- 幽灵的攻击不走 combat 组件
                -- local old_SetTarget_fn = inst.components.combat.SetTarget
                -- inst.components.combat.SetTarget = function(self, target)
                --     print("SetTarget ++ ",inst,target)

                --     if target and target:HasTag("underworld_hana") and inst:HasTag("underworld_hana_tag.ignore_hana") then
                --         return
                --     end
                --     return old_SetTarget_fn(self, target)
                -- end

                -- local old_SuggestTarget_fn = inst.components.combat.SuggestTarget
                -- inst.components.combat.SuggestTarget = function(self, target)
                --     print("SuggestTarget ++ ",inst,target)
                --     if target and target:HasTag("underworld_hana") and inst:HasTag("underworld_hana_tag.ignore_hana") then
                --         return
                --     end
                --     return old_SuggestTarget_fn(self, target)
                -- end

                -- local old_DoAttack_fn = inst.components.combat.DoAttack
                -- inst.components.combat.DoAttack = function(self,target,...)
                --     print("DoAttack +++ ",target)
                --     return old_DoAttack_fn(self,target,...)
                -- end
        -----------------------------------------------------------------------------
                local old_auratestfn_fn = inst.components.aura.auratestfn
                inst.components.aura.auratestfn = function(inst,target)
                    if target and target:HasTag("underworld_hana") and inst:HasTag("underworld_hana_tag.ignore_hana") then
                        return false
                    end
                    return old_auratestfn_fn(inst,target)
                end


        -----------------------------------------------------------------------------
        inst:ListenForEvent("attacked",function(_,_table)
            if _table and _table.attacker and _table.attacker:HasTag("underworld_hana") then
                inst:RemoveTag("underworld_hana_tag.ignore_hana")
            end
        end)

        inst:ListenForEvent("losttarget",function()
            inst:AddTag("underworld_hana_tag.ignore_hana")            
        end)


        -- print(" fake error ghost hooked ++++++++++")
end)