------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]
------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets = {
    -- Asset("IMAGE", "images/inventoryimages/spell_reject_the_npc.tex"),
	-- Asset("ATLAS", "images/inventoryimages/spell_reject_the_npc.xml"),
	-- Asset("ANIM", "anim/npc_fx_chat_bubble.zip"),
}
local LIGHTNING_MAX_DIST_SQ = 40*40
local function PlayThunderSound(lighting)
	if not lighting:IsValid() or TheFocalPoint == nil then
		return
	end

    local pos = Vector3(lighting.Transform:GetWorldPosition())
    local pos0 = Vector3(TheFocalPoint.Transform:GetWorldPosition())
    local diff = pos - pos0
    local distsq = diff:LengthSq()

	local k = math.max(0, math.min(1, distsq / LIGHTNING_MAX_DIST_SQ))
	local intensity = math.min(1, k * 1.1 * (k - 2) + 1.1)
	if intensity <= 0 then
		return
	end

    local minsounddist = 10
    local normpos = pos
    if distsq > minsounddist * minsounddist then
    --Sound needs to be played closer to us if lightning is too far from player
        local normdiff = diff * (minsounddist / math.sqrt(distsq))
        normpos = pos0 + normdiff
    end

    local inst = CreateEntity()

    --[[Non-networked entity]]

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()

    inst.Transform:SetPosition(normpos:Get())
    inst.SoundEmitter:PlaySound("dontstarve/rain/thunder_close", nil, intensity, true)

    inst:Remove()
end
local function fx()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")      --- 不可点击
    inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
    inst:AddTag("NOBLOCK")      -- 不会影响种植和放置

    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)
    inst.AnimState:SetBank("lightning")
    inst.AnimState:SetBuild("lightning")
    inst.AnimState:PlayAnimation("anim",false)

    -- inst:ListenForEvent("animover", inst.Remove)
    -- inst:ListenForEvent("animqueueover", inst.Remove)

    if not TheNet:IsDedicated() then
        inst:DoTaskInTime(0, PlayThunderSound)
    end
    
    if not TheWorld.ismastersim then
        return inst
    end
    -- inst.components.colouradder:OnSetColour(139/255,34/255,34/255,0.1)
    inst:ListenForEvent("Set",function(_,_table)
        -- _table = {
        --     target = inst,
        --     pt = Vector3(0,0,0),
        --     scale = Vector3(0,0,0)
        --     color = Vector3(255,255,255),
        --     a = 0.1,
        --     MultColour_Flag = false,
        --     animover_fn = nil
        -- }
        if _table == nil then
            return
        end
        if _table.pt and _table.pt.x then
            inst.Transform:SetPosition(_table.pt.x,_table.pt.y,_table.pt.z)
        end
        if _table.target then
            inst.Transform:SetPosition(_table.target.Transform:GetWorldPosition())
        end

        if _table.scale then
            if type(_table.scale) == "table" then
                inst.AnimState:SetScale(_table.scale.x, _table.scale.y, _table.scale.z)
            elseif type(_table.scale) == "number" then
                inst.AnimState:SetScale(_table.scale, _table.scale, _table.scale)
            end                    
        end

        _table.color = _table.color or _table.colour
        if _table.color and _table.color.x then
            if _table.MultColour_Flag ~= true then
                inst:AddComponent("colouradder")
                inst.components.colouradder:OnSetColour(_table.color.x/255 , _table.color.y/255 , _table.color.z/255 , _table.a or 1)
            else
                inst.AnimState:SetMultColour(_table.color.x,_table.color.y, _table.color.z, _table.a or 1)
            end
        end

        inst:ListenForEvent("animover",function()
            if _table.animover_fn then
                _table.animover_fn()
            end
        end)

        inst.SoundEmitter:PlaySound("dontstarve/rain/thunder_close", nil, nil, true)
        inst.Ready = true
    end)
    inst:DoTaskInTime(0,function()
        if not inst.Ready then
            inst:Remove()
        end
    end)

    return inst
end

return Prefab("underworld_hana_fx_spell_lightning",fx,assets)