-- =============
-- Load Settings
-- =============

local BARREL_FILLING_SUBGROUP = "fill-barrel"
local BARREL_EMPTYING_SUBGROUP = "empty-barrel"

local BARRELING_USES_BARRELS = settings.startup["BarrelNirvana-barreling-uses-barrels"].value
local BARREL_FLUID_AMOUNT = settings.startup["BarrelNirvana-barrel-fluid-amount"].value

local EMPTY_STACK_SIZE = settings.startup["BarrelNirvana-empty-barrel-stack-size"].value
local FULL_STACK_SIZE = settings.startup["BarrelNirvana-filled-barrel-stack-size"].value


-- Other common variables
local recipes = data.raw["recipe"]
local items = data.raw["item"]

local fluid_barrel_item_names = {}

-- Predicates to make things flow better
local function fill_change(recipe)
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
      local fluid_ingredient = {type="fluid", name=ingred.name, amount=BARREL_FLUID_AMOUNT}
      table.insert(ingredients, fluid_ingredient)
    end
  end
  
  if (recipe.result)
  then
    table.insert(fluid_barrel_item_names, recipe.result)
  else
    table.insert(fluid_barrel_item_names, recipe.results[1].name or recipe.results[1][1])
  end

  recipe.ingredients = ingredients
end

local function empty_change(recipe)
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
      local fluid_result = {type="fluid", name=result.name, amount=BARREL_FLUID_AMOUNT}
      table.insert(results, fluid_result)
    end
  end

  recipe.results = results
end

-- ==========
-- Main Logic
-- ==========

for k, v in pairs(recipes) do
  local subgroup = v.subgroup

  if (subgroup == BARREL_FILLING_SUBGROUP)
  then
    fill_change(v)
  else
    if (subgroup == BARREL_EMPTYING_SUBGROUP)
    then
      empty_change(v)
    end
  end
end

items["empty-barrel"].stack_size = EMPTY_STACK_SIZE

for _, barrel_name in ipairs(fluid_barrel_item_names) do
  items[barrel_name].stack_size = FULL_STACK_SIZE
end