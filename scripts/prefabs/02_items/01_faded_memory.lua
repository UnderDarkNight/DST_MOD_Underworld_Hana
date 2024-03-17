



local assets =
{
    Asset("ANIM", "anim/underworld_hana_item_faded_memory.zip"),

    Asset( "IMAGE", "images/inventoryimages/underworld_hana_item_faded_memory.tex" ),
    Asset( "ATLAS", "images/inventoryimages/underworld_hana_item_faded_memory.xml" ),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddNetwork()
    inst.entity:AddDynamicShadow()

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("underworld_hana_item_faded_memory")
    inst.AnimState:SetBuild("underworld_hana_item_faded_memory")
    inst.AnimState:PlayAnimation("idle",true)
    -- inst.AnimState:SetTime(math.random(8000)/1000)
    local scale = 2
    inst.AnimState:SetScale(scale,scale, scale)
    -- inst.DynamicShadow:SetSize(1.5,0.7)
    -- inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")



	MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "med", nil, 0.77)
    inst.entity:SetPristine()
    ------------------------------------------------------------------------------
    ---- 右键使用

        inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_workable",function(inst,replica_com)
            replica_com:SetText("underworld_hana_item_faded_memory",STRINGS.ACTIONS.USEITEM)
            replica_com:SetSGAction("doshortaction")
            replica_com:SetTestFn(function(inst,doer)
                if doer and doer:HasTag("underworld_hana") and inst.replica.inventoryitem:IsGrandOwner(doer) then
                    return true
                end
                return true
            end)
        end)
        if TheWorld.ismastersim then
            inst:AddComponent("hana_com_workable")
            inst.components.hana_com_workable:SetActiveFn(function(inst,doer)
                inst.components.stackable:Get():Remove()
                doer:PushEvent("faded_memory_used")
                doer.components.health:DoDelta(1)
                return true
            end)
        end
    ------------------------------------------------------------------------------
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "underworld_hana_item_faded_memory"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_item_faded_memory.xml"


    inst:AddComponent("stackable")  -- 可叠堆
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_TINYITEM  -- 60

    MakeHauntableLaunch(inst)



    return inst
end

return Prefab("underworld_hana_item_faded_memory", fn, assets)
