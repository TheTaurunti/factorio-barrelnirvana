data:extend({
  {
    type = "bool-setting",
    name = "BarrelNirvana-barreling-uses-barrels",
    setting_type = "startup",
    order = 1,
    default_value = true
  },

  {
    type = "int-setting",
    name = "BarrelNirvana-empty-barrel-stack-size",
    setting_type = "startup",
    order = 2,
    default_value = 10,
    minimum_value = 1
  },

  {
    type = "int-setting",
    name = "BarrelNirvana-filled-barrel-stack-size",
    setting_type = "startup",
    order = 3,
    default_value = 10,
    minimum_value = 1
  },
  {
    type = "int-setting",
    name = "BarrelNirvana-barrel-fluid-amount",
    setting_type = "startup",
    order = 4,
    default_value = 50,
    minimum_value = 1
  }
})