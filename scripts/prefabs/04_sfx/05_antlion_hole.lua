----------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

]]--
----------------------------------------------------------------------------------------------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("sinkhole")
    inst.AnimState:SetBuild("antlion_sinkhole")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(2)

    inst.MiniMapEntity:SetIcon("sinkhole.png")

    inst.Transform:SetEightFaced()

    -- inst:AddTag("antlion_sinkhole")
    -- inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("NOCLICK")

    inst:SetDeployExtraSpacing(4)


    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:ListenForEvent("Set",function(inst,_table)
        -- _table = {
        --     target = inst,
        --     pt = Vector3(0,0,0),
        --     scale = Vector3(0,0,0)
        --     color = Vector3(255,255,255),
        --     a = 0.1,
        --     MultColour_Flag = false,
        --     time = 1,
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
        
        inst:DoTaskInTime(_table.time or 5,inst.Remove)
        
        inst.Ready = true

    end)
    inst:DoTaskInTime(0,function()
        if not inst.Ready then
            inst:Remove()
        end
    end)

    return inst
end

return Prefab("underworld_hana_fx_spell_antlion_hole", fn)