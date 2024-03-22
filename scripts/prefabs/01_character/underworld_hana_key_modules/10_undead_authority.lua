--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

4.【机制】【不死的权能】:
    【血量为0时进入，攻击力和移速都提高30％，持续10s】
    【立即回复10%的血量和10%san值，并进入无敌状态，无敌状态持续4s】
    【【不死的权能】触发后10s内温度锁定在20°】
    【该机制60s冷却】

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end

    local cd_time_index = "undead_authority_cd_time"
    local cd_time_task = nil
    local function cd_time_down_task_start(cd_time)
        if cd_time_task then
            cd_time_task:Cancel()
        end
        if cd_time then
            inst.components.hana_com_data:Set(cd_time_index,cd_time)            
        end
        cd_time_task = inst:DoPeriodicTask(1,function()
            local temp_time = inst.components.hana_com_data:Add(cd_time_index,-1)
            if temp_time <= 0 then
                cd_time_task:Cancel()
                cd_time_task = nil
            end
        end)
    end
    inst.components.hana_com_data:AddOnLoadFn(function(com) ---- 存档重载的时候 继续开启 cd 计时器
        if com:Add(cd_time_index,0) >= 0 then
            cd_time_down_task_start()
        end
    end)

    inst:ListenForEvent("minhealth",function(inst)
        local cd_time = inst.components.hana_com_data:Add(cd_time_index,0)
        if cd_time >= 0 then
            return
        end
        ----------------------------------------------------------------
        ---- 启动计时器
            cd_time_down_task_start(60)
        ----------------------------------------------------------------
        ---- 恢复血量和San
            inst.components.health:SetPercent(0.1)
            local sanity_percent = inst.components.sanity:GetPercentWithPenalty()
            inst.components.sanity:SetPercent(sanity_percent + 0.1)
        ----------------------------------------------------------------
        ---- 添加buff
            while true do
                local debuff_inst = inst:GetDebuff("underworld_hana_debuff_reinforcement")
                if debuff_inst == nil or not debuff_inst:IsValid() then
                    inst:AddDebuff("underworld_hana_debuff_reinforcement","underworld_hana_debuff_reinforcement")
                else
                    break    
                end
            end
        ----------------------------------------------------------------
        ----- 锁定玩家温度
            for i = 1, 20, 1 do
                inst:DoTaskInTime(i*0.5,function()
                    inst.components.temperature:SetTemperature(20)
                end)
            end
        ----------------------------------------------------------------

    end)


end