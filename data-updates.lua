-- =============
-- Load Settings
-- =============

local BARRELING_USES_BARRELS = settings.startup["BarrelNirvana-barreling-uses-barrels"].value
local BARREL_FLUID_AMOUNT = settings.startup["BarrelNirvana-barrel-fluid-amount"].value

local EMPTY_STACK_SIZE = settings.startup["BarrelNirvana-empty-barrel-stack-size"].value
local FULL_STACK_SIZE = settings.startup["BarrelNirvana-filled-barrel-stack-size"].value


-- Other common variables
local recipes = data.raw["recipe"]
local items = data.raw["item"]


local function Set_Barrel_Ingredients(recipe)
	local ingredients = {}

	for _, ingred in ipairs(recipe.ingredients) do
		if (ingred.type == "item")
		then
			-- barrel
			if (BARRELING_USES_BARRELS)
			then
				table.insert(ingredients, ingred)
			end
		else
			-- fluid
			local fluid_ingredient = { type = "fluid", name = ingred.name, amount = BARREL_FLUID_AMOUNT }
			table.insert(ingredients, fluid_ingredient)
		end
	end

	recipe.ingredients = ingredients
end

local function Set_Barrel_Results(recipe)
	local results = {}

	for _, result in ipairs(recipe.results) do
		if (result.type == "item")
		then
			-- barrel
			if (BARRELING_USES_BARRELS)
			then
				table.insert(results, result)
			end
		else
			-- fluid
			local fluid_result = { type = "fluid", name = result.name, amount = BARREL_FLUID_AMOUNT }
			table.insert(results, fluid_result)
		end
	end

	recipe.results = results
end

-- =======================
-- Finding recipes to edit
-- =======================

-- These two
Fluid_Barrel_Names = {}
Barrel_Item_Names = { "barrel" }


Barrel_Filling_Subgroups = {
	["fill-barrel"] = true
}
Barrel_Emptying_Subgroups = {
	["empty-barrel"] = true
}



-- ==========
-- Main Logic
-- ==========

for _, recipe in pairs(recipes) do
	local subgroup = recipe.subgroup

	if (Barrel_Filling_Subgroups[subgroup])
	then
		Set_Barrel_Ingredients(recipe)
		table.insert(Fluid_Barrel_Names, recipe.results[1].name)
	end

	if (Barrel_Emptying_Subgroups[subgroup])
	then
		Set_Barrel_Results(recipe)
	end
end


-- ==================
-- Stack Size Changes
-- ==================

for _, barrel_name in pairs(Barrel_Item_Names) do
	items[barrel_name].stack_size = EMPTY_STACK_SIZE
end

for _, barrel_name in ipairs(Fluid_Barrel_Names) do
	items[barrel_name].stack_size = FULL_STACK_SIZE
end
