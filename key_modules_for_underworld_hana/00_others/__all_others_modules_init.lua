-- -- 这个文件是给 modmain.lua 调用的总入口
-- -- 本lua 和 modmain.lua 平级
-- -- 子分类里有各自的入口
-- -- 注意文件路径


modimport("key_modules_for_underworld_hana/00_others/01_equipment_type.lua")  --- 自动兼容护甲类型

modimport("key_modules_for_underworld_hana/00_others/02_replica_register.lua")  --- replica 注册

modimport("key_modules_for_underworld_hana/00_others/03_rpc_register.lua")  --- RPC 信道 注册

modimport("key_modules_for_underworld_hana/00_others/04_tag_sys_rpc_register.lua")  --- 独立tag 系统 RPC 信道 注册
