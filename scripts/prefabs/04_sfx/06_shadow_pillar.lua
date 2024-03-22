local assets = {
    -- Asset("IMAGE", "images/inventoryimages/spell_reject_the_npc.tex"),
	-- Asset("ATLAS", "images/inventoryimages/spell_reject_the_npc.xml"),
	-- Asset("ANIM", "anim/npc_fx_chat_bubble.zip"),
}
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local NUM_VARIATIONS = 6
    local VARIATIONS_POOL = {}
    for i = 1, NUM_VARIATIONS do
        table.insert(VARIATIONS_POOL, math.random(#VARIATIONS_POOL + 1), i)
    end
    local function GetNextVariation()
        local rnd = math.random()
        --higher chance to pick first entry, no chance to pick last entry
        rnd = math.floor(rnd * rnd * (NUM_VARIATIONS - 1)) + 1
        rnd = table.remove(VARIATIONS_POOL, rnd)
        table.insert(VARIATIONS_POOL, rnd)
        return rnd
    end
    local LAST_FLIPPED = false
    local function GetNextFlipped() --- 镜像
        if math.random() < .65 then
            LAST_FLIPPED = not LAST_FLIPPED
        end
        return LAST_FLIPPED
    end
    local function DoSplash(inst)
        if TheWorld.Map:IsOceanAtPoint(inst.Transform:GetWorldPosition()) then
            SpawnPrefab("ocean_splash_med"..tostring(math.random(2))).Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local function fx()
    local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	--Not fx, otherwise walkableplatform can't detect
	--inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("shadow_pillar")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("ignorewalkableplatformdrowning")

	inst.AnimState:SetBank("shadow_pillar")
	inst.AnimState:SetBuild("shadow_pillar")
	inst.AnimState:SetSymbolMultColour("shad_spot2", 1, 1, 1, .75)
	inst.AnimState:SetSymbolMultColour("shadow2", 1, 1, 1, .75)



	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("entitytracker")

    inst:ListenForEvent("Set",function(_,_table)
        -- _table = {
        --     pt = Vector3(0,0,0),
        --     time = 1,
        --     warningtime = 0，
        -- }
        if _table == nil then
            return
        end

        if type(_table.pt) == "table" and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x, 0, _table.pt.z)
        end
        -------------------------------------------------------------------------
        --- 镜像
            if GetNextFlipped() then
                inst.AnimState:SetScale(-1, 1, 1)
            end
        -------------------------------------------------------------------------
        --- 动画版本
            inst.variation = GetNextVariation()
        -------------------------------------------------------------------------
        --- 升起来
            inst.AnimState:PlayAnimation("pre"..tostring(inst.variation))
            inst.SoundEmitter:PlaySound("maxwell_rework/shadow_pillar/pre")
            inst.AnimState:PushAnimation("idle"..tostring(inst.variation))
            DoSplash(inst)
            SpawnPrefab("sanity_raise").Transform:SetPosition(inst.Transform:GetWorldPosition())

        -------------------------------------------------------------------------
        --- 持续时间
            inst:DoTaskInTime(_table.time or 1,function()
                
                if _table.warningtime then
                    inst.AnimState:PlayAnimation("shake"..tostring(inst.variation), true)
                    inst.SoundEmitter:PlaySound("maxwell_rework/shadow_pillar/rumble", "rumble")
                    inst:DoTaskInTime(_table.warningtime,function()
                        inst:PushEvent("down")                        
                    end)
                else
                    inst:PushEvent("down")
                end
            end)
        -------------------------------------------------------------------------
        ---- 下降
            inst:ListenForEvent("down",function()
                inst.SoundEmitter:PlaySound("dontstarve/sanity/shadowrock_down")
                SpawnPrefab("sanity_lower").Transform:SetPosition(inst.Transform:GetWorldPosition())
                inst.AnimState:PlayAnimation("pst"..tostring(inst.variation))
                inst.SoundEmitter:KillSound("rumble")
                inst.persists = false
                inst:ListenForEvent("animover",function()
                    inst:Remove()
                end)
                inst:DoTaskInTime(10 * FRAMES, DoSplash)
            end)
        -------------------------------------------------------------------------

        -------------------------------------------------------------------------

        inst.Ready = true
    end)

    inst:DoTaskInTime(0,function()
        if inst.Ready ~= true then
            inst:Remove()
        end
    end)

    return inst
end

return Prefab("underworld_hana_fx_shadow_pillar",fx,assets)