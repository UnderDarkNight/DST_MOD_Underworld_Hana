


--------------------------------------------------------------------------------------------------------------------------------------------
---- 幸福的记忆
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_item_blissful_memory","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_item_blissful_memory",            --  --  inst.prefab  实体名字
        { Ingredient("underworld_hana_item_faded_memory", 5) }, 
        TECH.NONE, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            builder_tag = "underworld_hana",
            atlas = "images/inventoryimages/underworld_hana_item_blissful_memory.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_item_blissful_memory.tex",
        },
        {"CHARACTER"}
    )
    RemoveRecipeFromFilter("underworld_hana_item_blissful_memory","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 哈娜的礼物
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_weapon_gift","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_weapon_gift",            --  --  inst.prefab  实体名字
        { Ingredient("underworld_hana_item_blissful_memory", 1) }, 
        TECH.NONE, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            builder_tag = "unlock.underworld_hana_weapon_gift",
            atlas = "images/inventoryimages/underworld_hana_weapon_gift.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_weapon_gift.tex",
        },
        {"CHARACTER","TOOLS","RESTORATION","MAGIC"}
    )
    RemoveRecipeFromFilter("underworld_hana_weapon_gift","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 冥界之镰
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_weapon_scythe","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_weapon_scythe",            --  --  inst.prefab  实体名字
        { Ingredient("pickaxe", 1),Ingredient("rocks", 3),Ingredient("twigs", 2), }, 
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
---- 冲破禁锢
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_weapon_scythe_overcome_confinement","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_weapon_scythe_overcome_confinement",            --  --  inst.prefab  实体名字
        { Ingredient("underworld_hana_weapon_scythe", 1),Ingredient("purplegem", 2),Ingredient("nightmarefuel", 5), }, 
        TECH.NONE, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            builder_tag = "unlock.underworld_hana_weapon_scythe_overcome_confinement",
            atlas = "images/inventoryimages/underworld_hana_weapon_scythe_overcome_confinement.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_weapon_scythe_overcome_confinement.tex",
        },
        {"CHARACTER","TOOLS","WEAPONS"}
    )
    RemoveRecipeFromFilter("underworld_hana_weapon_scythe_overcome_confinement","MODS")                       -- -- 在【模组物品】标签里移除这个。
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
---- 爱之深
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_weapon_deep_love","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_weapon_deep_love",            --  --  inst.prefab  实体名字
        { Ingredient("livinglog", 2),Ingredient("steelwool", 1),Ingredient("goldnugget", 5) }, 
        TECH.NONE, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            builder_tag = "underworld_hana",
            atlas = "images/inventoryimages/underworld_hana_weapon_deep_love.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_weapon_deep_love.tex",
        },
        {"CHARACTER","WEAPONS"}
    )
    RemoveRecipeFromFilter("underworld_hana_weapon_deep_love","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 无邪
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_weapon_innocent","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_weapon_innocent",            --  --  inst.prefab  实体名字
        { Ingredient("yellowgem", 1),Ingredient("thulecite", 2),Ingredient("dragon_scales", 2) }, 
        TECH.NONE, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            builder_tag = "underworld_hana",
            atlas = "images/inventoryimages/underworld_hana_weapon_innocent.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_weapon_innocent.tex",
        },
        {"CHARACTER","WEAPONS"}
    )
    RemoveRecipeFromFilter("underworld_hana_weapon_innocent","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 蝴蝶结
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_equipment_bow","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_equipment_bow",            --  --  inst.prefab  实体名字
        { Ingredient("underworld_hana_item_blissful_memory", 1),Ingredient("opalpreciousgem", 1) }, 
        TECH.NONE, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            builder_tag = "unlock.underworld_hana_equipment_bow",
            atlas = "images/inventoryimages/underworld_hana_equipment_bow.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_equipment_bow.tex",
        },
        {"CHARACTER","MAGIC"}
    )
    RemoveRecipeFromFilter("underworld_hana_equipment_bow","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 熊猫胸针
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_equipment_panda_brooch","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_equipment_panda_brooch",            --  --  inst.prefab  实体名字
        { Ingredient("goldnugget", 8),Ingredient("yellowgem", 1),Ingredient("thulecite_pieces", 3) }, 
        TECH.LOST, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            -- builder_tag = "player",
            atlas = "images/inventoryimages/underworld_hana_equipment_panda_brooch.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_equipment_panda_brooch.tex",
        },
        {"CHARACTER","MAGIC"}
    )
    RemoveRecipeFromFilter("underworld_hana_equipment_panda_brooch","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 大地胸针
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_equipment_great_earth_brooch","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_equipment_great_earth_brooch",            --  --  inst.prefab  实体名字
        { Ingredient("greengem", 1),Ingredient("dreadstone", 3),Ingredient("livinglog", 2) }, 
        TECH.LOST, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            -- builder_tag = "player",
            atlas = "images/inventoryimages/underworld_hana_equipment_great_earth_brooch.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_equipment_great_earth_brooch.tex",
        },
        {"CHARACTER","MAGIC"}
    )
    RemoveRecipeFromFilter("underworld_hana_equipment_great_earth_brooch","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 冰雪女王指环
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_equipment_ice_queen_ring","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_equipment_ice_queen_ring",            --  --  inst.prefab  实体名字
        { Ingredient("bluegem", 3),Ingredient("wormlight", 1),Ingredient("malbatross_feather", 1) }, 
        TECH.LOST, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            -- builder_tag = "player",
            atlas = "images/inventoryimages/underworld_hana_equipment_ice_queen_ring.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_equipment_ice_queen_ring.tex",
        },
        {"CHARACTER","MAGIC"}
    )
    RemoveRecipeFromFilter("underworld_hana_equipment_ice_queen_ring","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 牛头人盾牌
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_weapon_minotaur_shield","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_weapon_minotaur_shield",            --  --  inst.prefab  实体名字
        { Ingredient("marble", 3),Ingredient("redgem", 1),Ingredient("moonrocknugget", 3),Ingredient("goldnugget", 3) }, 
        TECH.LOST, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            -- builder_tag = "player",
            atlas = "images/inventoryimages/underworld_hana_weapon_minotaur_shield.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_weapon_minotaur_shield.tex",
        },
        {"CHARACTER","ARMOUR","WEAPONS"}
    )
    RemoveRecipeFromFilter("underworld_hana_weapon_minotaur_shield","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------
---- 军长魔镜盾
--------------------------------------------------------------------------------------------------------------------------------------------
    AddRecipeToFilter("underworld_hana_weapon_legionnaire_magic_mirror_shield","CHARACTER")     ---- 添加物品到目标标签
    AddRecipe2(
        "underworld_hana_weapon_legionnaire_magic_mirror_shield",            --  --  inst.prefab  实体名字
        { Ingredient("moonglass", 5),Ingredient("purplegem", 1),Ingredient("nightmarefuel", 5) }, 
        TECH.LOST, 
        {
            -- no_deconstruction=true,
            -- numtogive = 3,
            -- builder_tag = "player",
            atlas = "images/inventoryimages/underworld_hana_weapon_legionnaire_magic_mirror_shield.xml",
            -- atlas = GetInventoryItemAtlas("dock_kit.tex"),
            image = "underworld_hana_weapon_legionnaire_magic_mirror_shield.tex",
        },
        {"CHARACTER","ARMOUR","WEAPONS"}
    )
    RemoveRecipeFromFilter("underworld_hana_weapon_legionnaire_magic_mirror_shield","MODS")                       -- -- 在【模组物品】标签里移除这个。
--------------------------------------------------------------------------------------------------------------------------------------------