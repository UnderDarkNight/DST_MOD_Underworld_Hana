--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
Builder

    hook builder 组件，让 自制的tag 系统 兼容 制作栏 tag 解锁

]]--
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

return function(inst)
    inst:DoTaskInTime(0,function()


        if inst.components.builder then
            local old_KnowsRecipe_mastersim = inst.components.builder.KnowsRecipe
            inst.components.builder.KnowsRecipe = function(self,recipe,...)
                local origin_ret = old_KnowsRecipe_mastersim(self,recipe,...)
                
                if origin_ret ~= true then  --- 原本的函数返回 false 的时候再执行检测
                    if type(recipe) == "string" then
                        recipe = GetValidRecipe(recipe)
                    end                
                    if type(recipe) == "table" and recipe.builder_tag then
                        if inst.replica.hana_com_tag_sys:HasTag(recipe.builder_tag) then
                            -- print("test recipe",recipe.product,recipe.builder_tag)
                            return true
                        end
                    end
                end

                return origin_ret
            end
        end
        if inst.replica.builder then
            ----------------------------------------------------------------------------------------------------
            ----- KnowsRecipe
                local old_KnowsRecipe_replica = inst.replica.builder.KnowsRecipe
                inst.replica.builder.KnowsRecipe = function(self,recipe,...)
                    local origin_ret = old_KnowsRecipe_replica(self,recipe,...)
                    
                    if origin_ret ~= true then  --- 原本的函数返回 false 的时候再执行检测
                        if type(recipe) == "string" then
                            recipe = GetValidRecipe(recipe)
                        end                
                        if type(recipe) == "table" and recipe.builder_tag then
                            if inst.replica.hana_com_tag_sys:HasTag(recipe.builder_tag) then
                                -- print("test replica recipe",recipe.product,recipe.builder_tag)
                                return true
                            end
                        end
                    end

                    return origin_ret
                end
            
            ----------------------------------------------------------------------------------------------------
            ------ CanLearn
                local old_CanLearn_replica = inst.replica.builder.CanLearn
                inst.replica.builder.CanLearn = function(self,recipe,...)
                    local origin_ret = old_CanLearn_replica(self,recipe,...)
                    if origin_ret ~= true then  --- 原本的函数返回 false 的时候再执行检测
                        if type(recipe) == "string" then
                            recipe = GetValidRecipe(recipe)
                        end
                        if type(recipe) == "table" and recipe.builder_tag then
                            if inst.replica.hana_com_tag_sys:HasTag(recipe.builder_tag) then
                                -- print("test replica recipe",recipe.product,recipe.builder_tag)
                                return true
                            end
                        end
                    end
                end
            ----------------------------------------------------------------------------------------------------

        end
    end)

end