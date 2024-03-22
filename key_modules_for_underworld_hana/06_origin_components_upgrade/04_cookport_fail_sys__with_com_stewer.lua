------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    烹饪锅组件

    添加个事件，实现烹饪锅瞬间完成
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddComponentPostInit("stewer", function(stewer_com)
    if not TheWorld.ismastersim then
        return
    end

    ----------------------------------------------------------------------------------

    ----------------------------------------------------------------------------------
    
    stewer_com.inst:ListenForEvent("underworld_hana_event.stewer.force_finish",function(inst)
        if stewer_com:IsCooking() and not stewer_com:IsDone() then
            if type(stewer_com.targettime) == "number" then 
                -- dostew(inst,stewer_com)
                -- stewer_com:LongUpdate(10000)    ---- 找到个更快捷的方法

                    --- self.targettime - dt - GetTime() = 0
                    local dt = stewer_com.targettime - GetTime()
                    if dt > 0 then
                        stewer_com:LongUpdate( dt )    ---- 找到个更快捷的方法
                    end
            end
        end
    end)

    ----------------------------------------------------------------------------------
    ---- 推送事件
        local old_StartCooking_fn = stewer_com.StartCooking

        stewer_com.StartCooking = function(self,doer,...)
            doer:PushEvent("underworld_hana_event.stewer.cooking_started",self.inst)
            old_StartCooking_fn(self,doer,...)
            -- self.inst:DoTaskInTime(0,function()
            --     if self:IsCooking() and not self:IsDone() then
            --     end
            -- end)
        end
    ----------------------------------------------------------------------------------
    ---- 采集事件
        local old_Harvest_fn = stewer_com.Harvest

        stewer_com.Harvest = function(self,doer,...)
            doer:PushEvent("underworld_hana_event.stewer.harvest",self.inst)
            old_Harvest_fn(self,doer,...)
        end
    ----------------------------------------------------------------------------------




end)