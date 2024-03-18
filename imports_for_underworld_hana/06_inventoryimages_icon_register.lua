---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--- 统一注册 【 images\inventoryimages 】 里的所有图标
--- 每个 xml 里面 只有一个 tex

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

if Assets == nil then
    Assets = {}
end

local files_name = {

	---------------------------------------------------------------------------------------

		"underworld_hana_weapon_scythe_overcome_confinement",						--- 冲破禁锢


		"underworld_hana_item_blissful_memory",										--- 幸福的记忆
	---------------------------------------------------------------------------------------
	-- 02_items
		"underworld_hana_item_faded_memory",										--- 褪色的记忆
	---------------------------------------------------------------------------------------
	-- 03_equipments
		"underworld_hana_weapon_scythe",											--- 冥界之镰
		"underworld_hana_weapon_red_lotus",											--- 红莲
		"underworld_hana_weapon_astartes",											--- 阿斯塔特
		"underworld_hana_weapon_messiah",											--- 弥赛亚
		"underworld_hana_weapon_deep_love",											--- 爱之深
	---------------------------------------------------------------------------------------

}

for k, name in pairs(files_name) do
    table.insert(Assets, Asset( "IMAGE", "images/inventoryimages/".. name ..".tex" ))
    table.insert(Assets, Asset( "ATLAS", "images/inventoryimages/".. name ..".xml" ))
	RegisterInventoryItemAtlas("images/inventoryimages/".. name ..".xml", name .. ".tex")
end


