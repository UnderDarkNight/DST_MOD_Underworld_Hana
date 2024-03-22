local assets =
{
	Asset("ANIM", "anim/underworld_hana_weapon_gift.zip"),
	Asset("ANIM", "anim/underworld_hana_weapon_gift_swap.zip"),
	Asset( "IMAGE", "images/inventoryimages/underworld_hana_weapon_gift.tex" ),
    Asset( "ATLAS", "images/inventoryimages/underworld_hana_weapon_gift.xml" ),
}


local function OnHit(inst, attacker, target)
	local x, y, z = inst.Transform:GetWorldPosition()

	inst.SoundEmitter:KillSound("toss")
    --------------------------------------------------------------------------------
        local players = TheSim:FindEntities(x, y, z, 8, {"playerghost"}, nil, nil)
        for k, temp_player in pairs(players) do
            temp_player:PushEvent("respawnfromghost", { source = attacker })
        end
    --------------------------------------------------------------------------------
        local canthavetags = { "companion","isdead","player","INLIMBO", "notarget", "noattack", "flight", "invisible", "playerghost" ,"chester","hutch","wall","structure"}
        local musthavetags = nil
        local musthaveoneoftags = {"pig","rabbit","animal","smallcreature","epic","monster","insect","merm"}
        local monsters = TheSim:FindEntities(x, 0, z, 8, musthavetags, canthavetags, musthaveoneoftags)
        for k, temp_monster in pairs(monsters) do
            if temp_monster and temp_monster.components.combat then
                temp_monster:AddTag("underworld_hana_attracting_monster_blocker")
                temp_monster.components.combat:DropTarget(false)
                temp_monster.components.combat:SetTarget(nil)
                temp_monster.components.combat.target = nil
            end
        end
    --------------------------------------------------------------------------------

	SpawnPrefab("bomb_lunarplant_explode_fx").Transform:SetPosition(x, y, z)
    inst:Remove()
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "underworld_hana_weapon_gift_swap", "swap_object")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")



end

local function onunequip(inst, owner)
	owner.AnimState:ClearOverrideSymbol("swap_object")
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")



end

local FX_TICKS = 30
local MAX_ADD_COLOUR = .6

local function UpdateSpin(inst, ticks)
	inst.spinticks:set_local(inst.spinticks:value() + ticks)
	--V2C: hack alert: using SetHightlightColour to achieve something like OverrideAddColour
	--     (that function does not exist), because we know this FX can never be highlighted!
	if inst.spinticks:value() < FX_TICKS then
		local k = inst.spinticks:value() / FX_TICKS
		k = k * k * MAX_ADD_COLOUR
		inst.AnimState:SetHighlightColour(k, k, k, 0)
		inst.AnimState:OverrideMultColour(1, 1, 1, k)
		if inst.core ~= nil then
			inst.core.AnimState:SetAddColour(k, k, k, 0)
			inst.core.AnimState:SetLightOverride(k / 3)
		end
	else
		inst.AnimState:SetHighlightColour(MAX_ADD_COLOUR, MAX_ADD_COLOUR, MAX_ADD_COLOUR, 0)
		inst.AnimState:OverrideMultColour(1, 1, 1, MAX_ADD_COLOUR)
		if inst.core ~= nil then
			inst.core.AnimState:SetAddColour(MAX_ADD_COLOUR, MAX_ADD_COLOUR, MAX_ADD_COLOUR, 0)
			inst.core.AnimState:SetLightOverride(MAX_ADD_COLOUR / 3)
		end
		inst.spintask:Cancel()
		inst.spintask = nil
	end
end

local function CreateSpinCore()
	local inst = CreateEntity()

	inst:AddTag("FX")
	--[[Non-networked entity]]
	if not TheWorld.ismastersim then
		inst.entity:SetCanSleep(false)
	end
	inst.persists = false

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddFollower()

	inst.AnimState:SetBank("bomb_lunarplant")
	inst.AnimState:SetBuild("underworld_hana_weapon_gift")
	inst.AnimState:PlayAnimation("spin_idle")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

	return inst
end

local function OnSpinTicksDirty(inst)
	if inst.spintask == nil then
		inst.spintask = inst:DoPeriodicTask(0, UpdateSpin, nil, 1)
		--Dedicated server does not need to trigger sfx
		if not TheNet:IsDedicated() then
			--restore teh bomb core at full opacity, since we're fading in the entire
			--entity to fadein the light rays (easier that way to optimize networking!)
			inst.core = CreateSpinCore()
			inst.core.entity:SetParent(inst.entity)
			inst.core.Follower:FollowSymbol(inst.GUID, "bomb_lunarplant_follow", nil, nil, nil, true)
		end
	end
	UpdateSpin(inst, 0)
end

local function onthrown(inst, attacker)
	inst:AddTag("NOCLICK")
	inst.persists = false

	inst.ispvp = attacker ~= nil and attacker:IsValid() and attacker:HasTag("player")

	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	inst.AnimState:PlayAnimation("spin_loop", true)
	inst.AnimState:SetLightOverride(1)

	inst.SoundEmitter:PlaySound("rifts/lunarthrall_bomb/throw", "toss")

	inst.Physics:SetMass(1)
	inst.Physics:SetFriction(0)
	inst.Physics:SetDamping(0)
	inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
	inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(COLLISION.GROUND)
	inst.Physics:CollidesWith(COLLISION.OBSTACLES)
	inst.Physics:CollidesWith(COLLISION.ITEMS)
	inst.Physics:SetCapsule(.2, .2)

	inst.spinticks:set(3)
	OnSpinTicksDirty(inst)
end

local function ReticuleTargetFn()
	local player = ThePlayer
	local ground = TheWorld.Map
	local pos = Vector3()
	--Attack range is 8, leave room for error
	--Min range was chosen to not hit yourself (2 is the hit range)
	for r = 6.5, 3.5, -.25 do
		pos.x, pos.y, pos.z = player.entity:LocalToWorldSpace(r, 0, 0)
		if ground:IsPassableAtPoint(pos:Get()) and not ground:IsGroundTargetBlocked(pos) then
			return pos
		end
	end
	return pos
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetTwoFaced()

	MakeInventoryPhysics(inst)

	inst:AddTag("toughworker")
	inst:AddTag("explosive")

	--projectile (from complexprojectile component) added to pristine state for optimization
	inst:AddTag("projectile")

	inst.AnimState:SetBank("bomb_lunarplant")
	inst.AnimState:SetBuild("underworld_hana_weapon_gift")
	inst.AnimState:PlayAnimation("idle")

	inst:AddComponent("reticule")
	inst.components.reticule.targetfn = ReticuleTargetFn
	inst.components.reticule.ease = true

	--weapon (from weapon component) added to pristine state for optimization
	inst:AddTag("weapon")

	MakeInventoryFloatable(inst, "small", 0.1, 0.8)

	inst.spinticks = net_smallbyte(inst.GUID, "bomb_lunarplant.spinticks", "spinticksdirty")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		inst:ListenForEvent("spinticksdirty", OnSpinTicksDirty)

		return inst
	end

	inst:AddComponent("locomotor")

	inst:AddComponent("complexprojectile")
	-- inst.components.complexprojectile:SetHorizontalSpeed(15)
	inst.components.complexprojectile:SetHorizontalSpeed(30)    --- 飞高速度
	-- inst.components.complexprojectile:SetGravity(-35)           --- 重力参数
	inst.components.complexprojectile:SetGravity(-70)           --- 重力参数
	inst.components.complexprojectile:SetLaunchOffset(Vector3(0.25, 1, 0))  -- 发射初始偏移坐标
	inst.components.complexprojectile:SetOnLaunch(onthrown)
	inst.components.complexprojectile:SetOnHit(OnHit)

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(0)
	inst.components.weapon:SetRange(20, 25)

	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem:ChangeImageName("bomb_lunarplant")
    inst.components.inventoryitem.imagename = "underworld_hana_weapon_gift"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_weapon_gift.xml"
	inst:AddComponent("stackable")

	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)
	inst.components.equippable.equipstack = true

	MakeHauntableLaunch(inst)

	return inst
end

--------------------------------------------------------------------------

--------------------------------------------------------------------------

return Prefab("underworld_hana_weapon_gift", fn, assets)
