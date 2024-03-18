------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    修改玩家的 health 组件，实现一些装备、机制

                        function Health:DoDelta(amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)

    API :
        mcoda_Add_DoDelta_Modifer_fn(inst,function(sanity,delta,overtime)
            
            return delta,overtime
        end)

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddComponentPostInit("health", function(self)

    self.__mcoda_dodelta_modifer_fns = {}

    local function remove_modifer_by_inst(inst)
        local new_table = {}
        for k,v in pairs(self.__mcoda_dodelta_modifer_fns) do
            if k ~= inst then
                new_table[k] = v
            end
        end
        self.__mcoda_dodelta_modifer_fns = new_table
    end

    function self:mcoda_Add_DoDelta_Modifer_fn(inst,fn)
        if type(fn) == "function" and type(inst) == "table" and inst.ListenForEvent then
            self.__mcoda_dodelta_modifer_fns[inst] = fn
            inst:ListenForEvent("onremove",remove_modifer_by_inst)
        end
    end
    function self:mcoda_Remove_DoDelta_Modifer_fn(inst)
        if type(inst) == "table" and inst.ListenForEvent then
            remove_modifer_by_inst(inst)
            inst:RemoveEventCallback("onremove",remove_modifer_by_inst)
        end
    end

    local old_DoDelta = self.DoDelta
    self.DoDelta = function(self,delta,overtime,cause, ignore_invincible, afflicter, ignore_absorb,...)
        for k, temp_fn in pairs(self.__mcoda_dodelta_modifer_fns) do
            delta = temp_fn(self,delta,overtime,cause, ignore_invincible, afflicter, ignore_absorb,...)
        end
        return old_DoDelta(self,delta, overtime,cause,ignore_invincible, afflicter, ignore_absorb, ...)
    end

end)