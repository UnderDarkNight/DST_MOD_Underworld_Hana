--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    厄运的诅咒

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 怪物吸引
    local function monsters_attract_task_setup(inst)
        inst:DoPeriodicTask(10,function()

                    if inst:HasTag("playerghost") then
                        return
                    end
                    if inst.components.inventory:EquipHasTag("underworld_hana_equipment_bow") then
                        return
                    end
                    local x,y,z = inst.Transform:GetWorldPosition()
                    local musthavetags = { "_combat" }
                    local canthavetags = {"INLIMBO", "notarget", "noattack", "flight", "invisible", "wall", "player", "companion","underworld_hana_tag.ignore_hana" }
                    local musthaveoneoftags = nil
                    local ents = TheSim:FindEntities(x, y, z, 20, musthavetags, canthavetags, musthaveoneoftags)
                    -- if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE then
                    --     print("the_curse_of_doom",#ents)
                    -- end
                    for k, temp_monster in pairs(ents) do
                        if temp_monster.components.combat then
                            if temp_monster.components.combat:CanAttack(inst) then
                                temp_monster.components.combat:SuggestTarget(inst)
                            end
                        end
                    end


        end)
    end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end


    monsters_attract_task_setup(inst)

end