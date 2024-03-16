--------------------------------------------------------------------------------------------
------ 常用函数放 TUNING 里
--------------------------------------------------------------------------------------------
----- RPC 命名空间
TUNING["underworld_hana.RPC_NAMESPACE"] = "underworld_hana_RPC"


--------------------------------------------------------------------------------------------

TUNING["underworld_hana.fn"] = {}
TUNING["underworld_hana.fn"].GetStringsTable = function(prefab_name)
    -------- 读取文本表
    -------- 如果没有当前语言的问题，调取中文的那个过去
    -------- 节省重复调用运算处理
    if TUNING["underworld_hana.fn"].GetStringsTable_last_prefab_name == prefab_name then
        return TUNING["underworld_hana.fn"].GetStringsTable_last_table or {}
    end


    local LANGUAGE = "ch"
    if type(TUNING["underworld_hana.Language"]) == "function" then
        LANGUAGE = TUNING["underworld_hana.Language"]()
    elseif type(TUNING["underworld_hana.Language"]) == "string" then
        LANGUAGE = TUNING["underworld_hana.Language"]
    end
    local ret_table = prefab_name and TUNING["underworld_hana.Strings"][LANGUAGE] and TUNING["underworld_hana.Strings"][LANGUAGE][tostring(prefab_name)] or nil
    if ret_table == nil and prefab_name ~= nil then
        ret_table = TUNING["underworld_hana.Strings"]["ch"][tostring(prefab_name)]
    end

    ret_table = ret_table or {}
    TUNING["underworld_hana.fn"].GetStringsTable_last_prefab_name = prefab_name
    TUNING["underworld_hana.fn"].GetStringsTable_last_table = ret_table

    return ret_table
end


--------------------------------------------------------------------------------------------
local function GetStringsTable(prefab_name)
    return TUNING["underworld_hana.fn"].GetStringsTable(prefab_name)
end

--------------------------------------------------------------------------------------------