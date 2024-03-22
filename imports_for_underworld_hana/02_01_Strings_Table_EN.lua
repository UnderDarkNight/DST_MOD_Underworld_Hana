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
            ["underworld_hana_weapon_deep_love"] = {
                ["name"] = "Deep Love",
                ["inspect_str"] = "A very special staff.",
                ["recipe_desc"] = "A very special staff.",
                ["spell_str"] = "Jump Split",
                ["unlock_str"] = "Unlock Spell",

            },
            ["underworld_hana_weapon_innocent"] = {
                ["name"] = "Innocent",
                ["inspect_str"] = "An exquisite umbrella",
                ["recipe_desc"] = "An exquisite umbrella",
                ["spell_str"] = "Unfolding",
            },
            ["underworld_hana_weapon_irradiance"] = {
                ["name"] = "Irradiance",
                ["inspect_str"] = "An exquisite umbrella",
                ["recipe_desc"] = "An exquisite umbrella",
                ["spell_str"] = "Folding",
            },
            ["underworld_hana_equipment_bow"] = {
                ["name"] = "Hana's Bow",
                ["inspect_str"] = "Hana's Bow",
                ["recipe_desc"] = "Hana's Bow",
                ["action_str"] = "Switch",
            },
            ["underworld_hana_equipment_panda_brooch"] = {
                ["name"] = "Crazy Panda Brooch",
                ["inspect_str"] = "Crazy Panda Brooch",
                ["recipe_desc"] = "Crazy Panda Brooch",
            },
            ["underworld_hana_equipment_great_earth_brooch"] = {
                ["name"] = "Great Earth Brooch",
                ["inspect_str"] = "Great Earth Brooch",
                ["recipe_desc"] = "Great Earth Brooch",
            },
            ["underworld_hana_equipment_ice_queen_ring"] = {
                ["name"] = "The Ice Queen's Ring",
                ["inspect_str"] = "The Ice Queen's Ring",
                ["recipe_desc"] = "The Ice Queen's Ring",
            },
            ["underworld_hana_weapon_minotaur_shield"] = {
                ["name"] = "Minotaur's Shield",
                ["inspect_str"] = "Minotaur's Shield",
                ["recipe_desc"] = "Minotaur's Shield",
                ["accept_str"] = "Extend skill time",
            },
            ["underworld_hana_weapon_legionnaire_magic_mirror_shield"] = {
                ["name"] = "Legionnaire's Mirror Shield",
                ["inspect_str"] = "Legionnaire's Mirror Shield",
                ["recipe_desc"] = "Legionnaire's Mirror Shield",
                ["accept_str"] = "Extend skill time",
            },
            ["underworld_hana_weapon_gift"] = {
                ["name"] = "Hana's Gift",
                ["inspect_str"] = "Hana's Gift",
                ["recipe_desc"] = "Hana's Gift",
            },
        --------------------------------------------------------------------

}