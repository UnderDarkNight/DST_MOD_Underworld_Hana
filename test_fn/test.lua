
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------ 界面调试
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"


    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local flg,error_code = pcall(function()
    print("WARNING:PCALL START +++++++++++++++++++++++++++++++++++++++++++++++++")
    local x,y,z =    ThePlayer.Transform:GetWorldPosition()  
    ----------------------------------------------------------------------------------------------------------------
        -- print(ThePlayer.replica.hana_com_right_click_playerself)
        -- print(ThePlayer.components.hana_com_right_click_playerself)
        -- if ThePlayer.__spriter then
        --     ThePlayer.__spriter:Remove()
        -- end

        -- ThePlayer.__spriter = SpawnPrefab("underworld_hana_fx_spriter_big")
        -- ThePlayer.__spriter:PushEvent("Set",{
        --     player = ThePlayer,  --- 跟随目标
        --     range = 3,           --- 环绕点半径
        --     point_num = 15,       --- 环绕点
        --     -- new_pt_time = 0.5 ,    --- 新的跟踪点时间
        --     -- speed = 8,           --- 强制固定速度
        --     speed_mult = 2,      --- 速度倍速
        --     next_pt_dis = 0.5,      --- 触碰下一个点的距离
        --     speed_soft_delta = 20, --- 软增加
        --     y = 1.5,
        --     tail_time = 0.2,
        -- })
    ----------------------------------------------------------------------------------------------------------------
    ---- tag 系统
            -- ThePlayer:AddTag("my_test_tag")
            -- ThePlayer:RemoveTag("my_test_tag")
            ThePlayer.components.hana_com_tag_sys:RemoveTag("my_test_tag")
            print(ThePlayer.replica.hana_com_tag_sys:HasTag("my_test_tag"))
            -- TECH_SKILLTREE_BUILDER_TAG_OWNERS["my_test_tag"] = ThePlayer.prefab
            -- ThePlayer:PushEvent("refreshcrafting")
            -- print(ThePlayer.replica.builder:KnowsRecipe("underworld_hana_weapon_scythe"))

            print(ThePlayer.replica.builder:CanLearn("underworld_hana_weapon_scythe"))
    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))