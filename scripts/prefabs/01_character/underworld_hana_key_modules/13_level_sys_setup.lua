--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【只能通过【褪色的记忆】【幸福的记忆】增加】【角色死亡后等级-15】
            【达到5点时解锁【哈娜的礼物】的制作】
                【达到15点时解锁【冲破禁锢】的制作】
                【达到25点时解锁【冥界使者的蝴蝶结】的制作】
                【达到35点时获得10%砍树挖矿效率和0.1攻击系数提升】
                【达到45点时哈娜将取消【笨手笨脚的死神】的负面效果】

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 根据等级执行
    local server_side_level_update_fn = function(inst,com,level)
        ----------------------------------------------------------------------------------------
        --- 【达到5点时解锁【哈娜的礼物】的制作】
            if level >=5 then
                inst.components.hana_com_tag_sys:AddTag("unlock.underworld_hana_weapon_gift")
            else
                inst.components.hana_com_tag_sys:RemoveTag("unlock.underworld_hana_weapon_gift")
            end
        ----------------------------------------------------------------------------------------
        --- 【达到15点时解锁【冲破禁锢】的制作】
            if level >=15 then
                inst.components.hana_com_tag_sys:AddTag("unlock.underworld_hana_weapon_scythe_overcome_confinement")
            else
                inst.components.hana_com_tag_sys:RemoveTag("unlock.underworld_hana_weapon_scythe_overcome_confinement")
            end
        ----------------------------------------------------------------------------------------
        --- 【达到25点时解锁【冥界使者的蝴蝶结】的制作】
            if level >=25 then
                inst.components.hana_com_tag_sys:AddTag("unlock.underworld_hana_equipment_bow")
            else
                inst.components.hana_com_tag_sys:RemoveTag("unlock.underworld_hana_equipment_bow")
            end
        ----------------------------------------------------------------------------------------
        --- 【达到35点时获得10%砍树挖矿效率和0.1攻击系数提升】
            if level >=35 then
                inst:AddTag("woodcutter")
                inst.components.combat.damagemultiplier = 1.1
            else
                inst:RemoveTag("woodcutter")
                inst.components.combat.damagemultiplier = 1
            end
        ----------------------------------------------------------------------------------------
        --- 【达到45点时哈娜将取消【笨手笨脚的死神】的负面效果】
            if level >=45 then
                inst.components.hana_com_tag_sys:RemoveTag("clumsy")
            else
                inst.components.hana_com_tag_sys:AddTag("clumsy")
            end
        ----------------------------------------------------------------------------------------

    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)

    if not TheWorld.ismastersim then
        return
    end

    inst:ListenForEvent("underworld_hana_master_postinit",function()
        -------------------------------------------------------------------------------------------
            inst:AddComponent("hana_com_level_sys")
            ------------ 每个等级都执行的刷新函数
                inst.components.hana_com_level_sys:SetLevelUpdateFn(function(inst,com,level)
                    print("server side  level change to",level)
                    server_side_level_update_fn(inst,com,level)
                end)
                inst.components.hana_com_level_sys:AddOnLoadFn(function() --- onload 时候刷新
                    inst:DoTaskInTime(1,function()
                        local com = inst.components.hana_com_level_sys
                        local level = com:GetLevel()
                        server_side_level_update_fn(inst,com,level)
                    end)
                end)
            ------------- 死亡掉级
                inst:ListenForEvent("death",function()
                    inst.components.hana_com_level_sys:LevelDoDelta(-15)
                end)
        -------------------------------------------------------------------------------------------
    end)

end