--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    烹饪 有概率失败

    wetgoop  潮湿的黏糊糊

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    if not TheWorld.ismastersim then
        return
    end


    inst:ListenForEvent("underworld_hana_event.stewer.cooking_started",function(_,cookpot)

        if not inst.components.hana_com_tag_sys:HasTag("clumsy") then   ---解除笨手笨脚
            return
        end
            
                    if not TUNING.UNDERWORLD_HANA_DEBUGGING_MODE  then
                        if inst.components.health:GetPercent() < 0.4 or inst.components.sanity:GetPercent() < 0.3 then
                            return
                        end
                        if math.random(1000)/1000 < 0.9 then
                            return
                        end
                    end

        local cooking_items = {}
        for k, temp_item in pairs(cookpot.components.container.slots) do
            local temp_record = temp_item:GetSaveRecord()
            table.insert(cooking_items,temp_record)
        end

        inst:DoTaskInTime(0,function()
            cookpot.components.stewer.product = "wetgoop"


            if #cooking_items ~= 4 then
                return
            end

            local index_1 = math.random(4)
            local index_2 = 2
            for i = 1, 100, 1 do
                index_2 = math.random(4)
                if index_2 ~= index_1 then
                    break
                end
            end
            if index_1 == index_2 then
                return
            end

            local item_1_record = cooking_items[index_1]
            local item_2_record = cooking_items[index_2]

            local function SpawnItem(thePoint,ItemName_record,Range,throwHight)

                -- local theItem = SpawnPrefab("log")
                local theItem = SpawnSaveRecord(ItemName_record)
                if theItem == nil then
                    return
                end
        
                local pt = thePoint + Vector3(0,2,0)
                theItem.Transform:SetPosition(pt:Get())
                -- local down = TheCamera:GetDownVec()
                -- local angle = math.atan2(down.z, down.x) + (math.random()*60)*DEGREES
                local angle = math.random(2*PI*100)/100
                local sp = math.random(Range)
                -- theItem.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, sp*math.sin(angle))
                -- SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
                theItem.Physics:SetVel(sp*math.cos(angle), throwHight, sp*math.sin(angle))
                return theItem
            end

            SpawnItem(Vector3(cookpot.Transform:GetWorldPosition()),item_1_record,3,5)
            SpawnItem(Vector3(cookpot.Transform:GetWorldPosition()),item_2_record,3,5)
            cookpot:PushEvent("underworld_hana_event.stewer.force_finish")

        end)

    end)


    inst:ListenForEvent("underworld_hana_event.stewer.harvest",function(inst,cookpot)
        if not inst.components.hana_com_tag_sys:HasTag("clumsy") then   ---解除笨手笨脚
            return
        end
        if TUNING.UNDERWORLD_HANA_DEBUGGING_MODE or math.random(1000) <= 100 then
            
                if cookpot and cookpot.components.lootdropper then
                    local product = cookpot.components.stewer.product
                    if product then
                    cookpot.components.lootdropper:SpawnLootPrefab(product)
                    end            
                end
            
        end
    end)
end