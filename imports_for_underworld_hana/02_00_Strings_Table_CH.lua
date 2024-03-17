if TUNING["underworld_hana.Strings"] == nil then
    TUNING["underworld_hana.Strings"] = {}
end

local this_language = "ch"
-- if TUNING["underworld_hana.Language"] then
--     if type(TUNING["underworld_hana.Language"]) == "function" and TUNING["underworld_hana.Language"]() ~= this_language then
--         return
--     elseif type(TUNING["underworld_hana.Language"]) == "string" and TUNING["underworld_hana.Language"] ~= this_language then
--         return
--     end
-- end

--------- 默认加载中文文本，如果其他语言的文本缺失，直接调取 中文文本。 03_TUNING_Common_Func.lua
--------------------------------------------------------------------------------------------------
--- 默认显示名字:  name
--- 默认显示描述:  inspect_str
--- 默认制作栏描述: recipe_desc
--------------------------------------------------------------------------------------------------
TUNING["underworld_hana.Strings"][this_language] = TUNING["underworld_hana.Strings"][this_language] or {
        --------------------------------------------------------------------
        --- 正在debug 测试的
            ["underworld_hana_skin_test_item"] = {
                ["name"] = "皮肤测试物品",
                ["inspect_str"] = "inspect单纯的测试皮肤",
                ["recipe_desc"] = "测试描述666",
            },
        --------------------------------------------------------------------
        --- 组件动作
           
        --------------------------------------------------------------------
        --- 02_items
            ["underworld_hana_item_faded_memory"] = {
                ["name"] = "褪色的记忆",
                ["inspect_str"] = "褪色的记忆",
                ["recipe_desc"] = "褪色的记忆",
            },
        --------------------------------------------------------------------
        --- 03_equipments
            ["underworld_hana_equipment_cloak_1"] = {
                ["name"] = "冥界使者的披风",
                ["inspect_str"] = "冥界使者的披风",
                ["recipe_desc"] = "冥界使者的披风",
            },
            ["underworld_hana_equipment_cloak_2"] = {
                ["name"] = "冥界使者的披风",
                ["inspect_str"] = "冥界使者的披风",
                ["recipe_desc"] = "冥界使者的披风",
            },
            ["underworld_hana_equipment_cloak_3"] = {
                ["name"] = "冥界使者的披风",
                ["inspect_str"] = "冥界使者的披风",
                ["recipe_desc"] = "冥界使者的披风",
            },
            ["underworld_hana_weapon_scythe"] = {
                ["name"] = "冥界之镰",
                ["inspect_str"] = "砍树挖矿一流",
                ["recipe_desc"] = "砍树挖矿一流",
                ["action_str"] = "冥界之舞"
            },
            ["underworld_hana_weapon_red_lotus"] = {
                ["name"] = "红莲",
                ["inspect_str"] = "充满火焰的菜刀",
                ["recipe_desc"] = "充满火焰的菜刀",
                ["action_str"] = "放火"
            },
        --------------------------------------------------------------------
}

