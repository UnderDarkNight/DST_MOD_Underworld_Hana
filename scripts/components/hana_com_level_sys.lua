----------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
----------------------------------------------------------------------------------------------------------------------------------
----
    local function level_update(self,num)
        local replica_com = self.inst.replica.hana_com_level_sys or self.inst.replica._.hana_com_level_sys
        if replica_com then
            replica_com:Level_Update(num)
        end
    end
    local function power_update(self,num)
        local replica_com = self.inst.replica.hana_com_level_sys or self.inst.replica._.hana_com_level_sys
        if replica_com then
            replica_com:Power_Update(num)
        end
    end

----------------------------------------------------------------------------------------------------------------------------------
local hana_com_level_sys = Class(function(self, inst)
    self.inst = inst

    self.DataTable = {}
    self.TempTable = {}
    self._onload_fns = {}
    self._onsave_fns = {}

    self.level = 0
    self.max_level = 50
    self._level_update_fn = nil

    self.power = 0
    self.max_power = 100
    self.power_delta_lock = false

end,
nil,
{

    level = level_update,
    power = power_update,

})
------------------------------------------------------------------------------------------------------------------------------
----- onload/onsave 函数
    function hana_com_level_sys:AddOnLoadFn(fn)
        if type(fn) == "function" then
            table.insert(self._onload_fns, fn)
        end
    end
    function hana_com_level_sys:ActiveOnLoadFns()
        for k, temp_fn in pairs(self._onload_fns) do
            temp_fn(self)
        end
    end
    function hana_com_level_sys:AddOnSaveFn(fn)
        if type(fn) == "function" then
            table.insert(self._onsave_fns, fn)
        end
    end
    function hana_com_level_sys:ActiveOnSaveFns()
        for k, temp_fn in pairs(self._onsave_fns) do
            temp_fn(self)
        end
    end
------------------------------------------------------------------------------------------------------------------------------
----- 数据读取/储存

    function hana_com_level_sys:Get(index)
        if index then
            return self.DataTable[index]
        end
        return nil
    end
    function hana_com_level_sys:Set(index,theData)
        if index then
            self.DataTable[index] = theData
        end
    end

    function hana_com_level_sys:Add(index,num)
        if index then
            self.DataTable[index] = (self.DataTable[index] or 0) + ( num or 0 )
            return self.DataTable[index]
        end
        return 0
    end
------------------------------------------------------------------------------------------------------------------------------
----- 等级更变的时候执行这些Fn
    function hana_com_level_sys:SetLevelUpdateFn(fn)
        self._level_update_fn = fn
    end
    function hana_com_level_sys:LevelUpdate()
        if self._level_update_fn then
            self._level_update_fn(self.inst,self,self.level)
        end
    end
    function hana_com_level_sys:LevelDoDelta(num)
        local ret_level = self.level + num
        self.level = math.clamp(ret_level,0,self.max_level)
        self:LevelUpdate()
    end
    function hana_com_level_sys:GetLevel()
        return self.level
    end
------------------------------------------------------------------------------------------------------------------------------
----- 能量值
    function hana_com_level_sys:SetPowerDeltaLock(flag)
        self.power_delta_lock = flag
    end
    function hana_com_level_sys:PowerDoDelta(num)
        if self.power_delta_lock then
            return
        end
        local old_power_num = self.power
        local new_power_num = math.clamp(old_power_num + num,0,self.max_power)
        self.power = new_power_num
        -- 广播通知
            if old_power_num ~= new_power_num then
                self.inst:PushEvent("hana_com_level_sys_power_dodelta",{
                    old = old_power_num,
                    new = new_power_num,
                })
            end
    end
    function hana_com_level_sys:GetPower()
        return self.power,self.power/100
    end


------------------------------------------------------------------------------------------------------------------------------
    function hana_com_level_sys:OnSave()
        self:ActiveOnSaveFns()
        local data =
        {
            DataTable = self.DataTable,
            level = self.level,
        }
        return next(data) ~= nil and data or nil
    end

    function hana_com_level_sys:OnLoad(data)
        if data.DataTable then
            self.DataTable = data.DataTable
        end
        if data.level then
            self.level = data.level
        end
        self:ActiveOnLoadFns()
        self:LevelUpdate()
    end
------------------------------------------------------------------------------------------------------------------------------
return hana_com_level_sys







