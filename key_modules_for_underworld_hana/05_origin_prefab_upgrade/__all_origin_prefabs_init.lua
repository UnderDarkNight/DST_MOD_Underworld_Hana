-- -- 这个文件是给 modmain.lua 调用的总入口
-- -- 本lua 和 modmain.lua 平级
-- -- 子分类里有各自的入口
-- -- 注意文件路径


-- modimport("key_modules_for_underworld_hana/04_origin_prefab_upgrade/00_world_upgrade.lua")  --- TheWorld 组件

modimport("key_modules_for_underworld_hana/05_origin_prefab_upgrade/01_player_upgrade.lua")  --- 玩家组件

modimport("key_modules_for_underworld_hana/05_origin_prefab_upgrade/02_monster_ghost.lua")  --- 幽灵怪物

modimport("key_modules_for_underworld_hana/05_origin_prefab_upgrade/03_cursed_monkey_token.lua")  --- 猴子诅咒物品

modimport("key_modules_for_underworld_hana/05_origin_prefab_upgrade/04_focalpoint_sound_hook.lua")  --- client端事件控制器hook

modimport("key_modules_for_underworld_hana/05_origin_prefab_upgrade/05_boss_drop_blueprint.lua")  --- Boss 掉落


