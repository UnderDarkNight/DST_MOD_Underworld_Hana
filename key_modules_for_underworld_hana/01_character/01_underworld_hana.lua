------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[

    角色基础初始化

]]--
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



local function Language_check()
    local language = "en"
    if type(TUNING["underworld_hana.Language"]) == "function" then
        language = TUNING["underworld_hana.Language"]()
    elseif type(TUNING["underworld_hana.Language"]) == "string" then
        language = TUNING["underworld_hana.Language"]
    end
    return language
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 角色立绘大图
    GLOBAL.PREFAB_SKINS["underworld_hana"] = {
        "underworld_hana_none",
    }
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- 角色选择时候都文本
    if Language_check() == "ch" then
        -- The character select screen lines  --人物选人界面的描述
        STRINGS.CHARACTER_TITLES["underworld_hana"] = "冥界使者哈娜"
        STRINGS.CHARACTER_NAMES["underworld_hana"] = "哈娜"
        STRINGS.CHARACTER_DESCRIPTIONS["underworld_hana"] = "我来自冥界"
        STRINGS.CHARACTER_QUOTES["underworld_hana"] = "死亡并不可怕"

        -- Custom speech strings  ----人物语言文件  可以进去自定义
        -- STRINGS.CHARACTERS[string.upper("underworld_hana")] = require "speech_underworld_hana"

        -- The character's name as appears in-game  --人物在游戏里面的名字
        STRINGS.NAMES[string.upper("underworld_hana")] = "哈娜"
        STRINGS.SKIN_NAMES["underworld_hana_none"] = "哈娜"  --检查界面显示的名字

        --生存几率
        STRINGS.CHARACTER_SURVIVABILITY["underworld_hana"] = "特别容易"
    else
        -- The character select screen lines  --人物选人界面的描述
        STRINGS.CHARACTER_TITLES["underworld_hana"] = "Hana, Messenger of the Underworld"
        STRINGS.CHARACTER_NAMES["underworld_hana"] = "Hana"
        STRINGS.CHARACTER_DESCRIPTIONS["underworld_hana"] = "I'm from the underworld."
        STRINGS.CHARACTER_QUOTES["underworld_hana"] = "Death is not scary."

        -- Custom speech strings  ----人物语言文件  可以进去自定义
        -- STRINGS.CHARACTERS[string.upper("underworld_hana")] = require "speech_underworld_hana"

        -- The character's name as appears in-game  --人物在游戏里面的名字
        STRINGS.NAMES[string.upper("underworld_hana")] = "Hana"
        STRINGS.SKIN_NAMES["underworld_hana_none"] = "Hana"  --检查界面显示的名字

        --生存几率
        STRINGS.CHARACTER_SURVIVABILITY["underworld_hana"] = "easy"

    end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
------增加人物到mod人物列表的里面 性别为女性（ MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL）
    AddModCharacter("underworld_hana", "FEMALE")

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----选人界面人物三维显示
    TUNING[string.upper("underworld_hana").."_HEALTH"] = 150
    TUNING[string.upper("underworld_hana").."_HUNGER"] = 150
    TUNING[string.upper("underworld_hana").."_SANITY"] = 150
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----选人界面初始物品显示，物品相关的prefab
    TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT[string.upper("underworld_hana")] = {"log"}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
