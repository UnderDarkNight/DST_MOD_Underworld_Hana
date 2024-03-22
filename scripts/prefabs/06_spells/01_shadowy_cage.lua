

--- 锁住目标
-- local lock_time = 2     --- 锁定时间
-- local warningtime = 0.5 ---- 警告震动时间
local function lock_target(target,lock_time,warningtime)
    local crash_flag,code = pcall(function()

                local function IsNearOther(pt, newpillars)
                    for i, v in ipairs(newpillars) do
                        if distsq(pt.x, pt.z, v.x, v.z) < 1 then
                            return true
                        end
                    end
                    return false
                end
                local function DoPillarsTarget(target,newpillars, map, x0, z0)

                    local padding =
                        (target:HasTag("epic") and 1) or
                        (target:HasTag("smallcreature") and 0) or
                        .75
                    local radius = math.max(1, target:GetPhysicsRadius(0) + padding)
                    local circ = PI2 * radius
                    local num = math.floor(circ / 1.4 + .5)
                
                    local period = 1 / num
                    local delays = {}
                    for i = 0, num - 1 do
                        table.insert(delays, i * period)
                    end
                
                    local platform = target:GetCurrentPlatform()
                    local flying = not platform and target:HasTag("flying")

                    local theta = math.random() * PI2
                    local delta = PI2 / num
                    for i = 1, num do
                        local pt = Vector3(x0 + math.cos(theta) * radius, 0, z0 - math.sin(theta) * radius)
                        if not IsNearOther(pt, newpillars) and
                            map:IsPassableAtPoint(pt.x, 0, pt.z, true) and
                            flying or (map:GetPlatformAtPoint(pt.x, pt.z) == platform) and
                            not map:IsGroundTargetBlocked(pt) then
                            local ent = SpawnPrefab("underworld_hana_fx_shadow_pillar")
                            ent:PushEvent("Set",{
                                    pt = Vector3(pt:Get()),
                                    time = lock_time or 3,
                                    warningtime = warningtime or 2,
                            })

                            newpillars[ent] = pt
                        end
                        theta = theta + delta
                    end                                   

                end
                local xx,yy,zz = target.Transform:GetWorldPosition()
                DoPillarsTarget(target,{},TheWorld.Map, xx, zz)

    end)
    if crash_flag == false then
        print("error : ")
        print(code)
    end
end


local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddNetwork()

    inst:AddTag("CLASSIFIED")



    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("Set",function(_,_table)
        if _table == nil then
            return
        end
        local target = _table.target
        local player = _table.player
        local lock_time = _table.lock_time or 2
        local warningtime = _table.warningtime or 0.5

        if not (target and target.Physics) then
            return
        end

        if target:HasTag("underworld_hana_spell_shadowy_cage.catched") then
            return
        end
        target:AddTag("underworld_hana_spell_shadowy_cage.catched")

        lock_target(target,lock_time,warningtime)
        local x,y,z = target.Transform:GetWorldPosition()
        
        inst:ListenForEvent("onremove",function()
            inst:Remove()
        end,target)

        local position_lock_task = inst:DoPeriodicTask(0.1,function()
            if target.Physics then
                target.Physics:Teleport(x,y,z)
            end
            target.Transform:SetPosition(x,y,z)
        end)
        -- target.Physics:SetActive(false)
        inst:DoTaskInTime(lock_time + warningtime,function()
            -- target.Physics:SetActive(true)
            position_lock_task:Cancel()
            target:RemoveTag("underworld_hana_spell_shadowy_cage.catched")
            -- print(" info underworld_hana_spell_shadowy_cage remove ")
            inst:Remove()
        end)
        inst.Ready = true
    end)

    inst:DoTaskInTime(0,function()
        if not inst.Ready then
            inst:Remove()
        end
    end)
    return inst
end

return Prefab("underworld_hana_spell_shadowy_cage", fn)