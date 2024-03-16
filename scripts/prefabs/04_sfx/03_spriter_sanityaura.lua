------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()



    inst.AnimState:SetBank("cane")
    inst.AnimState:SetBuild("swap_cane")
    inst.AnimState:PlayAnimation("idle")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end



    inst:AddComponent("inspectable")
    ----------------------------------------------------------------------------------------------
    ---- 回San 光环。 30FPS 扫描 
    ---- local SANITYRECALC_CANT_TAGS = { "FX", "NOCLICK", "DECOR","INLIMBO" }  会被屏蔽
        inst:AddComponent("sanityaura")  
        inst.components.sanityaura.aurafn = function(inst,player)
            if player and player:HasTag("underworld_hana") then
                --- 回复量 1/min
                if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
                    return 1
                else
                    if TheWorld.state.isnight then
                        return 5/1800
                    else
                        return 1/1800
                    end
                end
            end
            return 0
        end
        -- inst.components.sanityaura.fallofffn = music_sanityfalloff_fn       --- 递减系数计算 fn
        inst.components.sanityaura.max_distsq = 10                               --- 最大半径
    ----------------------------------------------------------------------------------------------
    return inst
end

return Prefab("underworld_hana_fx_spriter_sanityaura", fn)
