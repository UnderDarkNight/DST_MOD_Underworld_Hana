----------------------------------------------------
--- 本文件单纯返还路径
----------------------------------------------------

-- local function sum(a, b)
--     return a + b
-- end

-- local info = debug.getinfo(sum)

-- for k,v in pairs(info) do
--         print(k,':', info[k])
-- end

--------------------------------------------------------------------------
local addr_test = debug.getinfo(1).source           ---- 找到绝对路径

local temp_str_index = string.find(addr_test, "scripts/prefabs/")
local temp_addr = string.sub(addr_test,temp_str_index,-1)
-- print("fake error 6666666666666:",temp_addr)    ---- 找到本文件所处的相对路径

local temp_str_index2 = string.find(temp_addr,"/__prefabs_list.lua")

local Prefabs_addr_base = string.sub(temp_addr,1,temp_str_index2) .. "/"    --- 得到最终文件夹路径

---------------------------------------------------------------------------
-- local Prefabs_addr_base = "scripts/prefabs/01_underworld_hana_items/"               --- 文件夹路径
local prefabs_name_list = {


    "01_cloak",                             --- 披风
    "02_scythe",                            --- 冥界之镰
    "03_red_lotus",                         --- 红莲刀
    "04_astartes",                          --- 阿斯塔特
    "05_messiah",                           --- 弥赛亚
    "06_deep_love",                         --- 爱之深
    "07_innocent",                          --- 无邪
    "08_irradiance",                        --- 辐光
    "09_bow",                               --- 蝴蝶结
    "10_panda_brooch",                      --- 疯狂熊猫胸针
    "11_great_earth_brooch",                --- 大地胸针
    "12_ice_queen_ring",                    --- 冰雪女王的戒指
    "13_minotaur_shield",                   --- 牛头人盾牌
    "14_legionnaire_magic_mirror_shield",   --- 军长魔镜盾
    "15_gift",                              --- 哈娜的礼物
    "16_overcome_confinement",              --- 冲破禁锢

}

---------------------------------------------------------------------------
---- 正在测试的物品
if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE == true then
    local debugging_name_list = {



    }
    for k, temp in pairs(debugging_name_list) do
        table.insert(prefabs_name_list,temp)
    end
end
---------------------------------------------------------------------------












local ret_addrs = {}
for i, v in ipairs(prefabs_name_list) do
    table.insert(ret_addrs,Prefabs_addr_base..v..".lua")
end
return ret_addrs