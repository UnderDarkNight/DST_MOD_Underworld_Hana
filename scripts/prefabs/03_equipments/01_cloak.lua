local assets =
{
    Asset("ANIM", "anim/underworld_hana_equipment_cloak_widget.zip"),
}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 安装容器界面
    local SLOT_DELTA_Y = -10
    local function container_Widget_change3(theContainer)
        -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "underworld_hana_equipment_cloak_widget_3"

        -----------------------------------------------------------------------------------
        ----- 检查和注册新的容器界面
        local all_container_widgets = require("containers")
        local params = all_container_widgets.params
        if params[container_widget_name] == nil then
            params[container_widget_name] = {
                widget =
                {
                    slotpos =
                    {
                        Vector3(-(64 + 12), 0 +SLOT_DELTA_Y , 0),
                        Vector3(0, 0 +SLOT_DELTA_Y , 0),
                        Vector3(64 + 12, 0 +SLOT_DELTA_Y , 0),
                    },
                    animbank = "underworld_hana_equipment_cloak_widget",
                    animbuild = "underworld_hana_equipment_cloak_widget",
                    pos = Vector3(600, -280, 0),
                },
                type = "chest",
                acceptsstacks = true,
            }
            ------------------------------------------------------------------------------------------
            ---- item test
                params[container_widget_name].itemtestfn =  function(container_com, item, slot)
                    return true
                end
            ------------------------------------------------------------------------------------------

            ------------------------------------------------------------------------------------------
        end
        ------------------------------------------------------------------------
        theContainer:WidgetSetup(container_widget_name)
        ------------------------------------------------------------------------
        --- 开关声音
            -- if theContainer.widget then
            --     theContainer.widget.closesound = ""
            --     theContainer.widget.opensound = ""
            -- end
            theContainer.skipopensnd = false
            theContainer.skipclosesnd = false
            theContainer.ShouldSkipOpenSnd = function()
                return true
            end
            theContainer.ShouldSkipCloseSnd = function()
                return true
            end
        ------------------------------------------------------------------------
    end
    local function container_Widget_change2(theContainer)
        -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "underworld_hana_equipment_cloak_widget_2"

        -----------------------------------------------------------------------------------
        ----- 检查和注册新的容器界面
        local all_container_widgets = require("containers")
        local params = all_container_widgets.params
        if params[container_widget_name] == nil then
            params[container_widget_name] = {
                widget =
                {
                    slotpos =
                    {
                        Vector3(-(32 + 12), 0 +SLOT_DELTA_Y , 0), 
                        Vector3(32 + 12, 0 +SLOT_DELTA_Y , 0),
                    },
                    animbank = "underworld_hana_equipment_cloak_widget",
                    animbuild = "underworld_hana_equipment_cloak_widget",
                    pos = Vector3(600, -280, 0),
                },
                type = "chest",
                acceptsstacks = true,
            }
            ------------------------------------------------------------------------------------------
            ---- item test
                params[container_widget_name].itemtestfn =  function(container_com, item, slot)
                    return true
                end
            ------------------------------------------------------------------------------------------

            ------------------------------------------------------------------------------------------
        end
        ------------------------------------------------------------------------
        theContainer:WidgetSetup(container_widget_name)
        ------------------------------------------------------------------------
        --- 开关声音
            -- if theContainer.widget then
            --     theContainer.widget.closesound = ""
            --     theContainer.widget.opensound = ""
            -- end
            theContainer.skipopensnd = false
            theContainer.skipclosesnd = false
            theContainer.ShouldSkipOpenSnd = function()
                return true
            end
            theContainer.ShouldSkipCloseSnd = function()
                return true
            end
        ------------------------------------------------------------------------
    end
    local function container_Widget_change1(theContainer)
        -----------------------------------------------------------------------------------
        ----- 容器界面名 --- 要独特一点，避免冲突
        local container_widget_name = "underworld_hana_equipment_cloak_widget_1"

        -----------------------------------------------------------------------------------
        ----- 检查和注册新的容器界面
        local all_container_widgets = require("containers")
        local params = all_container_widgets.params
        if params[container_widget_name] == nil then
            params[container_widget_name] = {
                widget =
                {
                    slotpos =
                    {
                        Vector3(0, 0 +SLOT_DELTA_Y , 0),     
                    },
                    animbank = "underworld_hana_equipment_cloak_widget",
                    animbuild = "underworld_hana_equipment_cloak_widget",
                    pos = Vector3(600, -280, 0),
                },
                type = "chest",
                acceptsstacks = true,
            }
            ------------------------------------------------------------------------------------------
            ---- item test
                params[container_widget_name].itemtestfn =  function(container_com, item, slot)
                    return true
                end
            ------------------------------------------------------------------------------------------

            ------------------------------------------------------------------------------------------
        end
        ------------------------------------------------------------------------
        theContainer:WidgetSetup(container_widget_name)
        ------------------------------------------------------------------------
        --- 开关声音
            -- if theContainer.widget then
            --     theContainer.widget.closesound = ""
            --     theContainer.widget.opensound = ""
            -- end
            theContainer.skipopensnd = false
            theContainer.skipclosesnd = false
            theContainer.ShouldSkipOpenSnd = function()
                return true
            end
            theContainer.ShouldSkipCloseSnd = function()
                return true
            end
        ------------------------------------------------------------------------
    end

    local function add_container_before_not_ismastersim_return(inst)
        -------------------------------------------------------------------------------------------------
        ------ 添加背包container组件    --- 必须在 SetPristine 之后，
        local function container_Widget_change(theContainer)
            if theContainer.inst:HasTag("slots_3") then
                container_Widget_change3(theContainer)
            elseif theContainer.inst:HasTag("slots_2") then
                container_Widget_change2(theContainer)
            else
                container_Widget_change1(theContainer)
            end
        end


        if TheWorld.ismastersim then
            inst:AddComponent("container")
            container_Widget_change(inst.components.container)
            inst.components.container.canbeopened = false
            -- inst.components.container.ignoresound = true
            -- inst.__open_task = inst:DoPeriodicTask(0.3,function()
            --     if inst.owner == inst.components.inventoryitem:GetGrandOwner() and inst.components.container.canbeopened then
            --         inst.components.container:Open(inst.owner)
            --         inst.__open_task:Cancel()
            --         inst.__open_task = nil
            --     end
            -- end)
        else
            inst.OnEntityReplicated = function(inst)
                container_Widget_change(inst.replica.container)
            end
        end
    end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



local function onequip(inst, owner)
    -- owner.AnimState:OverrideSymbol("swap_body", "armor_wood", "swap_body")
    owner.AnimState:ClearOverrideSymbol("swap_body")    
    -- owner.components.hana_com_tag_sys:AddTag("cloak_equipped")
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    -- owner.components.hana_com_tag_sys:RemoveTag("cloak_equipped")
end

local function common_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_wood")
    inst.AnimState:SetBuild("armor_wood")
    inst.AnimState:PlayAnimation("anim")

    inst:AddTag("underworld_hana_equipment_cloak")

    inst.entity:SetPristine()
    -----------------------------------------------------------------------------------------------------------
    ---- 物品接受组件
        inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_acceptable",function(inst,replica_com)
            replica_com:SetSGAction("dolongaction")
            replica_com:SetText("underworld_hana_equipment_cloak",STRINGS.ACTIONS.UPGRADE.GENERIC)
            replica_com:SetTestFn(function(inst,item,doer)
                local prefab_with_fn = {
                    ------------------------------------------------------------------------
                    ----- 升级格子
                        ["redgem"] = function()
                            if inst:HasTag("slots_3") then
                                return false
                            end
                            if item.replica.stackable:StackSize() < 2 then
                                return false
                            end
                            return true
                        end,
                    ------------------------------------------------------------------------
                    ----- 冰箱
                        ["bluegem"] = function()
                            if inst:HasTag("fridge") then
                                return false
                            end
                            if item.replica.stackable:StackSize() < 3 then
                                return false
                            end
                            return true
                        end,
                    ------------------------------------------------------------------------
                    ---- 护甲
                        ["armorwood"] = function()  -- 木甲
                            return true
                        end,
                        ["armormarble"] = function()  -- 大理石盔甲
                            return true
                        end,
                        ["armorruins"] = function()  -- 铥甲
                            return true
                        end,
                    ------------------------------------------------------------------------
                    ---- 独眼巨鹿眼球
                        ["deerclops_eyeball"] = function()
                            return true
                        end,
                    ------------------------------------------------------------------------
                    ---- 沙漠护镜  inst:AddTag("goggles")  deserthat  moonstorm_goggleshat
                        ["deserthat"] = function()
                            if inst:HasTag("goggles") then
                                return false
                            end
                            doer:PushEvent("underworld_hana_equipment_cloak.do_unequip")
                            return true
                        end,
                        ["moonstorm_goggleshat"] = function()
                            if inst:HasTag("goggles") then
                                return false
                            end
                            doer:PushEvent("underworld_hana_equipment_cloak.do_unequip")
                            return true
                        end,
                    ------------------------------------------------------------------------
                }
                if item and prefab_with_fn[item.prefab] then
                    return prefab_with_fn[item.prefab]()
                end
                return false
            end)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("hana_com_acceptable")
            inst.components.hana_com_acceptable:SetOnAcceptFn(function(inst,item,doer)

                    local prefab_with_fn = {
                        ------------------------------------------------------------------------
                        ---- 容器升级
                            ["redgem"] = function()
                                if item.replica.stackable:StackSize() >= 2 then
                                    item.components.stackable:Get(2):Remove()
                                    inst:PushEvent("slots_upgrade")
                                    return true
                                end
                                return false
                            end,
                        ------------------------------------------------------------------------
                        ---- 冰箱
                            ["bluegem"] = function()
                                if item.replica.stackable:StackSize() >= 3 then
                                    item.components.stackable:Get(3):Remove()
                                    inst:AddTag("fridge")
                                    return true
                                end
                                return false
                            end,
                        ------------------------------------------------------------------------
                        ---- 护甲
                            ["armorwood"] = function()  -- 木甲
                                inst.components.armor:InitIndestructible(0.1)
                                item:Remove()
                                return true
                            end,
                            ["armormarble"] = function()  -- 大理石盔甲
                                inst.components.armor:InitIndestructible(0.2)
                                item:Remove()
                                return true
                            end,
                            ["armorruins"] = function()  -- 铥甲
                                inst.components.armor:InitIndestructible(0.3)
                                item:Remove()
                                return true
                            end,
                        ------------------------------------------------------------------------
                        ---- 独眼巨鹿眼球
                            ["deerclops_eyeball"] = function()
                                item.components.stackable:Get():Remove()
                                inst.components.waterproofer:SetEffectiveness(0.5)
                                return true
                            end,
                        ------------------------------------------------------------------------
                        ---- 沙漠护镜  inst:AddTag("goggles")  deserthat  moonstorm_goggleshat
                            ["deserthat"] = function()
                                item:Remove()
                                inst:AddTag("goggles")
                                return true
                            end,
                            ["moonstorm_goggleshat"] = function()
                                item:Remove()
                                inst:AddTag("goggles")
                                return true
                            end,
                        ------------------------------------------------------------------------
                    }
                    if item and prefab_with_fn[item.prefab] then
                        if prefab_with_fn[item.prefab]() then
                            doer:PushEvent("hana_cloak_do_unequip",inst)    ---- 每次升级都脱下一次
                            doer:DoTaskInTime(0.5,function()
                                doer:PushEvent("hana_cloak_do_equip")                                
                            end)
                            return true
                        end
                    end
                    return false
            end)
        end
    -----------------------------------------------------------------------------------------------------------
    ---- 右键
        inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_workable",function(inst,replica_com)
            replica_com:SetSGAction("underworld_hana_sg_equip")
            replica_com:SetText("hana_cloak_action","脱下")

            replica_com:SetTestFn(function(inst,doer,right_click)
                if inst.replica.equippable:IsEquipped() then
                    return true
                end
                return false
            end)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("hana_com_workable")
            inst.components.hana_com_workable:SetActiveFn(function(inst,doer)
                doer:PushEvent("hana_cloak_do_unequip",inst)
                return true
            end)
        end
    -----------------------------------------------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end
    -----------------------------------------------------------------------------------------------------------
        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        -- inst.components.inventoryitem:ChangeImageName("armorwood")
        -- inst.components.inventoryitem.imagename = "panda_fisherman_supply_pack"
        -- inst.components.inventoryitem.atlasname = "images/inventoryimages/panda_fisherman_supply_pack.xml"


    -----------------------------------------------------------------------------------------------------------


        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = TUNING["underworld_hana.equip_slot"]:GetArmorType() or EQUIPSLOTS.BODY
        inst.components.equippable:SetOnEquip(onequip)
        inst.components.equippable:SetOnUnequip(onunequip)
        inst.components.equippable.retrictedtag = "underworld_hana"
        inst.components.equippable.walkspeedmult = 1.05 --- 5%移速加成

    -----------------------------------------------------------------------------------------------------------
    ---- 护甲减伤
        inst:AddComponent("armor")
        -- inst.components.armor:InitIndestructible(0.1)
        inst.components.armor:InitIndestructible(0)
    -----------------------------------------------------------------------------------------------------------
    ---- 防水
        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(0.2)
    -----------------------------------------------------------------------------------------------------------
    --- 保暖/隔热 切换
        inst:AddComponent("insulator")
        -- inst.components.insulator:SetInsulation(30)
        local function insulator_init()
            if TheWorld.state.temperature < 40 then
                inst.components.insulator:SetInsulation(30)               
                inst.components.insulator:SetWinter()
            else
                inst.components.insulator:SetInsulation(30)               
                inst.components.insulator:SetSummer()
            end
        end
        inst:ListenForEvent("equipped",insulator_init)
        inst:WatchWorldState("isday", insulator_init)
        inst:WatchWorldState("isdusk", insulator_init)
        inst:WatchWorldState("isnight", insulator_init)
        inst:WatchWorldState("isautumn", insulator_init)
        inst:WatchWorldState("iswinter", insulator_init)
        inst:WatchWorldState("isspring", insulator_init)
        inst:WatchWorldState("issummer", insulator_init)
    -----------------------------------------------------------------------------------------------------------
    MakeHauntableLaunch(inst)
    -----------------------------------------------------------------------------------------------------------
    ---- 穿脱触发。脱下消失
        inst:ListenForEvent("equipped",function(_,_table)
            if not (_table and _table.owner and _table.owner.prefab == "underworld_hana") then
                inst:Remove()
                return
            end
            -------------------------------------
            --- 连接 物品和玩家
                inst.owner = _table.owner
                _table.owner.__cloak_item = inst
            -------------------------------------
            --- 穿上的时候初始化数据
                inst.owner:PushEvent("hana_cloak_do_equip",inst)
            ------------------ 穿戴后打开背包
                inst:DoTaskInTime(0.3,function()
                    inst.components.container.canbeopened = true
                    inst.components.container:Open(inst.owner)                
                end)
        end)
        inst:ListenForEvent("unequipped",function(_,_table)
            if inst.owner then
                inst.owner:PushEvent("hana_cloak_do_unequip",inst)
            end
        end)
    -----------------------------------------------------------------------------------------------------------
    ---- 升级：容器
        inst:ListenForEvent("slots_upgrade",function()
            if inst:HasTag("slots_3") then
                return
            end
            if inst:HasTag("slots_2") then
                inst:RemoveTag("slots_2")
                inst:AddTag("slots_3")
                if inst.owner then
                    inst.prefab = "underworld_hana_equipment_cloak_3"
                end
                return
            end
            inst:AddTag("slots_2")
            if inst.owner then
                inst.prefab = "underworld_hana_equipment_cloak_2"
            end
        end)
    -----------------------------------------------------------------------------------------------------------


    -----------------------------------------------------------------------------------------------------------
    ---- 初始化和屏蔽T控制台
        inst:DoTaskInTime(0,function()
            if inst.owner == nil then
                inst:Remove()
            end
        end)
    -----------------------------------------------------------------------------------------------------------
    return inst
end


local function fn_1()
    local inst = common_fn()

    add_container_before_not_ismastersim_return(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.inventoryitem.imagename = "underworld_hana_equipment_cloak_1"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_equipment_cloak_1.xml"
    return inst
end

local function fn_2()
    local inst = common_fn()

    inst:AddTag("slots_2")
    add_container_before_not_ismastersim_return(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.inventoryitem.imagename = "underworld_hana_equipment_cloak_2"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_equipment_cloak_2.xml"
    return inst
end
local function fn_3()
    local inst = common_fn()

    inst:AddTag("slots_3")
    add_container_before_not_ismastersim_return(inst)
    if not TheWorld.ismastersim then
        return inst
    end
    inst.components.inventoryitem.imagename = "underworld_hana_equipment_cloak_3"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_equipment_cloak_3.xml"
    return inst
end

return Prefab("underworld_hana_equipment_cloak_1", fn_1, assets),
    Prefab("underworld_hana_equipment_cloak_2", fn_2, assets),
    Prefab("underworld_hana_equipment_cloak_3", fn_3, assets)
