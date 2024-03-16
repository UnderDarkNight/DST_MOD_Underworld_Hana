--------------------------------------------------------------------------------------------------------------------------------------------------
---- 模块总入口，使用 common_postinit 进行嵌入初始化，注意 mastersim 区分
--------------------------------------------------------------------------------------------------------------------------------------------------
return function(inst)

    if TheWorld.ismastersim then
        if inst.components.hana_com_data == nil then
            inst:AddComponent("hana_com_data") --- 通用用数据库
        end
        if inst.components.hana_com_rpc_event == nil then
            inst:AddComponent("hana_com_rpc_event") --- RPC 信道封装
        end
        if inst.components.hana_com_tag_sys == nil then
            inst:AddComponent("hana_com_tag_sys") --- 标签系统
        end
    end

    local modules = {
        "prefabs/01_character/underworld_hana_key_modules/01_animstate_hook",                      ---- 动画组件hook
        "prefabs/01_character/underworld_hana_key_modules/02_cloak_sys",                           ---- 披风系统
        "prefabs/01_character/underworld_hana_key_modules/03_spriter_sys",                              ---- 精灵系统
        "prefabs/01_character/underworld_hana_key_modules/04_builder_com_hook_for_tag_sys",         ---- builder 组件 hook

    }
    for k, lua_addr in pairs(modules) do
        local temp_fn = require(lua_addr)
        if type(temp_fn) == "function" then
            temp_fn(inst)
        end
    end


    inst:AddTag("underworld_hana")


    inst.customidleanim = "idle_wendy"  -- 闲置站立动画
    inst.soundsname = "wendy"           -- 角色声音

    inst:AddTag("stronggrip")      --- 不被打掉武器

    -- inst.AnimState:OverrideSymbol("wendy_idle_flower","underworld_hana_idle_flower","wendy_idle_flower")
    -- inst.AnimState:OverrideSymbol("wood_splinter","underworld_hana_hand_glass","wood_splinter")

    if not TheWorld.ismastersim then
        return
    end



end