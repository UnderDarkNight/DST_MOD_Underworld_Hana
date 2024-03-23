--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("underworld_hana_master_postinit",function()
        


        ---------------------------------------------------------------------------------------------------------
        ----
            local old_ApplyDamage_fn = inst.components.inventory.ApplyDamage
            inst.components.inventory.Hana_ApplyDamage_Fns = {}
            inst.components.inventory.Hana_Add_ApplyDamage_Fn = function(self,fn)
                self.Hana_ApplyDamage_Fns[fn] = true
            end
            inst.components.inventory.Hana_Remove_ApplyDamage_Fn = function(self,fn)
                local new_fns = {}
                for temp_fn, flag in pairs(self.Hana_ApplyDamage_Fns) do
                    if temp_fn ~= fn then
                        new_fns[temp_fn] = true
                    end
                end
                self.Hana_ApplyDamage_Fns = new_fns
            end

            inst.components.inventory.ApplyDamage = function(self,damage,attacker, weapon, spdamage,...)
                for temp_fn, flag in pairs(self.Hana_ApplyDamage_Fns) do
                    if temp_fn and flag then
                        damage,attacker,weapon,spdamage = temp_fn(self,damage,attacker, weapon, spdamage,...)
                    end
                end
                return old_ApplyDamage_fn(self,damage,attacker, weapon, spdamage,...)
            end
        ---------------------------------------------------------------------------------------------------------






    end)
end