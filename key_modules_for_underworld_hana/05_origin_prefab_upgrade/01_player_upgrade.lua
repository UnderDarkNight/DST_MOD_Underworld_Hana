-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



AddPlayerPostInit(function(inst)

    ----------------------------------------------------------------------------------------------------------------
    --- RPC 组件
        if TheWorld.ismastersim then
            if inst.components.hana_com_rpc_event == nil then
                inst:AddComponent("hana_com_rpc_event")
            end
        end
    ----------------------------------------------------------------------------------------------------------------
    --- tag 组件
        if TheWorld.ismastersim then
            if inst.components.hana_com_tag_sys == nil then
                inst:AddComponent("hana_com_tag_sys")
            end
        end
    ----------------------------------------------------------------------------------------------------------------
    ---- 坐标跳跃
        if not TheNet:IsDedicated() then --- 加在客户端
            inst:ListenForEvent("underworld_hana_event.player_teleport_client", function(inst,_table)
                if not (_table and _table.pt )then
                    return
                end
                -- print("info underworld_hana_event.player_teleport",_table.pt)
                local x,y,z = _table.pt.x,_table.pt.y,_table.pt.z
                if inst.Physics then
                    inst.Physics:Teleport(x,y,z)
                end
                inst.Transform:SetPosition(x,y,z)
            end)
        end
        if TheWorld.ismastersim then
            inst:ListenForEvent("underworld_hana_event.player_teleport", function(inst,_table)
                if not (_table and _table.pt )then
                    return
                end
                local x,y,z = _table.pt.x,_table.pt.y,_table.pt.z
                if inst.Physics then
                    inst.Physics:Teleport(x,y,z)
                end
                inst.Transform:SetPosition(x,y,z)
                inst.components.hana_com_rpc_event:PushEvent("underworld_hana_event.player_teleport_client",{pt = Vector3(x,y,z)})
            end)
        end
    ----------------------------------------------------------------------------------------------------------------
    ---- 武器CD modifier
        if TheWorld.ismastersim then
            inst:AddComponent("hana_com_spell_cd_modifier")
        end
    ----------------------------------------------------------------------------------------------------------------
end)
