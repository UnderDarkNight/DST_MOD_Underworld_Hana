------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    修改玩家的sanity 组件，实现一些装备、机制

                        function Sanity:DoDelta(delta, overtime)
    API :
        Underworld_Hana_Add_DoDelta_Modifer_fn(inst,function(sanity,delta,overtime)
            
            return delta,overtime
        end)

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddComponentPostInit("sanity", function(self)

    self.__Underworld_Hana_dodelta_modifer_fns = {}

    local function remove_modifer_by_inst(inst)
        local new_table = {}
        for k,v in pairs(self.__Underworld_Hana_dodelta_modifer_fns) do
            if k ~= inst then
                new_table[k] = v
            end
        end
        self.__Underworld_Hana_dodelta_modifer_fns = new_table
    end

    function self:Underworld_Hana_Add_DoDelta_Modifer_fn(inst,fn)
        if type(fn) == "function" and type(inst) == "table" and inst.ListenForEvent then
            self.__Underworld_Hana_dodelta_modifer_fns[inst] = fn
            inst:ListenForEvent("onremove",remove_modifer_by_inst)
        end
    end
    function self:Underworld_Hana_Remove_DoDelta_Modifer_fn(inst)
        if type(inst) == "table" and inst.ListenForEvent then
            remove_modifer_by_inst(inst)
            inst:RemoveEventCallback("onremove",remove_modifer_by_inst)
        end
    end

    local old_DoDelta = self.DoDelta
    self.DoDelta = function(self,delta,overtime,...)
        for k, temp_fn in pairs(self.__Underworld_Hana_dodelta_modifer_fns) do
            delta = temp_fn(self,delta,overtime)
        end
        return old_DoDelta(self,delta, overtime, ...)
    end

end)