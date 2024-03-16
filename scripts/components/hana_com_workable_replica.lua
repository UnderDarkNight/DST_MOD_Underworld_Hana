----------------------------------------------------------------------------------------------------------------------------------
--[[

     
     
]]--
----------------------------------------------------------------------------------------------------------------------------------
STRINGS.ACTIONS.HANA_COM_WORKABLE_ACTION = STRINGS.ACTIONS.HANA_COM_WORKABLE_ACTION or {
    DEFAULT = STRINGS.ACTIONS.OPEN_CRAFTING.USE
}


local hana_com_workable = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}

    self.sg = "dolongaction"
    self.str_index = "DEFAULT"
    self.str = "test"

end,
nil,
{

})


--------------------------------------------------------------------------------------------------------------
--- test 函数
    function hana_com_workable:SetTestFn(fn)
        if type(fn) == "function" then
            self._test_fn = fn
        end
    end

    function hana_com_workable:Test(doer,right_click)
        if self._test_fn then
            return self._test_fn(self.inst,doer,right_click)
        end
        return false
    end
--------------------------------------------------------------------------------------------------------------
--- DoPreActionFn
    function hana_com_workable:SetPreActionFn(fn)
        if type(fn) == "function" then
            self.__pre_action_fn = fn
        end
    end
    function hana_com_workable:DoPreAction(doer)
        if self.__pre_action_fn then
            return self.__pre_action_fn(self.inst,doer)
        end
    end
--------------------------------------------------------------------------------------------------------------
--- sg
    function hana_com_workable:SetSGAction(sg)
        self.sg = sg
    end
    function hana_com_workable:GetSGAction()
        return self.sg
    end
--------------------------------------------------------------------------------------------------------------
--- 显示文本
    function hana_com_workable:SetText(index,str)
        self.str_index = string.upper(index)
        self.str = str
        STRINGS.ACTIONS.HANA_COM_WORKABLE_ACTION[self.str_index] = str
    end

    function hana_com_workable:GetTextIndex()
        return self.str_index
    end
    function hana_com_workable:SetTextUpdateFn(fn)
        self.__text_update_fn = fn
    end
    function hana_com_workable:ActiveTextUpdate(doer)
        if self.__text_update_fn then
            self.__text_update_fn(self.inst,doer)
        end
    end
--------------------------------------------------------------------------------------------------------------

return hana_com_workable






