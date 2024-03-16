------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
    对应的 sg 
    复制 官方的修改
]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------


AddStategraphState('wilson',State{  --- 代码来自 SGwilson.lua 的 attack，
    name = "underworld_hana_sg_equip",
    tags = {"idle", "canrotate"},

    onenter = function(inst)

        inst:PerformBufferedAction()
        if inst.sg then
            inst.sg:GoToState("idle")
        end
    end,

    onupdate = function(inst, dt)

    end,

    timeline =
    {
        
    },


    ontimeout = function(inst)
    
    end,

    events =
    {

    },

    onexit = function(inst)

    end,
}) 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------- client side
local TIMEOUT = 2
AddStategraphState('wilson_client',State{  ---- 代码来自 SGwilson_client.lua 的 attack，
    name = "underworld_hana_sg_equip",
    tags = {"idle", "canrotate"},
    server_states = { "underworld_hana_sg_equip" },


    onenter = function(inst)
        if inst.sg then
            inst.sg:GoToState("idle")
        end
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

    },

    ontimeout = function(inst)

    end,

    events =
    {

    },

    onexit = function(inst)

    end,
})

------------------------------------------------------------------------------------------------------------------------------------------------------------------------