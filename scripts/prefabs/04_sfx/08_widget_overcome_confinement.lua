------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local assets =
{
	Asset("ANIM", "anim/underworld_hana_widget_overcome_confinement.zip"),
}
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()


	
    inst.AnimState:SetBank("underworld_hana_widget_overcome_confinement")
    inst.AnimState:SetBuild("underworld_hana_widget_overcome_confinement")
    inst.AnimState:PlayAnimation("idle")


	
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


return Prefab("underworld_hana_fx_widget_overcome_confinement", fn, assets)