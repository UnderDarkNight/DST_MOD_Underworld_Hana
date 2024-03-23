--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

【只能通过【褪色的记忆】【幸福的记忆】增加】【角色死亡后等级-15】
            【达到5点时解锁【哈娜的礼物】的制作】
                【达到15点时解锁【冲破禁锢】的制作】
                【达到25点时解锁【冥界使者的蝴蝶结】的制作】
                【达到35点时获得10%砍树挖矿效率和0.1攻击系数提升】
                【达到45点时哈娜将取消【笨手笨脚的死神】的负面效果】

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"
    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
    local Badge = require "widgets/badge"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 储存UI坐标相关的API
----- 读取 储存数据的API
    
                            local function Get_Data_File_Name()
                                return "UNDERWORLD_HANA_DATA.TEXT"
                            end
                            local function Read_All_Json_Data()

                                local function Read_data_p()
                                    local file = io.open(Get_Data_File_Name(), "r")
                                    local text = file:read('*line')
                                    file:close()
                                    return text
                                end

                                local flag,ret = pcall(Read_data_p)

                                if flag == true then
                                    local retTable = json.decode(ret)
                                    return retTable
                                else
                                    print("UNDERWORLD_HANA_DATA ERROR :read cross archived data error : Read_All_Json_Data got nil")
                                    print(ret)
                                    return {}
                                end
                            end

                            local function Write_All_Json_Data(json_data)
                                local w_data = json.encode(json_data)
                                local file = io.open(Get_Data_File_Name(), "w")
                                file:write(w_data)
                                file:close()
                            end

                            local function Get_Cross_Archived_Data_By_userid(userid)
                                local crash_flag , all_data_table = pcall(Read_All_Json_Data)
                                if crash_flag then
                                    local temp_json_data = all_data_table
                                    return temp_json_data[userid] or {}
                                else
                                    print("error : Read_All_Json_Data fn crash")
                                    return {}
                                end
                            end

                            local function Set_Cross_Archived_Data_By_userid(userid,_table)

                                local temp_json_data = Read_All_Json_Data() or {}
                                -- temp_json_data[userid] = _table
                                temp_json_data[userid] = temp_json_data[userid] or {}
                                for index, value in pairs(_table) do
                                    temp_json_data[userid][index] = value
                                end
                                temp_json_data = deepcopy(temp_json_data)
                                -- Write_All_Json_Data(temp_json_data)
                                pcall(Write_All_Json_Data,temp_json_data)
                            end


        local function read_xy_percent()
            local data_table = {}
            local crash_flag,temp_table = pcall(Get_Cross_Archived_Data_By_userid,ThePlayer.userid)
            if crash_flag then
                data_table = temp_table
            end

            local x,y = data_table.x or 0.82,data_table.y or 0.82
                return x,y
            end
        local function save_xy_percent(x,y)
            local data_table = {
                x = x,
                y = y
            }
            pcall(Set_Cross_Archived_Data_By_userid,ThePlayer.userid,data_table)
        end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function client_side_widget_setup(inst,HUD)
        ---------------------------------------------------------------------
            local level = inst.replica.hana_com_level_sys:GetLevel()
            local power,power_percent = inst.replica.hana_com_level_sys:GetPower()
        ---------------------------------------------------------------------
        local main_scale_num = 0.8
        local root = HUD:AddChild(Widget())
        -------- 设置锚点
            root:SetHAnchor(1) -- 设置原点x坐标位置，0、1、2分别对应屏幕中、左、右
            root:SetVAnchor(2) -- 设置原点y坐标位置，0、1、2分别对应屏幕中、上、下
            root:SetPosition(1000,500)
            root:MoveToBack()
        -------- 设置缩放模式
            root:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)
        ---------------------------------------------------------------------
        ---- 屏幕缩放
            -- root.x_percent = 0.5
            -- root.y_percent = 0.5
            root.x_percent,root.y_percent = read_xy_percent()
            function root:LocationScaleFix()
                if self.x_percent and not self.__mouse_holding  then
                    local scrnw, scrnh = TheSim:GetScreenSize()
                    if self.____last_scrnh ~= scrnh then
                        local tarX = self.x_percent * scrnw
                        local tarY = self.y_percent * scrnh
                        self:SetPosition(tarX,tarY)
                    end
                    self.____last_scrnh = scrnh
                end
            end
            root:LocationScaleFix()
            inst:DoPeriodicTask(5,function()
                root:LocationScaleFix()                            
            end)
        ---------------------------------------------------------------------
            local anim = nil
            local owner = inst
            local tint = nil
            local iconbuild = nil
            local circular_meter = false
            local use_clear_bg = nil
            local dont_update_while_paused = true
            local temp_bage = root:AddChild(Badge(anim, owner, tint, iconbuild, circular_meter, use_clear_bg, dont_update_while_paused))
            temp_bage.num:SetString("100")
            temp_bage.anim:GetAnimState():Pause()
            -- temp_bage.anim:GetAnimState():SetPercent("anim",0.5)
            temp_bage.num:SetString(tostring(math.floor(power)))
            temp_bage.anim:GetAnimState():SetPercent("anim",1-power_percent)
            temp_bage:SetScale(main_scale_num,main_scale_num)
            ---------------- 等级图标
                local level_widget = temp_bage:AddChild(UIAnim())
                level_widget:SetPosition(-50,0)
                level_widget:GetAnimState():SetBank("status_meter")
                level_widget:GetAnimState():SetBuild("status_meter")
                level_widget:GetAnimState():PlayAnimation("frame")
                level_widget:MoveToBack()
                local level_widget_bg = level_widget:AddChild(UIAnim())
                level_widget_bg:GetAnimState():SetBank("status_meter")
                level_widget_bg:GetAnimState():SetBuild("status_meter")
                level_widget_bg:GetAnimState():PlayAnimation("bg")
                level_widget_bg:MoveToBack()
                
                level_widget:SetRotation(90) -- 旋转90度
                local level_widget_scale = 0.8
                level_widget:SetScale(level_widget_scale,level_widget_scale,level_widget_scale)

                local level_str = temp_bage:AddChild(Text(BODYTEXTFONT, 25))
                level_str:SetHAlign(ANCHOR_MIDDLE)
                level_str:SetPosition(-50,0)
                level_str:SetString("lv.50")
                level_str:SetString("lv."..tostring(level))
        ---------------------------------------------------------------------
        ---- 按钮点击
            local old_OnMouseButton = temp_bage.OnMouseButton
            temp_bage.OnMouseButton = function(self,button, down, x, y)
                -- print("mouse",button,down,x,y)
                ----------------------------------------------------------------------
                -----
                    if not root.__mouse_holding then
                        root.__mouse_holding = true
                        root.___follow_mouse_event = TheInput:AddMoveHandler(function(x, y)  
                            root:SetPosition(x,y,0)
                        end)
                        ---- 添加鼠标按钮监听
                        root.___mouse_button_up_event = TheInput:AddMouseButtonHandler(function(button, down, x, y) 
                            if button == MOUSEBUTTON_LEFT and down == false then    ---- 左键被抬起来了
                                root.___mouse_button_up_event:Remove()       ---- 清掉监听
                                root.___mouse_button_up_event = nil

                                root.___follow_mouse_event:Remove()          ---- 清掉监听
                                root.___follow_mouse_event = nil

                                root:SetPosition(x,y,0)                      ---- 设置坐标
                                root.__mouse_holding = false                 ---- 解锁

                                local scrnw, scrnh = TheSim:GetScreenSize()
                                root.x_percent = x/scrnw
                                root.y_percent = y/scrnh

                                ------------------------------------------------------------------------
                                ----
                                    save_xy_percent(root.x_percent,root.y_percent)  ---- 储存坐标
                                ------------------------------------------------------------------------
                            end
                        end)
                    end
                ----------------------------------------------------------------------
                return old_OnMouseButton(self,button, down, x, y)
            end
        ---------------------------------------------------------------------
        inst.replica.hana_com_level_sys:SetLevelUpdateFn(function(inst,com,level)
            -- print("replica level change to ",level)
            level_str:SetString("lv."..tostring(level))
        end)
        inst.replica.hana_com_level_sys:SetPowerUpdateFn(function()
            local power,power_percent = inst.replica.hana_com_level_sys:GetPower()
            temp_bage.num:SetString(tostring(math.floor(power)))
            temp_bage.anim:GetAnimState():SetPercent("anim",1-power_percent)
        end)
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)

    inst:DoTaskInTime(1,function()
        if ThePlayer == inst and inst.HUD then
            client_side_widget_setup(inst,inst.HUD)                
        end
    end)
end