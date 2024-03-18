-- -- 这个文件是给 modmain.lua 调用的总入口
-- -- 本lua 和 modmain.lua 平级
-- -- 子分类里有各自的入口
-- -- 注意文件路径


modimport("key_modules_for_moonlightcoda/03_origin_components_upgrade/01_inventoryitem.lua")  --- 给所有物品上交互

modimport("key_modules_for_moonlightcoda/03_origin_components_upgrade/02_healer.lua")  --- 所有官方治疗物 hook

modimport("key_modules_for_moonlightcoda/03_origin_components_upgrade/03_transparentonsanity.lua")  --- 影怪可见组件（client side only)

modimport("key_modules_for_moonlightcoda/03_origin_components_upgrade/04_sanity.lua")  --- sanity 组件修改
modimport("key_modules_for_moonlightcoda/03_origin_components_upgrade/05_health.lua")  --- health 组件修改
