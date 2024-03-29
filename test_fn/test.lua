
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
            -- -- ThePlayer:AddTag("my_test_tag")
            -- -- ThePlayer:RemoveTag("my_test_tag")
            -- ThePlayer.components.hana_com_tag_sys:RemoveTag("my_test_tag")
            -- print(ThePlayer.replica.hana_com_tag_sys:HasTag("my_test_tag"))
            -- -- TECH_SKILLTREE_BUILDER_TAG_OWNERS["my_test_tag"] = ThePlayer.prefab
            -- -- ThePlayer:PushEvent("refreshcrafting")
            -- -- print(ThePlayer.replica.builder:KnowsRecipe("underworld_hana_weapon_scythe"))

            -- print(ThePlayer.replica.builder:CanLearn("underworld_hana_weapon_scythe"))
    ----------------------------------------------------------------------------------------------------------------
    ------
        -- SpawnPrefab("underworld_hana_projectile_faded_memory"):PushEvent("Set",{
        --     pt = Vector3(x+10,0,z),
        --     tail_time = 0.3,
        --     speed = 8,
        -- })
    ----------------------------------------------------------------------------------------------------------------
    ----- 火焰特效
            -- SpawnPrefab("underworld_hana_fx_spell_flame"):PushEvent("Set",{
            --     target = ThePlayer,
            --     type = 3,
            --     time = 5,
            --     color = Vector3(255,0,0)
            -- })
    ----------------------------------------------------------------------------------------------------------------
    ----- 面相
            -- ThePlayer:GetRotation()  -180 ~ 180 度
            -- local angle = ThePlayer:GetRotation() + 180
            -- print()
            -- ThePlayer.___test_fn = function(x,y,z)
            --     ThePlayer:ForceFacePoint(x, y, z)
            --     -- local angle = ThePlayer:GetRotation()
            --     -- print(angle)
            --     local player_pt = Vector3(ThePlayer.Transform:GetWorldPosition())
            --     local delta_x,delata_y,delta_z = x-player_pt.x, 0 ,z-player_pt.z
            --     local angle = math.deg(math.atan2(delta_z, delta_x))
            --     -- local distance = 4

            --     local function get_offset_pt_by_angle(angle,distance)
            --         return Vector3(math.cos(math.rad(angle))*distance,0,math.sin(math.rad(angle))*distance )                    
            --     end

            --     for i = 1, 4, 1 do
            --         local color = Vector3(255,0,0)
            --         local scale = (0.5/3)*i+0.5
            --         local MultColour_Flag = true
            --         ThePlayer:DoTaskInTime((i-1)*0.1,function()                        
            --             local offset_pt = get_offset_pt_by_angle(angle,i*0.8)
            --             SpawnPrefab("underworld_hana_fx_spell_flame"):PushEvent("Set",{
            --                 pt = player_pt+offset_pt,
            --                 -- time = 5,
            --                 color = color,
            --                 scale = scale,
            --                 type = math.random(3),
            --                 MultColour_Flag = MultColour_Flag,
            --             })
            --             local offset_pt2 = get_offset_pt_by_angle(angle+20,i*0.8)
            --             SpawnPrefab("underworld_hana_fx_spell_flame"):PushEvent("Set",{
            --                 pt = player_pt+offset_pt2,
            --                 -- time = 5,
            --                 color = color,
            --                 scale = scale,
            --                 type = math.random(3),
            --                 MultColour_Flag = MultColour_Flag,

            --             })
            --             local offset_pt3 = get_offset_pt_by_angle(angle-20,i*0.8)
            --             SpawnPrefab("underworld_hana_fx_spell_flame"):PushEvent("Set",{
            --                 pt = player_pt+offset_pt3,
            --                 -- time = 5,
            --                 color = color,
            --                 scale = scale,
            --                 type = math.random(3),
            --                 MultColour_Flag = MultColour_Flag,
            --             })
            --         end)

            --     end
            --     -- SpawnPrefab("log").Transform:SetPosition(player_pt.x+offset_pt.x,0, player_pt.z+offset_pt.z)

            -- end
            -- ThePlayer.__test_fn = function(inst,doer,target,pt)
            --     ------------------------------------------------------------------------------------
            --     --- 基点坐标
            --         local x,y,z = doer.Transform:GetWorldPosition()
            --         if target then
            --             x,y,z = target.Transform:GetWorldPosition()
            --         end
            --         if pt then
            --             x,y,z = pt.x,pt.y,pt.z
            --         end
            --     ------------------------------------------------------------------------------------
            --     --- 坐标和角度函数
            --         doer:ForceFacePoint(x, y, z)

            --         local player_pt = Vector3(doer.Transform:GetWorldPosition())
            --         local delta_x,delata_y,delta_z = x-player_pt.x, 0 ,z-player_pt.z
            --         local angle = math.deg(math.atan2(delta_z, delta_x))
            --         -- local distance = 4

            --         local function get_offset_pt_by_angle(angle,distance)
            --             return Vector3(math.cos(math.rad(angle))*distance,0,math.sin(math.rad(angle))*distance )                    
            --         end
            --     ------------------------------------------------------------------------------------
            --     ---- 扇形火焰特效，。 最大距离： 6.4
            --         for i = 1, 8, 1 do
            --             local color = Vector3(255,0,0)
            --             local scale = (0.5/3)*i+0.5
            --             local MultColour_Flag = true
            --             inst:DoTaskInTime((i-1)*0.05,function()                        
            --                 local offset_pt = get_offset_pt_by_angle(angle,i*0.8)
            --                 SpawnPrefab("underworld_hana_fx_spell_flame"):PushEvent("Set",{
            --                     pt = player_pt+offset_pt,
            --                     -- time = 5,
            --                     color = color,
            --                     scale = scale,
            --                     type = math.random(3),
            --                     MultColour_Flag = MultColour_Flag,
            --                 })
            --                 local offset_pt2 = get_offset_pt_by_angle(angle+20,i*0.8)
            --                 SpawnPrefab("underworld_hana_fx_spell_flame"):PushEvent("Set",{
            --                     pt = player_pt+offset_pt2,
            --                     -- time = 5,
            --                     color = color,
            --                     scale = scale,
            --                     type = math.random(3),
            --                     MultColour_Flag = MultColour_Flag,
            --                 })
            --                 local offset_pt3 = get_offset_pt_by_angle(angle-20,i*0.8)
            --                 SpawnPrefab("underworld_hana_fx_spell_flame"):PushEvent("Set",{
            --                     pt = player_pt+offset_pt3,
            --                     -- time = 5,
            --                     color = color,
            --                     scale = scale,
            --                     type = math.random(3),
            --                     MultColour_Flag = MultColour_Flag,
            --                 })
            --             end)

            --         end
            --     ------------------------------------------------------------------------------------
            --     ---- 点火
            --         inst:DoTaskInTime(0.3,function()                        
            --                 local flame_range = 3.5
            --                 local flame_base_pt = player_pt+get_offset_pt_by_angle(angle,3)
            --                 local musthavetags = nil
            --                 local canthavetags = {"burnt","player","INLIMBO", "notarget", "noattack", "flight", "invisible"}
            --                 local musthaveoneoftags = nil
            --                 local ents = TheSim:FindEntities(flame_base_pt.x, 0, flame_base_pt.z, flame_range, musthavetags, canthavetags, musthaveoneoftags)
            --                 for k, temp_target in pairs(ents) do
            --                     if temp_target and temp_target:IsValid() then
            --                         if temp_target.components.burnable then
            --                             if not temp_target.components.burnable:IsBurning() then
            --                                 temp_target.components.burnable:Ignite(true, doer)
            --                             end
            --                         elseif temp_target.components.lootdropper then
            --                             temp_target.components.lootdropper:DropLoot()
            --                         end
            --                     end
            --                 end
            --         end)

            --     ------------------------------------------------------------------------------------
            --     --- 声音
            --         doer.SoundEmitter:PlaySound("rifts3/mutated_varg/blast_pre_f17")
            --     ------------------------------------------------------------------------------------
            -- end

            -- ThePlayer.SoundEmitter:PlaySound("rifts3/mutated_varg/blast_pre_f17")
            
    ----------------------------------------------------------------------------------------------------------------
    ---- 特效
                -- ThePlayer.__test_fn = function(inst,owner)
                --     if inst.____light_fx then
                --         inst.____light_fx:Remove()
                --     end
                --     local fx = SpawnPrefab("underworld_hana_weapon_messiah_fx")
                --     fx.entity:SetParent(owner.entity)
                --     fx.entity:AddFollower()
                --     fx.Follower:FollowSymbol(owner.GUID, "swap_object",45, -200, 1)
                --     fx.Light:Enable(true)
                --     inst.____light_fx = fx
                -- end
                    -- TheWorld:PushEvent("ms_deltamoisture", 50000)

                    -- SpawnPrefab("underworld_hana_fx_spell_lightning"):PushEvent("Set",{
                    --     target = ThePlayer,
                    -- })
                    -- ThePlayer.SoundEmitter:PlaySound("dontstarve/rain/thunder_close", nil, 10, true)
                    -- TheWorld:PushEvent("ms_sendlightningstrike", Vector3(x+0,y,z))
                    -- ThePlayer.components.playerlightningtarget:DoStrike()
                    -- ThePlayer.SoundEmitter:PlaySound("dontstarve/rain/thunder_close")
    ----------------------------------------------------------------------------------------------------------------
    -----
        -- TheWorld:PushEvent("ms_sendlightningstrike", Vector3(x,y,z))
        -- for k, v in pairs(ThePlayer.components.inventory.equipslots) do
        --     print(k,v)
        -- end
        -- ThePlayer:ListenForEvent("newstate",function(_,_table)
        --     print("newstate",_table.statename)
        -- end)
    ----------------------------------------------------------------------------------------------------------------
    -----
        -- ThePlayer.SoundEmitter:KillAllSounds()
        -- local tempsound = "dontstarve/common/together/spawn_vines/spawnportal_jacob"
        -- local tempsound = "dontstarve/common/together/spawn_vines/vines"
        -- local tempsound = "dontstarve/music/music_epicfight"
        -- local tempsound = "dontstarve/music/music_danger"
        -- ThePlayer.SoundEmitter:PlaySound(tempsound)

    ----------------------------------------------------------------------------------------------------------------
    -----
            -- local level = ThePlayer.replica.hana_com_level_sys:GetLevel()
            -- print("level : ",level)
            ThePlayer.components.hana_com_level_sys:LevelDoDelta(-5)

    ----------------------------------------------------------------------------------------------------------------
    ----- 

    ----------------------------------------------------------------------------------------------------------------
    print("WARNING:PCALL END   +++++++++++++++++++++++++++++++++++++++++++++++++")
end)

if flg == false then
    print("Error : ",error_code)
end

-- dofile(resolvefilepath("test_fn/test.lua"))