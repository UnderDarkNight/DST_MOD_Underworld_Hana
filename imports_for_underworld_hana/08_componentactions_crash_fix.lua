--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 强制修一些 componentactions.lua 里 崩溃。至于为什么崩溃，不知道。
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




-- local old_UnregisterComponentActions = EntityScript.UnregisterComponentActions
-- EntityScript.UnregisterComponentActions = function(...)
--     -- print("underworld_hana_test UnregisterComponentActions",...)
--     local crash_flg = pcall(old_UnregisterComponentActions,...)
--     if not crash_flg then
--         print("underworld_hana error : UnregisterComponentActions",...)
--     end
-- end

if GLOBAL.EntityScript.UnregisterComponentActions_underworld_hana_old == nil then


    -------------------------------------------------------------------------------------------
    ---- UnregisterComponentActions
        rawset(GLOBAL.EntityScript,"UnregisterComponentActions_underworld_hana_old",rawget(GLOBAL.EntityScript,"UnregisterComponentActions"))
        rawset(GLOBAL.EntityScript, "UnregisterComponentActions", function(self,...)
                -- print("underworld_hana_test UnregisterComponentActions",self,...)
            local crash_flg = pcall(self.UnregisterComponentActions_underworld_hana_old,self,...)
            if not crash_flg then
                print("underworld_hana error : UnregisterComponentActions",self,...)
            end
        end)
    -------------------------------------------------------------------------------------------
    ---- CollectActions
        rawset(GLOBAL.EntityScript,"CollectActions_underworld_hana_old",rawget(GLOBAL.EntityScript,"CollectActions"))
        rawset(GLOBAL.EntityScript, "CollectActions", function(self,...)
                -- print("underworld_hana_test CollectActions",self,...)
            local crash_flg,crash_reason = pcall(self.CollectActions_underworld_hana_old,self,...)
            if not crash_flg then
                print("underworld_hana error : CollectActions",self,...)
                print(crash_reason)
            end
        end)







end