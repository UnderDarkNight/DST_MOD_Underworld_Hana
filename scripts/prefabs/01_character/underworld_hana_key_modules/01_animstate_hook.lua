--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    本文件的作用： hook 进animstate 组件， 穿戴衣服/帽子 进行拦截。 玩家低San动画 拦截切换

    DoTaskInTime 0  进行了  userdata 转 table
    其他操作 延迟到 0.1

    只在服务端执行

    低San 的动画
    [00:17:43]: PlayAnimation	idle_sanity_pre	
    [00:17:43]: PushAnimation	idle_sanity_loop	
    [00:17:45]: PlayAnimation	idle_inaction_sanity	


    idle_inaction -- 挠头动画


]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end
    inst:DoTaskInTime(0.1, function()
        -------------------------------------------------------------------------
        --- 检查组件是否为 table
            if type(inst.AnimState) ~= "table" then
                print("Error : moonlightcoda animstate hook error")
                return
            end
        -------------------------------------------------------------------------
        --- PlayAnimation  PushAnimation
            --------------------------------------------------------
            --- 动画拦截 。 return true 的时候拦截，其他时候 进行替换
                local anim_block_with_fn = {
                    ["idle_sanity_pre"] = function(self,anim_name,push_flag)
                        return "idle_wendy"
                    end,
                    ["idle_sanity_loop"] = function(self,anim_name,push_flag)
                        return true
                    end,
                    ["idle_inaction_sanity"] = function(self,anim_name,push_flag)
                        return math.random()<0.7 and "idle_loop" or "idle_wendy"
                    end,
                    ["idle_inaction_lunacy"] = function(self,anim_name,push_flag)   --- 月岛上
                        return "idle_warly"
                    end,
                }
            --------------------------------------------------------

            local old_PlayAnimation = inst.AnimState.PlayAnimation
            inst.AnimState.PlayAnimation = function(self, anim_name,flag)
                if anim_block_with_fn[anim_name] then
                    local ret = anim_block_with_fn[anim_name](self,anim_name,false)
                    if ret == true then
                        return
                    else
                        anim_name = ret
                    end
                end
                -- print("PlayAnimation",anim_name)
                old_PlayAnimation(self, anim_name,flag)
            end


            local old_PushAnimation = inst.AnimState.PushAnimation
            inst.AnimState.PushAnimation = function(self, anim_name,flag)
                if anim_block_with_fn[anim_name] then
                    local ret = anim_block_with_fn[anim_name](self,anim_name,true)
                    if ret == true then
                        return
                    else
                        anim_name = ret
                    end
                end
                -- print("PushAnimation",anim_name)
                old_PushAnimation(self, anim_name,flag)
            end
        -------------------------------------------------------------------------
        --- 隐藏帽子/衣服
            -------------------------------------------------
            --- 清除帽子的API
                if TUNING["underworld_hana.Config"].HIDE_HAT then

                            local function ClearHat(hat_inst)
                                local owner = inst
                                if hat_inst then
                                    -- local skin_build = hat_inst:GetSkinBuild()
                                    -- if skin_build ~= nil then
                                    --     owner:PushEvent("unequipskinneditem", hat_inst:GetSkinName())
                                    -- end

                                    owner.AnimState:ClearOverrideSymbol("headbase_hat") --it might have been overriden by _onequip
                                    if owner.components.skinner ~= nil then
                                        owner.components.skinner.base_change_cb = owner.old_base_change_cb
                                    end


                                    owner.AnimState:ClearOverrideSymbol("swap_hat")
                                    owner.AnimState:Hide("HAT")
                                    owner.AnimState:Hide("HAIR_HAT")
                                    owner.AnimState:Show("HAIR_NOHAT")
                                    owner.AnimState:Show("HAIR")

                                    if owner:HasTag("player") then
                                        owner.AnimState:Show("HEAD")
                                        owner.AnimState:Hide("HEAD_HAT")
                                        owner.AnimState:Hide("HEAD_HAT_NOHELM")
                                        owner.AnimState:Hide("HEAD_HAT_HELM")
                                    end
                                    
                                end
                            end
                            inst:ListenForEvent("mcoda_clear_hat",function()
                                local hat_inst = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
                                ClearHat(hat_inst)
                            end)

                            inst:ListenForEvent("equip",function()
                                inst:PushEvent("mcoda_clear_hat")
                            end)
                            inst:PushEvent("mcoda_clear_hat")   --- 初始化的时候

                end
            -------------------------------------------------
            ---- 衣服  OverrideSymbol OverrideItemSkinSymbol
                if TUNING["underworld_hana.Config"].HIDE_CLOTHS then
                                ---- 屏蔽穿脱盔甲、项链
                                local function need_2_clear_body_layer(tar_layer,build,the_layer)
                                    if  tar_layer == "swap_body" or tar_layer == "swap_body_tall" or (tar_layer==nil and  build == nil and the_layer == nil) then
                                            -------------------------------------------------------
                    
                                            -------------------------------------------------------
                                            ----- 背重物
                                                if inst.replica.inventory:IsHeavyLifting() then
                                                    -- print("heavylifting",build)
                                                    return false
                                                end
                                            ------------------------------------------------------- 
                                            -------------------------------------------------------
                                            --- 蜗牛壳
                                                if inst.replica.inventory:EquipHasTag("shell") then
                                                    return false
                                                end
                                            -------------------------------------------------------
                                            --- 鼓
                                                if inst.replica.inventory:EquipHasTag("band") then
                                                    return false
                                                end
                                            -------------------------------------------------------
                                            -------------------------------------------------------
                                            return true
                    
                                    end
                                    return false
                                end

                                    local old_OverrideSymbol = inst.AnimState.OverrideSymbol
                                    inst.AnimState.OverrideSymbol = function(self,tar_layer,build,the_layer)                            
                                        old_OverrideSymbol(self,tar_layer,build,the_layer)
                                        inst:DoTaskInTime(0,function()
                                            if need_2_clear_body_layer(tar_layer,build,the_layer) then
                                                inst:PushEvent("mcoda_clear_body")
                                            end
                                        end)
                                    end

                                    local old_OverrideItemSkinSymbol = inst.AnimState.OverrideItemSkinSymbol
                                    inst.AnimState.OverrideItemSkinSymbol = function(self,tar_layer,skin_build,...)                            
                                        old_OverrideItemSkinSymbol(self,tar_layer,skin_build,...)
                                        inst:DoTaskInTime(0,function()
                                            if need_2_clear_body_layer(tar_layer,skin_build) then
                                                inst:PushEvent("mcoda_clear_body")
                                            end
                                        end)
                                    end
                                ----- 监听事件和清除
                                    inst:ListenForEvent("mcoda_clear_body",function()
                                            inst.AnimState:ClearOverrideSymbol("swap_body")
                                            inst.AnimState:ClearOverrideSymbol("swap_body_tall")
                                    end)
                                ----- 初始化的时候检查 
                                    if need_2_clear_body_layer() then
                                        inst:PushEvent("mcoda_clear_body")
                                    end
                end
            -------------------------------------------------
            

        -------------------------------------------------------------------------

    end)
end