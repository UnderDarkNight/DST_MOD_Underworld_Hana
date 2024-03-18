


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
            builder_tag = "underworld_hana",
            atlas = "images/inventoryimages/underworld_hana_weapon_scythe.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_weapon_scythe.tex",
        },
        {"CHARACTER","TOOLS","WEAPONS"}
    )
    RemoveRecipeFromFilter("underworld_hana_weapon_scythe","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 红莲刀
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_weapon_red_lotus","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_weapon_red_lotus",            --  --  inst.prefab  实体名字
        { Ingredient("redgem", 2),Ingredient("moonglass", 10),Ingredient("goldnugget", 5) }, 
        TECH.NONE, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            builder_tag = "underworld_hana",
            atlas = "images/inventoryimages/underworld_hana_weapon_red_lotus.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_weapon_red_lotus.tex",
        },
        {"CHARACTER","WEAPONS"}
    )
    RemoveRecipeFromFilter("underworld_hana_weapon_red_lotus","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 阿斯塔特
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_weapon_astartes","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_weapon_astartes",            --  --  inst.prefab  实体名字
        { Ingredient("bluegem", 2),Ingredient("moonglass", 10),Ingredient("ice", 10) }, 
        TECH.NONE, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            builder_tag = "underworld_hana",
            atlas = "images/inventoryimages/underworld_hana_weapon_astartes.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_weapon_astartes.tex",
        },
        {"CHARACTER","WEAPONS"}
    )
    RemoveRecipeFromFilter("underworld_hana_weapon_astartes","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 弥赛亚
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_weapon_messiah","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_weapon_messiah",            --  --  inst.prefab  实体名字
        { Ingredient("bluegem", 2),Ingredient("moonglass", 10),Ingredient("nightmarefuel", 10) }, 
        TECH.NONE, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            builder_tag = "underworld_hana",
            atlas = "images/inventoryimages/underworld_hana_weapon_messiah.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_weapon_messiah.tex",
        },
        {"CHARACTER","MAGIC","WEAPONS"}
    )
    RemoveRecipeFromFilter("underworld_hana_weapon_messiah","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------