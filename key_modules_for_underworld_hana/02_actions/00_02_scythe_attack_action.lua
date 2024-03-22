------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    对应的 sg 
    复制 官方的修改
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    local hana_scythe_attack_state_server = State{  --- 代码来自 SGwilson.lua 的 attack，
        name = "hana_scythe_attack",
        tags = { "attack", "notalking", "abouttoattack", "autopredict" },

        onenter = function(inst)
            if inst.components.combat:InCooldown() then
                inst.sg:RemoveStateTag("abouttoattack")
                inst:ClearBufferedAction()
                inst.sg:GoToState("idle", true)
                return
            end
            if inst.sg.laststate == inst.sg.currentstate then
                inst.sg.statemem.chained = true
            end
            local buffaction = inst:GetBufferedAction()
            local target = buffaction ~= nil and buffaction.target or nil
            local equip = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
            inst.components.combat:SetTarget(target)
            inst.components.combat:StartAttack()
            inst.components.locomotor:Stop()
            local cooldown = inst.components.combat.min_attack_period

            if equip then
                equip:PushEvent("underworld_hana_event.action.scythe.onenter",{
                    player = inst,
                    target = target,
                })

                inst.sg.statemem.__temp_fns = {}
                inst.sg.statemem.__temp_fns.onhit = function()
                    equip:PushEvent("underworld_hana_event.action.scythe.onhit",{
                        player = inst,
                        target = target,
                    })
                end
                inst.sg.statemem.__temp_fns.onexit = function()
                    equip:PushEvent("underworld_hana_event.action.scythe.onexit",{
                        player = inst,
                        target = target,
                    })
                end
            end

            -- inst.AnimState:PlayAnimation("atk_pre")
            -- inst.AnimState:PushAnimation("atk", false)
            inst.AnimState:SetDeltaTimeMultiplier(1343/800)
            inst.AnimState:PlayAnimation("scythe_pre")
            inst.AnimState:PushAnimation("scythe_loop", false)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
            cooldown = math.max(cooldown, 13 * FRAMES)


            inst.sg:SetTimeout(cooldown)

            if target ~= nil then
                inst.components.combat:BattleCry()
                if target:IsValid() then
                    inst:FacePoint(target:GetPosition())
                    inst.sg.statemem.attacktarget = target
                    inst.sg.statemem.retarget = target
                end
            end
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
                ----------------------------------------------------------------------------
                    if inst.sg.statemem.__temp_fns and inst.sg.statemem.__temp_fns.onhit then
                        inst.sg.statemem.__temp_fns.onhit()
                    end
                ----------------------------------------------------------------------------
                inst:PerformBufferedAction()
                inst.sg:RemoveStateTag("abouttoattack")
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
            inst.sg.statemem.__temp_fns = nil
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
                    if inst.sg.statemem.__temp_fns and inst.sg.statemem.__temp_fns.onexit then
                        inst.sg.statemem.__temp_fns.onexit()
                    end
                    inst.sg.statemem.__temp_fns = nil
                ----------------------------------------------------------------------------
            end),
        },

        onexit = function(inst)
            ----------------------------------------------------------------------------
                if inst.sg.statemem.__temp_fns and inst.sg.statemem.__temp_fns.onexit then
                    inst.sg.statemem.__temp_fns.onexit()
                end
                inst.sg.statemem.__temp_fns = nil
            ----------------------------------------------------------------------------
            inst.components.combat:SetTarget(nil)
            if inst.sg:HasStateTag("abouttoattack") then
                inst.components.combat:CancelAttack()
            end
            inst.AnimState:SetDeltaTimeMultiplier(1)
        end,
    }
    AddStategraphState('wilson',hana_scythe_attack_state_server)   ---------------- 没洞穴情况下工作正常
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local hana_scythe_attack_state_client = State{  ---- 代码来自 SGwilson_client.lua 的 attack，
        name = "hana_scythe_attack",
        tags = { "attack", "notalking", "abouttoattack" },
        server_states = { "hana_scythe_attack" },

        onenter = function(inst)
			local combat = inst.replica.combat
			if combat:InCooldown() then
				inst.sg:RemoveStateTag("abouttoattack")
				inst:ClearBufferedAction()
				inst.sg:GoToState("idle", true)
				return
			end

			local cooldown = combat:MinAttackPeriod()
            if inst.sg.laststate == inst.sg.currentstate then
                inst.sg.statemem.chained = true
            end
			combat:StartAttack()
            inst.components.locomotor:Stop()

            
            -- inst.AnimState:PlayAnimation("atk_pre")
            -- inst.AnimState:PushAnimation("atk", false)
            inst.AnimState:SetDeltaTimeMultiplier(1343/800)
            inst.AnimState:PlayAnimation("scythe_pre")
            inst.AnimState:PushAnimation("scythe_loop", false)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
            if cooldown > 0 then
                cooldown = math.max(cooldown, 13 * FRAMES)
            end


			local buffaction = inst:GetBufferedAction()
            if buffaction ~= nil then
                inst:PerformPreviewBufferedAction()

                if buffaction.target ~= nil and buffaction.target:IsValid() then
                    inst:FacePoint(buffaction.target:GetPosition())
                    inst.sg.statemem.attacktarget = buffaction.target
                    inst.sg.statemem.retarget = buffaction.target
                end
            end

            if cooldown > 0 then
                inst.sg:SetTimeout(cooldown)
            end
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
            end),
        },

        onexit = function(inst)
			if inst.sg:HasStateTag("abouttoattack") then
                inst.replica.combat:CancelAttack()
            end
            inst.AnimState:SetDeltaTimeMultiplier(1)
        end,
    }
    AddStategraphState('wilson_client',hana_scythe_attack_state_client)    ------------- 注意使用 inst.replica 判断后进入----不正常，无法连续攻击

------------------------------------------------------------------------------------------------------------------------------------------------------------------------