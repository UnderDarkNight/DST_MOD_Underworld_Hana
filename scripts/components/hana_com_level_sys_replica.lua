----------------------------------------------------------------------------------------------------------------------------------
--[[


]]--
----------------------------------------------------------------------------------------------------------------------------------
----
    
----------------------------------------------------------------------------------------------------------------------------------
local hana_com_level_sys = Class(function(self, inst)
    self.inst = inst

    self.level = 0
    self.max_level = 50
    self._level_update_fn = nil
    self.net_level = net_float(self.inst.GUID,"hana_com_level_sys_replica.level","hana_com_level_sys_replica.level")
    if not TheNet:IsDedicated() then    ---- 只在客户端加载
        self.inst:ListenForEvent("hana_com_level_sys_replica.level",function()
            self.level = self.net_level:value()
            if self._level_update_fn then
                self._level_update_fn(self.inst,self,self.level)
            end
        end)
    end

    self.power = 0
    self._power_update_fn = nil
    self.net_power = net_float(self.inst.GUID,"hana_com_level_sys_replica.power","hana_com_level_sys_replica.power")
    if not TheNet:IsDedicated() then    ---- 只在客户端加载
        self.inst:ListenForEvent("hana_com_level_sys_replica.power",function()
            self.power = self.net_power:value()
            if self._power_update_fn then
                self._power_update_fn(self.inst,self,self.power)
            end
        end)
    end

end)
------------------------------------------------------------------------------------------------------------------------------
----    
    function hana_com_level_sys:Level_Update(num)
        self.net_level:set(num)
    end
    function hana_com_level_sys:SetLevelUpdateFn(fn)
        self._level_update_fn = fn
    end
    function hana_com_level_sys:GetLevel()
        return self.level
    end
------------------------------------------------------------------------------------------------------------------------------
---- 
    function hana_com_level_sys:Power_Update(num)
        self.net_power:set(num)
    end
    function hana_com_level_sys:SetPowerUpdateFn(fn)
        self._power_update_fn = fn
    end
    function hana_com_level_sys:GetPower()
        return  self.power , self.power/100
    end
   
------------------------------------------------------------------------------------------------------------------------------
return hana_com_level_sys







