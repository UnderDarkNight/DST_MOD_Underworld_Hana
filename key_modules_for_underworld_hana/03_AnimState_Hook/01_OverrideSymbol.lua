if TUNING["underworld_hana.AnimStateFn"] == nil then
    TUNING["underworld_hana.AnimStateFn"] = {}
end

TUNING["underworld_hana.AnimStateFn"]["01_OverrideSymbol"] = function(theAnimState)

    -- OverrideSymbol

    -- if theAnimState.OverrideSymbol__old_underworld_hana == nil then
    --     theAnimState.OverrideSymbol__old_underworld_hana = theAnimState.OverrideSymbol
    --     theAnimState.OverrideSymbol = function(self,layer,build,layer_new)
    --         -- print("underworld_hana OverrideSymbol",layer,build,layer_new)
    --         self:OverrideSymbol__old_underworld_hana(layer,build,layer_new)
    --     end
    -- end

end