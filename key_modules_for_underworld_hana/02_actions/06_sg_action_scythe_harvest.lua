------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    对应的 sg 
    复制 官方的修改
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local underworld_hana_scythe_harvest_state_server = State{  --- 代码来自 SGwilson.lua 的 attack，
        name = "underworld_hana_scythe_harvest",
        tags = { "busy","canrotate" ,"underworld_hana_scythe_harvest"},

        onenter = function(inst)

            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
            inst.components.locomotor:Stop()

            inst.AnimState:SetDeltaTimeMultiplier(1343/800)
            inst.AnimState:PlayAnimation("scythe_pre")
            inst.AnimState:PushAnimation("scythe_loop", false)

            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)

            local buffaction = inst:GetBufferedAction()
            if buffaction then
                if buffaction.pos then
                    local x,y,z = buffaction:GetActionPoint():Get()                    
                    inst:ForceFacePoint(x, y, z)
                elseif buffaction.target then
                    local x,y,z = buffaction.target.Transform:GetWorldPosition()
                    inst:ForceFacePoint(x, y, z)
                end                        
            end

            local cooldown = 13 * FRAMES
         

            inst.sg:SetTimeout(cooldown)
        end,

        onupdate = function(inst, dt)

        end,

        timeline =
        {
            TimeEvent(0, function(inst)
            end),
            TimeEvent(6 * FRAMES, function(inst)
            end),
            TimeEvent(7 * FRAMES, function(inst)
            end),
            TimeEvent(8 * FRAMES, function(inst)
                ----------------------------------------------------------------------------

                ----------------------------------------------------------------------------
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("canrotate")
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
            end),
            TimeEvent(10 * FRAMES, function(inst)

            end),
            TimeEvent(17*FRAMES, function(inst)

            end),
        },


        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
            inst.AnimState:SetDeltaTimeMultiplier(1)            
        end,

        events =
        {
            EventHandler("equip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("unequip", function(inst) inst.sg:GoToState("idle") end),
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
                inst.AnimState:SetDeltaTimeMultiplier(1)
                ----------------------------------------------------------------------------
                    if inst.components.playercontroller ~= nil then
                        inst.components.playercontroller:Enable(true)
                    end
                ----------------------------------------------------------------------------
            end),
        },

        onexit = function(inst)
            ----------------------------------------------------------------------------
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
            inst.AnimState:SetDeltaTimeMultiplier(1)
        end,
    }
    AddStategraphState('wilson',underworld_hana_scythe_harvest_state_server)   ---------------- 没洞穴情况下工作正常
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------- client side
    local underworld_hana_scythe_harvest_state_client = State{  ---- 代码来自 SGwilson_client.lua 的 attack，
        name = "underworld_hana_scythe_harvest",
        tags = { "busy" ,"canrotate","underworld_hana_scythe_harvest"},

        onenter = function(inst)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
            inst.components.locomotor:Stop()

            inst.AnimState:SetDeltaTimeMultiplier(1343/800)
            inst.AnimState:PlayAnimation("scythe_pre")
            inst.AnimState:PushAnimation("scythe_loop", false)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
            local cooldown = 13 * FRAMES

			local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                local pt = buffaction.pos
                if pt and pt.x then
                    inst:ForceFacePoint(pt.x, 0, pt.z)
                end
                inst:PerformPreviewBufferedAction()
            end
            inst.sg:SetTimeout(cooldown)
        end,

        onupdate = function(inst, dt)

        end,

        timeline =
        {
            TimeEvent(5 * FRAMES, function(inst)
            end),
            TimeEvent(6 * FRAMES, function(inst)
            end),
            TimeEvent(7 * FRAMES, function(inst)
            end),
            TimeEvent(8 * FRAMES, function(inst)
                inst.sg:RemoveStateTag("abouttoattack")
                inst.sg:RemoveStateTag("busy")
                inst.sg:RemoveStateTag("canrotate")
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
            end),
            TimeEvent(10 * FRAMES, function(inst)
            end),
            TimeEvent(17*FRAMES, function(inst)
            end),
        },

        ontimeout = function(inst)
            inst.sg:RemoveStateTag("attack")
            inst.sg:AddStateTag("idle")
            inst.AnimState:SetDeltaTimeMultiplier(1)
        end,

        events =
        {
            EventHandler("animqueueover", function(inst)
                if inst.AnimState:AnimDone() then
                    inst.sg:GoToState("idle")
                end
                inst.AnimState:SetDeltaTimeMultiplier(1)
                if inst.components.playercontroller ~= nil then
                    inst.components.playercontroller:Enable(true)
                end
            end),
        },

        onexit = function(inst)

            inst.AnimState:SetDeltaTimeMultiplier(1)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
        end,
    }
    AddStategraphState('wilson_client',underworld_hana_scythe_harvest_state_client)    ------------- 注意使用 inst.replica 判断后进入----不正常，无法连续攻击

------------------------------------------------------------------------------------------------------------------------------------------------------------------------