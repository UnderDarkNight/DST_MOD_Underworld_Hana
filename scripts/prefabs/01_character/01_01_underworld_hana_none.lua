local assets =
{
	Asset( "ANIM", "anim/underworld_hana.zip" ),
	Asset( "ANIM", "anim/ghost_underworld_hana_build.zip" ),
}
local skin_fns = {

	-----------------------------------------------------
		CreatePrefabSkin("underworld_hana_none",{
			base_prefab = "underworld_hana",			---- 角色prefab
			skins = {
					normal_skin = "underworld_hana",					--- 正常外观
					ghost_skin = "ghost_underworld_hana_build",			--- 幽灵外观
			}, 								
			assets = assets,
			skin_tags = {"BASE" ,"UNDERWORLD_HANA", "CHARACTER"},		--- 皮肤对应的tag
			
			build_name_override = "underworld_hana",
			rarity = "Character",
		}),
	-----------------------------------------------------
	-----------------------------------------------------
		-- CreatePrefabSkin("underworld_hana_skin_flame",{
		-- 	base_prefab = "underworld_hana",			---- 角色prefab
		-- 	skins = {
		-- 			normal_skin = "underworld_hana_skin_flame", 		--- 正常外观
		-- 			ghost_skin = "ghost_underworld_hana_build",			--- 幽灵外观
		-- 	}, 								
		-- 	assets = assets,
		-- 	skin_tags = {"BASE" ,"underworld_hana_CARL", "CHARACTER"},		--- 皮肤对应的tag
			
		-- 	build_name_override = "underworld_hana",
		-- 	rarity = "Character",
		-- }),
	-----------------------------------------------------

}

return unpack(skin_fns)