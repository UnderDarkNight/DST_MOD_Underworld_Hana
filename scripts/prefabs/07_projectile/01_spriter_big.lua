------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/underworld_hana_fx_spriter.zip"),
}
--------------------------------------------------------------------------------------------------------------------------------------------
-------

    local function CreateTail_Fx()
        local inst = CreateEntity()

        inst:AddTag("INLIMBO")
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")      --- 不可点击
        inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
        inst:AddTag("NOBLOCK")      -- 不会影响种植和放置
        
        inst.entity:SetCanSleep(false)

        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("underworld_hana_fx_spriter")
        inst.AnimState:SetBuild("underworld_hana_fx_spriter")
        inst.AnimState:PlayAnimation("tail")
        inst.AnimState:SetDeltaTimeMultiplier(2)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

        -- inst.AnimState:SetFinalOffset(3)
        -- inst.AnimState:SetFinalOffset(3)
        inst:ListenForEvent("animover", inst.Remove)
        return inst
    end
    local function CreateTails(inst)
        local time = inst.__tail_deta_time_net_var:value()
        if time == 0 then 
            time = 0.5
        end
        inst:DoPeriodicTask(time,function()
            local x,y,z = inst.Transform:GetWorldPosition()
            local tail = CreateTail_Fx()
            local offset_x = math.random(10)/100
            local offset_z = math.random(10)/100
            if math.random(100) > 50 then
                offset_x = -offset_x
            end
            if math.random(100) > 50 then
                offset_z = -offset_z
            end
            tail.Transform:SetPosition(x+offset_x,y,z+offset_z)
        end)
    end
--------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize(1,1)

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst.AnimState:SetBank("underworld_hana_fx_spriter")
    inst.AnimState:SetBuild("underworld_hana_fx_spriter")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetFinalOffset(-0.5)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    -- local scale = 2/3
    -- inst.AnimState:SetScale(scale,scale,scale)

    -- inst.Transform:SetFourFaced()

    --projectile (from projectile component) added to pristine state for optimization
    inst:AddTag("projectile")
    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")      --- 不可点击
    inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
    inst:AddTag("NOBLOCK")      -- 不会影响种植和放置

    inst.entity:SetPristine()
    ----------------------------------------------------------------------
    ----- 创建尾巴
        if not TheNet:IsDedicated() then
            inst:DoTaskInTime(0.1,function()
                CreateTails(inst)
            end)
        end

    ----------------------------------------------------------------------
    ------ 
        inst.__tail_deta_time_net_var = net_float(inst.GUID,"underworld_hana_fx_spriter_big","underworld_hana_fx_spriter_big")
    ----------------------------------------------------------------------

    if not TheWorld.ismastersim then
        return inst
    end


    inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(50)

    function inst:Close2Point(pt,speed)
        self:FacePoint(pt.x,0,pt.z)
        self.Physics:ClearCollidesWith(COLLISION.LIMITS)
        self.Physics:SetMotorVel(speed, 0, 0)
        self.current_speed = speed
    end
    function inst:Close2Point_Soft(pt,tar_speed)
        local speed = 0
        if self.current_speed and self.speed_soft_delta then
            local delta_speed = math.abs(tar_speed - self.current_speed) / self.speed_soft_delta
            if self.current_speed < tar_speed then
                speed = self.current_speed + delta_speed
            else
                speed = self.current_speed - delta_speed
            end
            -- if tar_speed < self.current_speed then
            --     speed = self.current_speed + self.speed_soft_delta
            -- else
            --     speed = self.current_speed - self.speed_soft_delta
            -- end
        else
            speed = tar_speed
        end

        self:FacePoint(pt.x,0,pt.z)
        self.Physics:ClearCollidesWith(COLLISION.LIMITS)
        self.Physics:SetMotorVel(speed, 0, 0)
        self.current_speed = speed
    end
    function inst:StopClosing()
        inst.Physics:Stop()
    end

    function inst:Distance_Points(PointA,PointB)
        return ((PointA.x - PointB.x) ^ 2 + (PointA.z - PointB.z) ^ 2) ^ (0.5)
    end

    -- inst:AddComponent("projectile")
    -- inst.components.projectile:SetSpeed(50)
    -- inst.components.projectile:SetOnHitFn(inst.Remove)
    -- inst.components.projectile:SetOnMissFn(inst.Remove)
    -- inst.components.projectile:SetOnHitFn(OnHitIce)
    function inst:GetSurroundPoints(CMD_TABLE)
        -- local CMD_TABLE = {
        --     target = inst or Vector3(),
        --     range = 8,
        --     num = 8
        -- }
        if CMD_TABLE == nil then
            return
        end
        local theMid = nil
        if CMD_TABLE.target == nil then
            theMid = Vector3( self.inst.Transform:GetWorldPosition() )
        elseif CMD_TABLE.target.x then
            theMid = CMD_TABLE.target
        elseif CMD_TABLE.target.prefab then
            theMid = Vector3( CMD_TABLE.target.Transform:GetWorldPosition() )
        else
            return
        end
        -- --------------------------------------------------------------------------------------------------------------------
        -- -- 8 points
        -- local retPoints = {}
        -- for i = 1, 8, 1 do
        --     local tempDeg = (PI/4)*(i-1)
        --     local tempPoint = theMidPoint + Vector3( Range*math.cos(tempDeg) ,  0  ,  Range*math.sin(tempDeg)    )
        --     table.insert(retPoints,tempPoint)
        -- end
        -- --------------------------------------------------------------------------------------------------------------------
        local num = CMD_TABLE.num or 8
        local range = CMD_TABLE.range or 8
        local retPoints = {}
        for i = 1, num, 1 do
            local tempDeg = (2*PI/num)*(i-1)
            local tempPoint = theMid + Vector3( range*math.cos(tempDeg) ,  0  ,  range*math.sin(tempDeg)    )
            table.insert(retPoints,tempPoint)
        end

        return retPoints


    end

    inst:ListenForEvent("Set",function(_,_table)
        -- _table = {
        --     player = ThePlayer,  --- 跟随目标
        --     range = 4,           --- 环绕点半径
        --     point_num = 6,       --- 环绕点
        --     new_pt_time = 1 ,    --- 新的跟踪点时间
        --     speed = 1,           --- 强制固定速度
        --     speed_mult = 1,      --- 速度倍速
        --     next_pt_dis = 1.5，  --- 触碰下一个点的距离
        --     speed_soft_delta = 0.1, --- 软增加
        --     y = 0,                   --- 高度
        --     tail_time = 1,           --- 
        -- }
        if not type(_table) == "table" or _table.player == nil then
            inst:Remove()
            return
        end
        local player = _table.player
        local x,y,z = player.Transform:GetWorldPosition()
        inst.Transform:SetPosition(x, _table.y or y, z)
        --------------------------------------------------------------------------------------------
            inst.speed_soft_delta = _table.speed_soft_delta
        --------------------------------------------------------------------------------------------
            local range = _table.range or 4
            local point_num = _table.point_num or 6
            inst.__follow_num = math.random(point_num)
            -- inst:DoPeriodicTask(_table.new_pt_time or 1,function()                ---- 定时刷个环绕目标点
            --     -- inst.__follow_num = inst.__follow_num + 1
            --     -- if inst.__follow_num > point_num then
            --     --     inst.__follow_num = 1
            --     -- end
            -- end)
        --------------------------------------------------------------------------------------------
            inst:DoPeriodicTask(2*FRAMES,function()
                if player:IsValid() then
                    local points = inst:GetSurroundPoints({
                        target = player,
                        range = range,
                        num = point_num
                    })
                    local pt = points[inst.__follow_num]
                    if pt and pt.x then
                        ----------------------------------------------
                            local dis = inst:Distance_Points(pt,Vector3(inst.Transform:GetWorldPosition()))
                            if dis < 40 then
                                if dis < (_table.next_pt_dis or 1.5) then
                                    --- 距离过近，不进行任何操作
                                    -- inst:StopClosing()
                                    ----------------------------------------------------------------
                                    --- 自动到下一个点
                                        inst.__follow_num = inst.__follow_num + 1
                                        if inst.__follow_num > point_num then
                                            inst.__follow_num = 1
                                        end
                                        pt = points[inst.__follow_num]
                                        dis = inst:Distance_Points(pt,Vector3(inst.Transform:GetWorldPosition()))
                                        local speed = (_table.speed or dis) * (_table.speed_mult or 1)
                                        if _table.speed_soft_delta then
                                            inst:Close2Point_Soft(pt,speed)
                                        else
                                            inst:Close2Point(pt,speed)
                                        end
                                    ----------------------------------------------------------------
                                else
                                    local speed = (_table.speed or dis) * (_table.speed_mult or 1)
                                    if _table.speed_soft_delta then
                                        inst:Close2Point_Soft(pt,speed)
                                    else
                                        inst:Close2Point(pt,speed)
                                    end
                                end
                            else
                                inst.Transform:SetPosition(pt.x,0,pt.z)
                            end
                        ----------------------------------------------

                    end
                else
                    inst:Remove()
                end
            end)
        --------------------------------------------------------------------------------------------
            if _table.tail_time then
                inst.__tail_deta_time_net_var:set(_table.tail_time)
            end
        --------------------------------------------------------------------------------------------
            inst.Ready = true
        --------------------------------------------------------------------------------------------


    end)
    ------------------------------------------------------------------------------------------------
        inst:DoTaskInTime(0,function()
            if not inst.Ready then
                inst:Remove()
            end
        end)
    ------------------------------------------------------------------------------------------------
    ------------------------------------------------------------------------------------------------
    ---- 精灵发光
        inst:ListenForEvent("light",function(_,cmd)
            if cmd == "on" then
                if inst.__________light_inst == nil then
                    local light_inst = inst:SpawnChild("minerhatlight")
                    inst.__________light_inst = light_inst

                    light_inst.Light:Enable(true)
                    -- light_inst.Light:SetRadius(1.5)   -- 光照半径
                    light_inst.Light:SetRadius(1.5)   -- 光照半径
                    light_inst.Light:SetFalloff(.2)   -- 距离衰减速度（越大衰减越快）
                    light_inst.Light:SetIntensity(0.9)    --- 光照强度 --- 
                    -- light_inst.Light:SetColour(235 / 255, 255 / 255, 255 / 255)   --- 颜色 RGB
                    light_inst.Light:SetColour(0 / 255, 255 / 255, 0 / 255)   --- 颜色 RGB
                    --------------------------------------------------------------------------------------

                    --------------------------------------------------------------------------------------
                end
            else
                if inst.__________light_inst then
                    inst.__________light_inst:Remove()
                end
            end
        end)
        local light_fn = function()
            if TheWorld.state.isday then
                inst:DoTaskInTime(5,function()
                    inst:PushEvent("light", "off")                
                end)
            elseif TheWorld.state.isnight or TheWorld.state.isdusk  then
                inst:PushEvent("light", "on")
            end
        end

        inst:DoTaskInTime(0,light_fn)
        inst:WatchWorldState("isday", light_fn)
        inst:WatchWorldState("isdusk", light_fn)
        inst:WatchWorldState("isnight", light_fn)
    ------------------------------------------------------------------------------------------------
    -- ------------------------------------------------------------------------------------------------


    return inst
end




return Prefab("underworld_hana_fx_spriter_big", fn, assets)

--[[
            
        ThePlayer.__spriter = SpawnPrefab("underworld_hana_fx_spriter_big")
        ThePlayer.__spriter:PushEvent("Set",{
            player = ThePlayer,  --- 跟随目标
            range = 3,           --- 环绕点半径
            point_num = 15,       --- 环绕点
            -- new_pt_time = 0.5 ,    --- 新的跟踪点时间
            -- speed = 8,           --- 强制固定速度
            speed_mult = 2,      --- 速度倍速
            next_pt_dis = 0.5,      --- 触碰下一个点的距离
            speed_soft_delta = 20, --- 软增加
            y = 1.5,
            tail_time = 0.2,
        })

]]--