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


    "01_spell_flame",                           --- 技能火焰
    "02_spriter_mini",                           --- 精灵特效
    "03_spriter_sanityaura",                           --- 精灵特效
    "04_lightning",                             --- 闪电特效
    "05_antlion_hole",                             --- 地面特效
    "06_shadow_pillar",                             --- 暗影柱子
    "07_scythe_attack",                             --- 镰刀特效
    "08_widget_overcome_confinement",               --- 冲破禁锢UI
    "09_shadow_shell",                              --- 暗影护盾fx

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