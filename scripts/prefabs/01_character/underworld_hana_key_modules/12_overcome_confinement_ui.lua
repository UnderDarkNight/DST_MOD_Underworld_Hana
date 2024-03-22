--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[



]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----- 界面API
    local Widget = require "widgets/widget"
    local Image = require "widgets/image" -- 引入image控件
    local UIAnim = require "widgets/uianim"


    local Screen = require "widgets/screen"
    local AnimButton = require "widgets/animbutton"
    local ImageButton = require "widgets/imagebutton"
    local Menu = require "widgets/menu"
    local Text = require "widgets/text"
    local TEMPLATES = require "widgets/redux/templates"
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 安装界面
    local function overcome_confinement_ui_setup(inst,HUD)
        -------------------------------------------------------------------
            local scale = 2
            local tempInst = inst:SpawnChild("underworld_hana_fx_widget_overcome_confinement")
            tempInst.Transform:SetPosition(0,-2,0)
            tempInst.AnimState:SetScale(scale,scale,scale)
            tempInst.AnimState:SetSortOrder(10)
        -------------------------------------------------------------------
            tempInst.AnimState:Hide("COIN_2")
            tempInst.AnimState:Hide("COIN_3")
            tempInst.AnimState:Hide("COIN_4")
            tempInst:Hide()
        -------------------------------------------------------------------

            inst:ListenForEvent("overcome_confinement_ui.refresh",function(_,COIN_NUM)
                local weapon = inst.replica.combat:GetWeapon()
                local coin_num = 0                
                if COIN_NUM == nil then
                    if not (weapon and weapon:HasTag("underworld_hana_weapon_scythe_overcome_confinement") )then
                        tempInst:Hide()
                        return
                    end
                    tempInst:Show()
                    coin_num = weapon.SPELL_COIN or 0
                else
                    coin_num = COIN_NUM
                    tempInst:Show()
                end
                for i = 1, 3, 1 do
                    if i <= coin_num then
                        tempInst.AnimState:Show("COIN_"..tostring(i+1))
                    else
                        tempInst.AnimState:Hide("COIN_"..tostring(i+1))
                    end
                end
            end)
            inst:ListenForEvent("overcome_confinement_ui.Hide",function()
                tempInst:Hide()
            end)
            inst:ListenForEvent("overcome_confinement_ui.Show",function()
                tempInst:Show()
            end)
        -------------------------------------------------------------------
    end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(0,function()
        if inst.HUD == nil then
            return
        end
        if inst ~= ThePlayer then
            return
        end

        --------- 安装UI
            overcome_confinement_ui_setup(inst,inst.HUD)


    end)
end