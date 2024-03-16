----------------------------------------------------------------------------------------------------------------------------------
--[[

     
     
]]--
----------------------------------------------------------------------------------------------------------------------------------
    STRINGS.ACTIONS.HANA_COM_ACCEPTABLE_ACTION = STRINGS.ACTIONS.HANA_COM_ACCEPTABLE_ACTION or {
        DEFAULT = STRINGS.ACTIONS.ADDCOMPOSTABLE
    }
----------------------------------------------------------------------------------------------------------------------------------
local hana_com_acceptable = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.sg = "give"
    self.str_index = "DEFAULT"
    self.str = ""
end,
nil,
{

})
----------------------------------------------------------------------------------------------------------------------------------
------- test
    function hana_com_acceptable:SetTestFn(fn)
        if type(fn) == "function" then
            self.Test_Fn = fn
        end
    end

    function hana_com_acceptable:Test(item,doer)
        if self.Test_Fn then
            return self.Test_Fn(self.inst,item,doer)
        end
        return false
    end
----------------------------------------------------------------------------------------------------------------------------------
------ sg
    function hana_com_acceptable:SetSGAction(sg)
        self.sg = sg
    end
    function hana_com_acceptable:GetSGAction()
        return self.sg
    end
----------------------------------------------------------------------------------------------------------------------------------
----- text
    function hana_com_acceptable:SetText(index,str)
        self.str_index = string.upper(index)
        self.str = str
        STRINGS.ACTIONS.HANA_COM_ACCEPTABLE_ACTION[self.str_index] = str
    end
    function hana_com_acceptable:GetTextIndex()
        return self.str_index
    end
    function hana_com_acceptable:SetTextUpdateFn(fn)
        self.__text_update_fn = fn
    end
    function hana_com_acceptable:ActiveTextUpdate(item,doer)
        if self.__text_update_fn then
            self.__text_update_fn(self.inst,item,doer)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
--- DoPreActionFn
    function hana_com_acceptable:SetPreActionFn(fn)
        if type(fn) == "function" then
            self.__pre_action_fn = fn
        end
    end
    function hana_com_acceptable:DoPreAction(item,doer)
        if self.__pre_action_fn then
            return self.__pre_action_fn(self.inst,item,doer)
        end
    end
----------------------------------------------------------------------------------------------------------------------------------
return hana_com_acceptable






