------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
	Asset("ANIM", "anim/underworld_hana_fx_spriter.zip"),
}
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddLight()
	inst.entity:AddDynamicShadow()

    -- local light = inst.entity:AddLight()
    -- inst.Light:Enable(false)
    -- inst.Light:SetRadius(2)
    -- inst.Light:SetFalloff(0.5)
    -- inst.Light:SetIntensity(.75)
    -- inst.Light:SetColour(121/255,235/255,12/255)		
	
	
	inst.AnimState:SetFinalOffset(0.5)
    inst.AnimState:SetBank("underworld_hana_fx_spriter")
    inst.AnimState:SetBuild("underworld_hana_fx_spriter")
    inst.AnimState:PlayAnimation("fx",true)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")


	
    inst:AddTag("INLIMBO")
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")      --- 不可点击
    inst:AddTag("CLASSIFIED")   --  私密的，client 不可观测， FindEntity 默认过滤
    inst:AddTag("NOBLOCK")      -- 不会影响种植和放置

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end



    return inst
end


return Prefab("underworld_hana_fx_spriter_mini", fn, assets)