------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    对应的 sg 
    复制 官方的修改
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

AddStategraphState('wilson',State{  --- 代码来自 SGwilson.lua 的 attack，
    name = "underworld_hana_sg_jump_split",
    tags = { "doing", "busy", "nointerrupt", "nomorph", "pausepredict" },

    onenter = function(inst)

        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("atk_leap_pre")    ---- 434ms
        inst.AnimState:PushAnimation("atk_leap",false)  ---- 1167ms

        local buffaction = inst:GetBufferedAction()
        inst.sg.statemem._temp_face_pt = Vector3(0,0,0)
        if buffaction then
            if buffaction.pos then
                local x,y,z = buffaction:GetActionPoint():Get()                    
                inst:ForceFacePoint(x, y, z)
                inst.sg.statemem._temp_face_pt = Vector3(x,y,z)
            elseif buffaction.target then
                local x,y,z = buffaction.target.Transform:GetWorldPosition()
                inst:ForceFacePoint(x, y, z)
                inst.sg.statemem._temp_face_pt = Vector3(x,y,z)
            end                        
        end

        if inst.components.playercontroller ~= nil then
            inst.components.playercontroller:RemotePausePrediction()
        end
        inst.sg:SetTimeout(2)
    end,

    -- onupdate = function(inst, dt)

    -- end,

    timeline =
    {

        TimeEvent(0.434, function(inst)
            inst.Transform:SetEightFaced()
            inst.SoundEmitter:PlaySound("dontstarve/common/deathpoof")
            if inst.sg.statemem._temp_face_pt then
                inst:ForceFacePoint(inst.sg.statemem._temp_face_pt:Get())
                inst.sg.statemem._temp_face_pt = nil
            end
            inst:PerformBufferedAction()    --- 激活组件功能（传送等）
        end),
        TimeEvent( 0.434 + 10 * FRAMES, function(inst)
            inst.components.colouradder:PushColour("helmsplitter", .1, .1, 0, 0)
        end),
        TimeEvent( 0.434 + 11 * FRAMES, function(inst)
            inst.components.colouradder:PushColour("helmsplitter", .2, .2, 0, 0)
        end),
        TimeEvent( 0.434 + 12 * FRAMES, function(inst)
            inst.components.colouradder:PushColour("helmsplitter", .4, .4, 0, 0)
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon")
            inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh")
        end),
        TimeEvent( 0.434 + 13 * FRAMES, function(inst)
            inst.components.bloomer:PushBloom("helmsplitter", "shaders/anim.ksh", -2)
            inst.components.colouradder:PushColour("helmsplitter", 1, 1, 0, 0)
            inst.sg:RemoveStateTag("nointerrupt")
            ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .015, .5, inst, 20)
            inst.sg.statemem.weapon = inst.components.combat:GetWeapon()
            -- inst:PerformBufferedAction()
            -- DoHelmSplit(inst)
        end),
        TimeEvent( 0.434 + 14 * FRAMES, function(inst)
            inst.components.colouradder:PushColour("helmsplitter", .8, .8, 0, 0)
        end),
        TimeEvent( 0.434 + 15 * FRAMES, function(inst)
            inst.components.colouradder:PushColour("helmsplitter", .6, .6, 0, 0)
        end),
        TimeEvent( 0.434 + 16 * FRAMES, function(inst)
            inst.components.colouradder:PushColour("helmsplitter", .4, .4, 0, 0)
        end),
        TimeEvent( 0.434 + 17 * FRAMES, function(inst)
            inst.components.colouradder:PushColour("helmsplitter", .2, .2, 0, 0)
        end),
        TimeEvent( 0.434 + 18 * FRAMES, function(inst)
            inst.components.colouradder:PopColour("helmsplitter")
        end),
        TimeEvent( 0.434 + 19 * FRAMES, function(inst)
            inst.components.bloomer:PopBloom("helmsplitter")
        end),

    },


    ontimeout = function(inst)
        inst.sg:GoToState("idle", true)      
    end,

    events =
    {
        EventHandler("animover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
                inst.Transform:SetFourFaced()
            end
        end),
    },

    onexit = function(inst)
        inst.Transform:SetFourFaced()
    end,
})   ---------------- 没洞穴情况下工作正常
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------- client side
local TIMEOUT = 2
AddStategraphState('wilson_client',State{  ---- 代码来自 SGwilson_client.lua 的 attack，
    name = "underworld_hana_sg_jump_split",
    tags = { "doing", "busy", "nointerrupt", "nomorph", "pausepredict" },
    server_states = {"underworld_hana_sg_jump_split"},
    onenter = function(inst)
        inst.components.locomotor:Stop()
        inst.AnimState:PlayAnimation("atk_leap_pre")
        inst.AnimState:PlayAnimation("atk_leap_lag", false)

        inst:PerformPreviewBufferedAction()
        inst.sg:SetTimeout(TIMEOUT)
    end,

    onupdate = function(inst, dt)
        if inst.sg:ServerStateMatches() then
            if inst.entity:FlattenMovementPrediction() then
                inst.sg:GoToState("idle", "noanim")
            end
        elseif inst.bufferedaction == nil then
            inst.sg:GoToState("idle")
        end
    end,

    timeline =
    {
        -- TimeEvent(5 * FRAMES, function(inst)
        -- end),
        -- TimeEvent(6 * FRAMES, function(inst)
        -- end),
        -- TimeEvent(7 * FRAMES, function(inst)
        -- end),
        -- TimeEvent(8 * FRAMES, function(inst)
        -- end),
        -- TimeEvent(10 * FRAMES, function(inst)
        -- end),
        -- TimeEvent(17*FRAMES, function(inst)
        -- end),
    },

    ontimeout = function(inst)
        inst:ClearBufferedAction()
        inst.sg:GoToState("idle")
    end,

    events =
    {
        EventHandler("animqueueover", function(inst)
            if inst.AnimState:AnimDone() then
                inst.sg:GoToState("idle")
            end
        end),
    },

    onexit = function(inst)

    end,
})    ------------- 注意使用 inst.replica 判断后进入----不正常，无法连续攻击

------------------------------------------------------------------------------------------------------------------------------------------------------------------------