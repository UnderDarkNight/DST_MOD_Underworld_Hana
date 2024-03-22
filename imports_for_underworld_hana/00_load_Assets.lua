
if Assets == nil then
    Assets = {}
end

local temp_assets = {


	-- Asset("IMAGE", "images/inventoryimages/underworld_hana_empty_icon.tex"),
	-- Asset("ATLAS", "images/inventoryimages/underworld_hana_empty_icon.xml"),
	
	-- Asset("SHADER", "shaders/mod_test_shader.ksh"),		--- 测试用的

	---------------------------------------------------------------------------

	Asset("ANIM", "anim/underworld_hana_widget_overcome_confinement.zip"),	--- 冲破禁锢的UI



	---------------------------------------------------------------------------
	-- Asset("ANIM", "anim/underworld_hana_mutant_frog.zip"),	--- 变异青蛙贴图包
	-- Asset("ANIM", "anim/underworld_hana_animal_frog_hound.zip"),	--- 变异青蛙狗贴图包

	---------------------------------------------------------------------------
	-- Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),	--- 单机声音集
	---------------------------------------------------------------------------


}

for k, v in pairs(temp_assets) do
    table.insert(Assets,v)
end

