if TUNING["underworld_hana.Strings"] == nil then
    TUNING["underworld_hana.Strings"] = {}
end

local this_language = "en"
if TUNING["underworld_hana.Language"] then
    if type(TUNING["underworld_hana.Language"]) == "function" and TUNING["underworld_hana.Language"]() ~= this_language then
        return
    elseif type(TUNING["underworld_hana.Language"]) == "string" and TUNING["underworld_hana.Language"] ~= this_language then
        return
    end
end

TUNING["underworld_hana.Strings"][this_language] = TUNING["underworld_hana.Strings"][this_language] or {
        --------------------------------------------------------------------
        --- 正在debug 测试的
            -- ["underworld_hana_skin_test_item"] = {
            --     ["name"] = "en皮肤测试物品",
            --     ["inspect_str"] = "en inspect单纯的测试皮肤",
            --     ["recipe_desc"] = " en 测试描述666",
            -- },        
        --------------------------------------------------------------------
        --- 03_equipments
            ["underworld_hana_weapon_scythe"] = {
                ["name"] = "Scythe From Underworld",
                ["inspect_str"] = "砍树挖矿一流",
                ["recipe_desc"] = "砍树挖矿一流",
            },
        --------------------------------------------------------------------

}