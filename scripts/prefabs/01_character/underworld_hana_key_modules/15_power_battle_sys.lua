--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:DoTaskInTime(1,function()
        



                --------------------------------------------------------------------------------------------------------------
                -- 【决心】= 造成的伤害*0.03*（1-当前决心所占总决心的百分比）×（1+0.01*当前决心）  , 没脑子的不算数
                    inst:ListenForEvent("onhitother",function(inst,_table)
                        local target = _table and _table.target
                        local damage = _table and _table.damage
                        if not target or type(target) ~= "table" then
                            return
                        end
                        if type(damage) ~= "number" or damage == 0 then
                            return
                        end
                        if target.brainfn == nil and not TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then --- 没脑子的不算数。测试模式除外
                            return
                        end

                        local current_num,current_precent = inst.components.hana_com_level_sys:GetPower()

                        local delta_num = damage * 0.03 * (1-current_precent) * (1+0.01*current_num)
                        if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
                            delta_num = delta_num * 3
                        end
                        inst.components.hana_com_level_sys:PowerDoDelta(delta_num)
                    end)
                --------------------------------------------------------------------------------------------------------------
                --- 【决心】≤40的时候每秒-1点  .  40＜【决心】＜70的时候 每秒-1.5  . 【决心】≥70的时候 每秒-2
                    inst:DoPeriodicTask(1,function()
                        local current_num,current_precent = inst.components.hana_com_level_sys:GetPower()
                        if current_num == 0 then
                            return
                        end
                        local delta_num = 0
                        if current_num <= 40 then
                            delta_num = -1
                        elseif current_num < 70 then
                            delta_num = -1.5
                        else
                            delta_num = -2
                        end
                        if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
                            delta_num = delta_num/2
                        end
                        inst.components.hana_com_level_sys:PowerDoDelta(delta_num)
                    end)
                --------------------------------------------------------------------------------------------------------------
                ---- 添加对应的buff
                    local function add_debuff(debuff_prefab)
                        while true do
                            local debuff_inst = inst:GetDebuff(debuff_prefab)
                            if debuff_inst then
                                if debuff_inst:IsValid() then
                                    return
                                else
                                    debuff_inst:Remove()
                                end
                            end
                            inst:AddDebuff(debuff_prefab,debuff_prefab)
                        end
                    end
                    inst:ListenForEvent("hana_com_level_sys_power_dodelta",function(inst,_table)
                        local old_num = _table.old
                        local new_num = _table.new

                        if new_num > old_num and  new_num >= 30 then
                            add_debuff("underworld_hana_debuff_power_saniy_up_by_onhitother")
                        end

                        if  new_num > old_num and new_num >= 40 then
                            add_debuff("underworld_hana_debuff_power_saniy_mult")
                        end

                        if  new_num > old_num and new_num >= 60 then
                            add_debuff("underworld_hana_debuff_power_weapon_cost_half")
                        end

                        if  new_num > old_num and new_num >= 70 then
                            add_debuff("underworld_hana_debuff_power_health_up_by_onhitother")
                        end

                        ---- 80 点 的跳过

                        if  new_num > old_num and new_num >= 100 then
                            add_debuff("underworld_hana_debuff_power_skeleton_protect")
                        end

                    end)
                --------------------------------------------------------------------------------------------------------------
                ---- 不死权能触发 能量满点、20s 锁定
                    inst:ListenForEvent("hana_undead_authority_start", function()
                        inst.components.hana_com_level_sys:PowerDoDelta(1000)
                        inst.components.hana_com_level_sys:SetPowerDeltaLock(true)
                        inst:DoTaskInTime(20,function()
                            inst.components.hana_com_level_sys:SetPowerDeltaLock(false)                            
                        end)
                    end)
                --------------------------------------------------------------------------------------------------------------
                ----
                    inst:ListenForEvent("death", function()
                        inst.components.hana_com_level_sys:SetPowerDeltaLock(false)
                        inst.components.hana_com_level_sys:PowerDoDelta(-1000)
                    end)
                --------------------------------------------------------------------------------------------------------------





















    end)
end