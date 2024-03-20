------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    防雷

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
AddComponentPostInit("playerlightningtarget", function(self)


    local old_onstrikefn = self.onstrikefn
    self.onstrikefn = function(inst)
        if inst.replica.inventory:EquipHasTag("hana_thunder_blocker") then
            -- print("info hana_thunder_blocker")
            return
        end
        old_onstrikefn(inst)
    end

end)