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
            ["underworld_hana_equipment_cloak_1"] = {
                ["name"] = "Hana's Cloak",
                ["inspect_str"] = "Hana's Cloak",
                ["recipe_desc"] = "Hana's Cloak",
            },
            ["underworld_hana_equipment_cloak_2"] = {
                ["name"] = "Hana's Cloak",
                ["inspect_str"] = "Hana's Cloak",
                ["recipe_desc"] = "Hana's Cloak",
            },
            ["underworld_hana_equipment_cloak_3"] = {
                ["name"] = "Hana's Cloak",
                ["inspect_str"] = "Hana's Cloak",
                ["recipe_desc"] = "Hana's Cloak",
            },
            ["underworld_hana_weapon_scythe"] = {
                ["name"] = "Scythe From Underworld",
                ["inspect_str"] = "Chopping down trees and mining is first class",
                ["recipe_desc"] = "Chopping down trees and mining is first class",
                ["action_str"] = STRINGS.ACTIONS.SCYTHE,
            },
            ["underworld_hana_weapon_red_lotus"] = {
                ["name"] = "Red lotus",
                ["inspect_str"] = "Flame-filled chopper",
                ["recipe_desc"] = "Flame-filled chopper",
                ["spell_str"] = "Commit Arson",
                ["unlock_str"] = "Unlock Spell",
            },
            ["underworld_hana_weapon_astartes"] = {
                ["name"] = "Astartes",
                ["inspect_str"] = "With the power of the water element",
                ["recipe_desc"] = "With the power of the water element",
                ["spell_str"] = "Cast Spell",
                ["spell_str_a"] = "Blow up the sea",
                ["spell_str_b"] = "Active Buff",
                ["unlock_str"] = "Unlock Spell",
            },
            ["underworld_hana_weapon_messiah"] = {
                ["name"] = "Messiah",
                ["inspect_str"] = "A very special staff.",
                ["recipe_desc"] = "A very special staff.",
                ["spell_str"] = "Cast Spell",
                ["unlock_str"] = "Unlock Spell",

            },
        --------------------------------------------------------------------

}