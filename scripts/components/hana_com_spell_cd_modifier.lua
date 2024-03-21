----------------------------------------------------------------------------------------------------------------------------------
--[[

     一帧给予 5 条 RPC 管道足够了

     
]]--
----------------------------------------------------------------------------------------------------------------------------------
local hana_com_spell_cd_modifier = Class(function(self, inst)
    self.inst = inst

    self.modifier = SourceModifierList(self.inst)

end,
nil,
{

})


function hana_com_spell_cd_modifier:SetModifier(source_inst,num)
    if type(num) == "number" then
        self.modifier:SetModifier(source_inst,num)
    end
end
function hana_com_spell_cd_modifier:RemoveModifier(source_inst)
    self.modifier:RemoveModifier(source_inst)
end

function hana_com_spell_cd_modifier:GetMult()
    return self.modifier:Get() or 1
end


return hana_com_spell_cd_modifier