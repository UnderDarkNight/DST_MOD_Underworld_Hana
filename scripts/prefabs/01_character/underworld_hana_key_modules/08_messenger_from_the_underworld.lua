--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    2.【机制】【冥界的使者】：
    【完成】【不会被猴子诅咒影响】
        【对暗影和月亮盟友造成的伤害都提升5%】
        【比普通的角色更容易干燥】  moisture
        【过热的温度比普通角色都增加5度】
        （＞75°）

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end


    -------------------------------------------------------------------------------------------
    --- 对两个阵营都增加伤害
        inst:AddComponent("damagetypebonus")
        inst.components.damagetypebonus:AddBonus("shadow_aligned", inst, 1.05)  --- 对暗影阵营增伤
        inst.components.damagetypebonus:AddBonus("lunar_aligned", inst, 1.05)   --- 对月亮阵营增伤

    -------------------------------------------------------------------------------------------
    --- moisture 潮湿度下降加速
        inst:ListenForEvent("underworld_hana_master_postinit",function()
            local old_DoDelta = inst.components.moisture.DoDelta
            inst.components.moisture.DoDelta = function(self, num,...)
                if num < 0 then
                    num = num*3
                end
                old_DoDelta(self, num,...)
            end
        end)
    -------------------------------------------------------------------------------------------
    ---- 【过热的温度比普通角色都增加5度】
        inst:ListenForEvent("underworld_hana_master_postinit",function()
            inst.components.temperature.overheattemp = TUNING.OVERHEAT_TEMP + 5
        end)
    -------------------------------------------------------------------------------------------


end