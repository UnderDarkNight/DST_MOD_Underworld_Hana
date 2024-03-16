



local HANA_COM_ITEM_USE_ACTION = Action({priority = 10})   --- 距离 和 目标物体的 碰撞体积有关，为 0 也没法靠近。
HANA_COM_ITEM_USE_ACTION.id = "HANA_COM_ITEM_USE_ACTION"
HANA_COM_ITEM_USE_ACTION.strfn = function(act) --- 客户端检查是否通过,同时返回显示字段
    local item = act.invobject
    local target = act.target
    local doer = act.doer

    if item and doer and target and item.replica.hana_com_item_use_to then
        local replica_com = item.replica.hana_com_item_use_to or item.replica._.hana_com_item_use_to
        if replica_com then
            replica_com:ActiveTextUpdate(target,doer)
            return replica_com:GetTextIndex()
        end
    end
    return "DEFAULT"
end

HANA_COM_ITEM_USE_ACTION.fn = function(act)    --- 只在服务端执行~
    local item = act.invobject
    local target = act.target
    local doer = act.doer

    if item and target and doer and item.components.hana_com_item_use_to then
        local replica_com = item.replica.hana_com_item_use_to or item.replica._.hana_com_item_use_to
        if replica_com and replica_com:Test(target,doer) then
            return item.components.hana_com_item_use_to:Active(target,doer)
        end
    end
    return false
end
AddAction(HANA_COM_ITEM_USE_ACTION)

--- 【重要笔记】AddComponentAction 函数有陷阱，一个MOD只能对一个组件添加一个动作。
--- 【重要笔记】例如AddComponentAction("USEITEM", "inventoryitem", ...) 在整个MOD只能使用一次。
--- 【重要笔记】modname 参数伪装也不能绕开。


-- AddComponentAction("EQUIPPED", "npng_com_book" , function(inst, doer, target, actions, right)    --- 装备后多个技能
-- AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) -- -- 一个物品对另外一个目标用的技能，物品身上有 这个com 就能触发
-- AddComponentAction("SCENE", "npng_com_book" , function(inst, doer, actions, right)-------    建筑一类的特殊交互使用
-- AddComponentAction("INVENTORY", "npng_com_book", function(inst, doer, actions, right)   ---- 拖到玩家自己身上就能用
-- AddComponentAction("POINT", "complexprojectile", function(inst, doer, pos, actions, right)   ------ 指定坐标位置用。

-- 在后续注册了，这里暂时注释掉。

AddComponentAction("USEITEM", "hana_com_item_use_to", function(item, doer, target, actions, right_click) -- -- 一个物品对另外一个目标用的技能，
    if doer and item and target then
        local hana_com_item_use_to_com = item.replica.hana_com_item_use_to or item.replica._.hana_com_item_use_to

        if hana_com_item_use_to_com and hana_com_item_use_to_com:Test(target,doer) then
            table.insert(actions, ACTIONS.HANA_COM_ITEM_USE_ACTION)
        end        
    end
end)

local handler_fn = function(player)
    local creash_flag , ret = pcall(function()
        local target = player.bufferedaction.target
        local item = player.bufferedaction.invobject
        local ret_sg_action = "dolongaction"

        local replica_com = item and ( item.replica.hana_com_item_use_to or item.replica._.hana_com_item_use_to )
        if replica_com then
            ret_sg_action = replica_com:GetSGAction()
            replica_com:DoPreAction(target,player)
        end
        return ret_sg_action

    end)
    if creash_flag == true then
        return ret
    else
        print("error in HANA_COM_ITEM_USE_ACTION ActionHandler")
        print(ret)
    end
    return "dolongaction"
end

AddStategraphActionHandler("wilson",ActionHandler(HANA_COM_ITEM_USE_ACTION,function(player)
    return handler_fn(player)
end))
AddStategraphActionHandler("wilson_client",ActionHandler(HANA_COM_ITEM_USE_ACTION, function(player)    
    return handler_fn(player)
end))


STRINGS.ACTIONS.HANA_COM_ITEM_USE_ACTION = STRINGS.ACTIONS.HANA_COM_ITEM_USE_ACTION or {
    DEFAULT = STRINGS.ACTIONS.OPEN_CRAFTING.USE
}



