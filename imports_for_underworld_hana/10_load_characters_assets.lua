------------------------------------------------------------------------------------------------------------------------------------------------------
---- 角色相关的 素材文件
------------------------------------------------------------------------------------------------------------------------------------------------------

if Assets == nil then
    Assets = {}
end

local temp_assets = {


	---------------------------------------------------------------------------
        Asset( "IMAGE", "images/saveslot_portraits/underworld_hana.tex" ), --存档图片
        Asset( "ATLAS", "images/saveslot_portraits/underworld_hana.xml" ),

        Asset( "IMAGE", "bigportraits/underworld_hana.tex" ), --人物大图（方形的那个）
        Asset( "ATLAS", "bigportraits/underworld_hana.xml" ),

        Asset( "IMAGE", "bigportraits/underworld_hana_none.tex" ),  --人物大图（椭圆的那个）
        Asset( "ATLAS", "bigportraits/underworld_hana_none.xml" ),
        
        Asset( "IMAGE", "images/map_icons/underworld_hana.tex" ), --小地图
        Asset( "ATLAS", "images/map_icons/underworld_hana.xml" ),
        
        Asset( "IMAGE", "images/avatars/avatar_underworld_hana.tex" ), --tab键人物列表显示的头像  --- 直接用小地图那张就行了
        Asset( "ATLAS", "images/avatars/avatar_underworld_hana.xml" ),
        
        Asset( "IMAGE", "images/avatars/avatar_ghost_underworld_hana.tex" ),--tab键人物列表显示的头像（死亡）
        Asset( "ATLAS", "images/avatars/avatar_ghost_underworld_hana.xml" ),
        
        Asset( "IMAGE", "images/avatars/self_inspect_underworld_hana.tex" ), --人物检查按钮的图片
        Asset( "ATLAS", "images/avatars/self_inspect_underworld_hana.xml" ),
        
        Asset( "IMAGE", "images/names_underworld_hana.tex" ),  --人物名字
        Asset( "ATLAS", "images/names_underworld_hana.xml" ),
        
        Asset("ANIM", "anim/underworld_hana.zip"),              --- 人物动画文件
        Asset("ANIM", "anim/ghost_underworld_hana_build.zip"),  --- 灵魂状态动画文件



	---------------------------------------------------------------------------


}
-- for i = 1, 30, 1 do
--     print("fake error ++++++++++++++++++++++++++++++++++++++++")
-- end
for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end

