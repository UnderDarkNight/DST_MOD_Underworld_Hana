------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    sg 拦截切换
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local attack_action_hook_fn = function(self)    ----- 修改 wilson 和 wilson_client 的动作返回捕捉
    local old_ATTACK = self.actionhandlers[ACTIONS.ATTACK].deststate
    self.actionhandlers[ACTIONS.ATTACK].deststate = function(inst,action)
        
        -------------------------------------------------------------------------------------------------------------
        --- return sg 的状态。注意 client/server 都进行了一样的HOOK
            if inst:HasTag("underworld_hana") then
                if not ( inst.replica.rider and inst.replica.rider:IsRiding() ) then
                        local weapon = inst.replica.combat:GetWeapon()
                        if weapon and weapon:HasTag("underworld_hana_weapon_scythe_overcome_confinement") then
                            if weapon.acttack_action_scythe then
                                return "hana_scythe_attack"
                            end
                        end
                        
                end
            end
        -------------------------------------------------------------------------------------------------------------
        
        return old_ATTACK(inst, action)
    end
end
AddStategraphPostInit("wilson", attack_action_hook_fn)  ----------- 加给 主机 （成功）
AddStategraphPostInit("wilson_client", attack_action_hook_fn)    -------- 注意 inst.replica 检测，用于客机