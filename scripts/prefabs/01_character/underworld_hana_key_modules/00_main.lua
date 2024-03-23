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
        "prefabs/01_character/underworld_hana_key_modules/01_animstate_hook",                       ---- 动画组件hook
        "prefabs/01_character/underworld_hana_key_modules/02_cloak_sys",                            ---- 披风系统
        "prefabs/01_character/underworld_hana_key_modules/03_spriter_sys",                          ---- 精灵系统
        "prefabs/01_character/underworld_hana_key_modules/04_builder_com_hook_for_tag_sys",         ---- builder 组件 hook
        "prefabs/01_character/underworld_hana_key_modules/05_memory_sys",                           ---- 褪色的记忆/幸福的记忆
        "prefabs/01_character/underworld_hana_key_modules/06_the_curse_of_doom",                    ---- 厄运的诅咒
        "prefabs/01_character/underworld_hana_key_modules/07_graveyard_sanity",                     ---- 坟区 不掉San
        "prefabs/01_character/underworld_hana_key_modules/08_messenger_from_the_underworld",        ---- 冥界的使者 BUFF
        "prefabs/01_character/underworld_hana_key_modules/09_cooking",                              ---- 烹饪相关
        "prefabs/01_character/underworld_hana_key_modules/10_undead_authority",                     ---- 不死权能
        "prefabs/01_character/underworld_hana_key_modules/11_combat",                               ---- 战斗组件
        "prefabs/01_character/underworld_hana_key_modules/12_overcome_confinement_ui",              ---- 冲破禁锢的UI
        "prefabs/01_character/underworld_hana_key_modules/13_level_sys_setup",                      ---- 等级系统安装
        "prefabs/01_character/underworld_hana_key_modules/14_level_and_power_ui_setup",             ---- 等级、能量系统UI安装
        "prefabs/01_character/underworld_hana_key_modules/15_power_battle_sys",                     ---- 战斗能量值系统
        "prefabs/01_character/underworld_hana_key_modules/16_inventory_apply_damage_hook_for_buff", ---- hook API 给屏蔽伤害

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