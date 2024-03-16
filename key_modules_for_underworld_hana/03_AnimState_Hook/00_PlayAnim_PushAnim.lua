-- if TUNING["underworld_hana.AnimStateFn"] == nil then
--     TUNING["underworld_hana.AnimStateFn"] = {}
-- end

-- -- TUNING["underworld_hana.AnimStateFn"]["00_PlayAnim_PushAnim"] = function(theAnimState)

-- --     ------ 
-- --     if theAnimState.PlayAnimation_old_underworld_hana == nil then  --- 避免重复hook        
-- --         ----------------------------------------------------------------------------------
-- --         theAnimState.PlayAnimation_old_underworld_hana = theAnimState.PlayAnimation
-- --         theAnimState.PlayAnimation = function(self,anim_name,...)         
-- --             if self.inst and self.inst:HasTag("player") then   
-- --                 print("PlayAnimation",self.inst,anim_name)
-- --             end
-- --             self:PlayAnimation_old_underworld_hana(anim_name,...)
-- --         end
-- --         ----------------------------------------------------------------------------------
-- --         theAnimState.PushAnimation_old_underworld_hana = theAnimState.PushAnimation
-- --         theAnimState.PushAnimation = function(self,anim_name,...)
-- --             if self.inst and self.inst:HasTag("player") then   
-- --                 print("PushAnimation",self.inst,anim_name)
-- --             end
-- --             self:PushAnimation_old_underworld_hana(anim_name,...)
-- --         end
-- --         ----------------------------------------------------------------------------------
-- --     end

-- -- end