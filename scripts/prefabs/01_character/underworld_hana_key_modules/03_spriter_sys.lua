--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    环绕的精灵

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:DoTaskInTime(0,function()




                    -- local spriter_big = SpawnPrefab("underworld_hana_fx_spriter_big")
                    -- spriter_big.components.underworld_hana_com_linearcircler:SetCircleTarget(inst)
                    -- spriter_big.components.underworld_hana_com_linearcircler:Start()
                    -- spriter_big.components.underworld_hana_com_linearcircler.randAng = 0.125
                    -- spriter_big.components.underworld_hana_com_linearcircler.clockwise = math.random(100) < 50
                    -- spriter_big.components.underworld_hana_com_linearcircler.distance_limit = 2.5
                    -- spriter_big.components.underworld_hana_com_linearcircler.setspeed = 0.2



                    -- inst:ListenForEvent("onremove",function()
                    --     spriter_big:Remove()
                    -- end)

                    inst:ListenForEvent("hana_big_spriter.hide",function()
                        if inst.__hana_green_spriter then
                            inst.__hana_green_spriter:Remove()
                            inst.__hana_green_spriter = nil
                        end
                    end)
                    inst:ListenForEvent("hana_big_spriter.show",function()
                        if inst.__hana_green_spriter then
                            inst.__hana_green_spriter:Remove()
                        end

                        if inst:HasTag("playerghost") then
                            return
                        end
                        
                        inst.__hana_green_spriter = SpawnPrefab("underworld_hana_fx_spriter_big")
                        inst.__hana_green_spriter:PushEvent("Set",{
                            player = inst,  --- 跟随目标
                            range = 3,           --- 环绕点半径
                            point_num = 15,       --- 环绕点
                            -- new_pt_time = 0.5 ,    --- 新的跟踪点时间
                            -- speed = 8,           --- 强制固定速度
                            speed_mult = 2,      --- 速度倍速
                            next_pt_dis = 0.5,      --- 触碰下一个点的距离
                            speed_soft_delta = 20, --- 软增加
                            y = 1.5,
                            tail_time = 0.2,
                        })
                        ----------------------------------------------------------------------------------------
                        ---- 回 San 光环
                            local sanityaura_inst = inst:SpawnChild("underworld_hana_fx_spriter_sanityaura")
                            sanityaura_inst:Hide()
                            inst.__hana_green_spriter:ListenForEvent("onremove",function()
                                sanityaura_inst:Remove()
                            end)
                        ----------------------------------------------------------------------------------------

                    end)



                    local spriter_mini_fx = SpawnPrefab("underworld_hana_fx_spriter_mini")
                    spriter_mini_fx.entity:SetParent(inst.entity)
                    spriter_mini_fx.entity:AddFollower()
                    spriter_mini_fx.Follower:FollowSymbol(inst.GUID, "swap_object", 0, 0, 0)


                    local function spriter_mini_fx_init()
                        local weapon = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
                        if weapon then
                            spriter_mini_fx:Show()
                            inst:PushEvent("hana_big_spriter.hide")
                        else
                            spriter_mini_fx:Hide()
                            inst:PushEvent("hana_big_spriter.show")
                        end
                    end
                    spriter_mini_fx_init()
                    inst:ListenForEvent("unequip",spriter_mini_fx_init)
                    inst:ListenForEvent("equip",spriter_mini_fx_init)


                    inst:ListenForEvent("ms_becameghost",function()
                        inst:DoTaskInTime(0,function()
                            inst:PushEvent("hana_big_spriter.hide")
                        end)
                    end)
                    inst:ListenForEvent("ms_respawnedfromghost",function()
                        inst:DoTaskInTime(5,spriter_mini_fx_init)
                    end)
    end)


end