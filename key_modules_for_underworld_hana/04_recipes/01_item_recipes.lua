


--------------------------------------------------------------------------------------------------------------------------------------------
---- 冥界之镰
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_weapon_scythe","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_weapon_scythe",            --  --  inst.prefab  实体名字
        { Ingredient("boards", 4) }, 
        TECH.NONE, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            builder_tag = "my_test_tag",
            atlas = "images/inventoryimages/underworld_hana_weapon_scythe.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_weapon_scythe.tex",
        },
        {"CHARACTER","SEAFARING"}
    )
    RemoveRecipeFromFilter("underworld_hana_weapon_scythe","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------