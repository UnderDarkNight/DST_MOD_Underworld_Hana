------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 褪色的记忆
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local assets = {
    Asset("ANIM", "anim/underworld_hana_projectile_faded_memory.zip"),

}

--------------------------------------------------------------------------------
-- 尾巴
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

        -- MakeInventoryPhysics(inst)
        -- RemovePhysicsColliders(inst)


        inst.AnimState:SetBank("underworld_hana_projectile_faded_memory")
        inst.AnimState:SetBuild("underworld_hana_projectile_faded_memory")
        inst.AnimState:PlayAnimation("tail")
        inst.AnimState:SetDeltaTimeMultiplier(2)
        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
        -- local scale = 1.5
        -- inst.AnimState:SetScale(scale, scale, scale)
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

        local function create_single_tail()
            local x,y,z = inst.Transform:GetWorldPosition()
            local tail = CreateTail_Fx()
            local offset_x = math.random(30)/100
            local offset_z = math.random(30)/100
            if math.random(100) > 50 then
                offset_x = -offset_x
            end
            if math.random(100) > 50 then
                offset_z = -offset_z
            end
            tail.Transform:SetPosition(x+offset_x,y,z+offset_z)
        end
        inst:DoPeriodicTask(time,create_single_tail,0.5)
        inst:DoPeriodicTask(time/2,create_single_tail,0.8)
        inst:DoPeriodicTask(time/2,create_single_tail,0.3)
    end
--------------------------------------------------------------------------------
local function fn()

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
    RemovePhysicsColliders(inst)

    inst:AddTag("CLASSIFIED")
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
    inst:AddTag("projectile")

   
    inst.entity:SetPristine()

    inst.AnimState:SetBank("underworld_hana_projectile_faded_memory")
    inst.AnimState:SetBuild("underworld_hana_projectile_faded_memory")
    inst.AnimState:PlayAnimation("idle",true)
    -- local scaleNum = 0.5
    -- inst.AnimState:SetScale(scaleNum,scaleNum,scaleNum)

    -----------------------------------------------------------------------------------
        inst.__tail_deta_time_net_var = net_float(inst.GUID,"underworld_hana_projectile_faded_memory","underworld_hana_projectile_faded_memory")
    -----------------------------------------------------------------------------------
        CreateTails(inst)
    -----------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)

    -----------------------------------------------------------------------------------
        local function OnHit(inst, attacker, target)
            if target  then
                target:PushEvent("underworld_hana_projectile_faded_memory.onhit")
            end
            inst:Remove()
        end

        local function SeekSoulStealer(inst)
            local x, y, z = inst.Transform:GetWorldPosition()
            local closestPlayer = nil
            local theRange = 30


            local tarplayers = TheSim:FindEntities(x, 0, z, theRange, {"underworld_hana","player"}, {"playerghost"}, nil)
            if #tarplayers > 0 then
            closestPlayer = tarplayers[1]
            local nearest_dis = closestPlayer:GetDistanceSqToPoint(x,y,z)
            for k, theplayer in pairs(tarplayers) do
                    if theplayer:GetDistanceSqToPoint(x,y,z) < nearest_dis then
                        closestPlayer = theplayer
                    end
                end
            end

            if closestPlayer ~= nil then
                inst.components.projectile:Throw(inst, closestPlayer, inst)

                -- if closestPlayer.the_ufo and closestPlayer.the_ufo:IsValid() and math.random(100)>50 then ---- 有部分去ufo
                --     inst.components.projectile:Throw(inst, closestPlayer.the_ufo, inst)
                -- else
                --     inst.components.projectile:Throw(inst, closestPlayer, inst)
                -- end
            end
        end

        inst._seektask = inst:DoPeriodicTask(.5, SeekSoulStealer, math.random(35)/10)
    -----------------------------------------------------------------------------------
        inst:AddComponent("projectile")
        inst.components.projectile:SetSpeed(8)
        inst.components.projectile:SetHitDist(.5)
        -- inst.components.projectile:SetOnThrownFn(OnThrown)
        inst.components.projectile:SetOnHitFn(OnHit)
        inst.components.projectile:SetOnMissFn(inst.Remove)
    -----------------------------------------------------------------------------------
        inst:ListenForEvent("Set",function(_,_table)
            -- _table = {
            --     pt = Vector3(0,0,0),
            --     tail_time = 0.5,
            --     y = 0.5,
            --     speed = 8 ,
            -- }
            if type(_table) ~= "table" then
                return
            end

            if _table.pt then
                inst.Transform:SetPosition(_table.pt.x, _table.y or 0, _table.pt.z)
            end

            if _table.tail_time then
                inst.__tail_deta_time_net_var:set(_table.tail_time)
            end

            if _table.speed then
                inst.components.projectile:SetSpeed(_table.speed)
            end
        end)
    -----------------------------------------------------------------------------------
    return inst
end

return Prefab("underworld_hana_projectile_faded_memory", fn, assets)