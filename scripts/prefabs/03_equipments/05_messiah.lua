------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    弥赛亚

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local function GetStringsTable(prefab_name)
        return TUNING["underworld_hana.fn"].GetStringsTable(prefab_name or "underworld_hana_weapon_messiah")
    end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----
    local CD_TIME = TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 1 or 10
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local assets =
    {
        Asset("ANIM", "anim/underworld_hana_weapon_messiah.zip"),
        Asset("ANIM", "anim/underworld_hana_weapon_messiah_swap.zip"),
        Asset( "IMAGE", "images/inventoryimages/underworld_hana_weapon_messiah.tex" ),
        Asset( "ATLAS", "images/inventoryimages/underworld_hana_weapon_messiah.xml" ),


    }
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    local function onequip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "underworld_hana_weapon_messiah_swap", "swap_object")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
        if inst.____light_fx then
            inst.____light_fx:Remove()
        end
        local fx = SpawnPrefab("underworld_hana_weapon_messiah_fx")
        fx.entity:SetParent(owner.entity)
        fx.entity:AddFollower()
        fx.Follower:FollowSymbol(owner.GUID, "swap_object",45, -200, 1)
        fx.Light:Enable(true)

        fx:Hide()
        fx.Light:Enable(false)

        inst.____light_fx = fx
    end

    local function onunequip(inst, owner)
        owner.AnimState:ClearOverrideSymbol("swap_object")
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
        if inst.____light_fx then
            inst.____light_fx:Remove()
            inst.____light_fx = nil
        end
    end
------------------------------------------------------------------------------------------------------------------
--- 施法
    local function CastSpell(inst,doer)
        ----------------------------------------------------------------------------------------
        -------
            local x,y,z = doer.Transform:GetWorldPosition()
        ----------------------------------------------------------------------------------------
        ------ 给玩家加血
            local around_players = TheSim:FindEntities(x, y, z, 20, {"player"}, {"playerghost"}, nil)
            for k, temp_player in pairs(around_players) do
                if temp_player and temp_player.components.health then
                    temp_player.components.health:DoDelta(30)
                end
            end
        ----------------------------------------------------------------------------------------
        ----- 恐惧周围一圈怪物
            local musthavetags = nil
            local canthavetags = {"burnt","player","INLIMBO", "notarget", "noattack", "flight", "invisible","companion"}
            local musthaveoneoftags = nil
            local monsters = TheSim:FindEntities(x, y, z, 20, musthavetags, canthavetags, musthaveoneoftags)
            for k, temp_monster in pairs(monsters) do
                if temp_monster and temp_monster:IsValid() and temp_monster.components.hauntable then
                    temp_monster.components.hauntable:Panic(3)
                end
            end
        ----------------------------------------------------------------------------------------
        ---- 特殊效果 
            if not inst:HasTag("nightstick") then
                return
            end
        ----------------------------------------------------------------------------------------
        --- 灯光
            inst:PushEvent("light_fx_on")
            if inst.__light_off_task then
                inst.__light_off_task:Cancel()
            end
            inst.__light_off_task = inst:DoTaskInTime(TUNING.UNDERWORLD_HANA_DEBUGGING_MODE and 10 or 30,function()
                inst:PushEvent("light_fx_off")
                inst.__light_off_task = nil
            end)
        ----------------------------------------------------------------------------------------
        --- 让世界降雨
            TheWorld:PushEvent("ms_deltamoisture", 50000)
        ----------------------------------------------------------------------------------------
        --- 对玩家造成20点伤害（除了自己）
            for k, temp_player in pairs(around_players) do
                if temp_player and temp_player.components.combat and temp_player ~= doer then
                    temp_player:DoTaskInTime(math.random(0,5)/10,function()
                        SpawnPrefab("underworld_hana_fx_spell_lightning"):PushEvent("Set",{
                            target = temp_player,
                            animover_fn = function()
                                temp_player.components.combat:GetAttacked(nil,20)
                                if temp_player.components.playerlightningtarget then
                                    temp_player.components.playerlightningtarget:DoStrike()
                                end
                            end
                        })
                    end)
                    -- temp_player.components.combat:GetAttacked(nil,20)
                end
            end
        ----------------------------------------------------------------------------------------
        --- 对周围一圈怪造成 100 伤害，boss 为200
            for k, temp_monster in pairs(monsters) do
                if temp_monster and temp_monster:IsValid() and temp_monster.components.combat and temp_monster.components.combat:CanBeAttacked(doer) then
                    temp_monster:DoTaskInTime(math.random(0,5)/10,function()
                        local damage = 100
                        if temp_monster:HasTag("epic") then
                            damage = 200
                        end
                        SpawnPrefab("underworld_hana_fx_spell_lightning"):PushEvent("Set",{
                            target = temp_monster,
                            animover_fn = function()
                                temp_monster.components.combat:GetAttacked(doer,damage)

                            end
                        })
                    end)
                end
            end
        ----------------------------------------------------------------------------------------
    end
------------------------------------------------------------------------------------------------------------------
---- 
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("underworld_hana_weapon_messiah")
        inst.AnimState:SetBuild("underworld_hana_weapon_messiah")
        inst.AnimState:PlayAnimation("idle",true)

        --weapon (from weapon component) added to pristine state for optimization
        inst:AddTag("weapon")
        inst:AddTag("underworld_hana_weapon_messiah")

        MakeInventoryFloatable(inst, "med", 0.05, {0.85, 0.45, 0.85})


        inst.entity:SetPristine()
        -------------------------------------------------------------------------------------
        --- 技能
            inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_point_and_target_spell_caster",function(inst,replica_com)
                replica_com:SetText("underworld_hana_weapon_messiah",GetStringsTable()["spell_str"])
                replica_com:SetSGAction("castspell")    -- 施法的SG
                replica_com:SetDistance(20)
                replica_com:SetPriority(999)
                replica_com:SetAllowCanCastOnImpassable(true)
                replica_com:SetTestFn(function(inst,doer,target,pt,right_click)     --- 以30FPS 执行，注意CPU性能消耗
                    if not inst:HasTag("nightstick") then
                        return false
                    end
                    -- pcall(function()
                    --     print(inst.replica.inventoryitem.classified.recharge:value())
                    -- end)
                    if right_click and doer ~= target then
                        if inst.replica.inventoryitem.classified and inst.replica.inventoryitem.classified.recharge:value() == 180 then
                            return true
                        end
                    end
                    return false
                end)

            end)
            if TheWorld.ismastersim then
                inst:AddComponent("hana_com_point_and_target_spell_caster")
                inst.components.hana_com_point_and_target_spell_caster:SetSpellFn(function(inst,doer,target,pt)
                    ------------------------------------------------------------------------------------
                    --- 冷却
                        if not inst.components.rechargeable:IsCharged() then
                            return true
                        end
                    ------------------------------------------------------------------------------------
                    --- 施法
                        CastSpell(inst,doer)
                    ------------------------------------------------------------------------------------
                    --- CD
                        inst.components.rechargeable:Discharge(CD_TIME)
                    ------------------------------------------------------------------------------------
                    --- 耐久
                        inst.components.finiteuses:Use(3)
                    ------------------------------------------------------------------------------------
                    --- 消耗San
                        if doer.components.sanity then
                            doer.components.sanity:DoDelta(-10)
                        end
                    ------------------------------------------------------------------------------------
                    return true
                end)
            end
        -------------------------------------------------------------------------------------
        --- 物品接受 nightstick
            inst:ListenForEvent("underworld_hana.OnEntityReplicated.hana_com_acceptable",function(inst,replica_com)
                replica_com:SetSGAction("dolongaction")
                replica_com:SetTestFn(function(inst,item,doer)
                    if item.prefab ~= "nightstick" then
                        return false
                    end
                    if inst:HasTag("nightstick") then
                        return false
                    else
                        return true
                    end
                    return false
                end)
                replica_com:SetText("underworld_hana_weapon_messiah",GetStringsTable()["unlock_str"])
            end)
            if TheWorld.ismastersim then
                inst:AddComponent("hana_com_acceptable")
                inst.components.hana_com_acceptable:SetOnAcceptFn(function(inst,item,doer)
                    if item.components.stackable then
                        item.components.stackable:Get():Remove()
                    else
                        item:Remove()
                    end
                    inst:AddTag("nightstick")
                    inst.components.hana_com_data:Set("nightstick",true)
                    return true
                end)
                ---- 记录已经添加过 晨星法杖
                inst:AddComponent("hana_com_data")
                inst.components.hana_com_data:AddOnLoadFn(function(com)
                    if com:Get("nightstick") then
                        inst:AddTag("nightstick")
                    end
                end)
            end
        -------------------------------------------------------------------------------------
        if not TheWorld.ismastersim then
            return inst
        end

        ------------------------------------------------------------------------------
        ---- 开关灯
            inst:ListenForEvent("light_fx_on",function()
                if inst.____light_fx then
                    inst.____light_fx:Show()
                    inst.____light_fx.Light:Enable(true)
                end
            end)
            inst:ListenForEvent("light_fx_off",function()
                if inst.____light_fx then
                    inst.____light_fx:Hide()
                    inst.____light_fx.Light:Enable(false)
                end
            end)
        ------------------------------------------------------------------------------
            inst:AddComponent("weapon")
            inst.components.weapon:SetDamage(0)
        ------------------------------------------------------------------------------
        --- 位面伤害
            inst:AddComponent("planardamage")
            inst.components.planardamage:SetBaseDamage(0)
        ------------------------------------------------------------------------------
            inst:AddComponent("inspectable")

            inst:AddComponent("inventoryitem")
            -- inst.components.inventoryitem:ChangeImageName("voidcloth_scythe")
            inst.components.inventoryitem.imagename = "underworld_hana_weapon_messiah"
            inst.components.inventoryitem.atlasname = "images/inventoryimages/underworld_hana_weapon_messiah.xml"

            inst:AddComponent("equippable")

            inst.components.equippable:SetOnEquip(onequip)
            inst.components.equippable:SetOnUnequip(onunequip)

            MakeHauntableLaunch(inst)


        ------------------------------------------------------------------------------
        --- rechargeable 冷却系统
            inst:AddComponent("rechargeable")
            inst.components.rechargeable:SetMaxCharge(CD_TIME)

            
        ------------------------------------------------------------------------------
        --- 耐久度
            inst:AddComponent("finiteuses")
            inst.components.finiteuses:SetMaxUses(20)
            inst.components.finiteuses:SetUses(20)
            inst.components.finiteuses:SetOnFinished(inst.Remove)
        ------------------------------------------------------------------------------
        --- 落水影子
            local function shadow_init(inst)
                if inst:IsOnOcean(false) then       --- 如果在海里（不包括船）
                    -- inst.AnimState:Hide("SHADOW")
                    inst.AnimState:PlayAnimation("water")
                else                                
                    -- inst.AnimState:Show("SHADOW")
                    inst.AnimState:PlayAnimation("idle")
                end
            end
            inst:ListenForEvent("on_landed",shadow_init)
            shadow_init(inst)
        ------------------------------------------------------------------------------

        ------------------------------------------------------------------------------

        return inst
    end
------------------------------------------------------------------------------------------------------------------
--- fx
    local function fx()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()
        inst.entity:AddLight()


        inst.Light:SetFalloff(0.4)
        inst.Light:SetIntensity(.7)
        inst.Light:SetRadius(2.5)
        -- inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
        inst.Light:SetColour(255 / 255, 255 / 255, 255 / 255)
        inst.Light:Enable(true)

        inst.AnimState:SetBank("underworld_hana_weapon_messiah")
        inst.AnimState:SetBuild("underworld_hana_weapon_messiah")
        inst.AnimState:PlayAnimation("fx",true)
        inst.AnimState:SetMultColour(1,1, 1, 0.5)

        --weapon (from weapon component) added to pristine state for optimization
        inst:AddTag("FX")

        inst.entity:SetPristine()
        return inst
    end
------------------------------------------------------------------------------------------------------------------

return Prefab("underworld_hana_weapon_messiah", fn, assets),
            Prefab("underworld_hana_weapon_messiah_fx", fx, assets)
