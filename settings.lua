data:extend({
    {
        type = "int-setting",
        name = "treenade_stack_size",
        setting_type = "startup",
        default_value = 100,
        minimum_value = 1,
        maximum_value = 9999,
        order= "a"
    },
    {
        type = "int-setting",
        name = "treenade_seeds_per_nade",
        setting_type = "startup",
        default_value = 10,
        minimum_value = 1,
        maximum_value = 100,
        order = "b"
    },
    {
        type = "int-setting",
        name = "treenade_boom_radius",
        setting_type = "startup",
        default_value = 20,
        minimum_value = 1,
        maximum_value = 200,
        order = "c"
    },
    {
        type = "bool-setting",
        name = "treenade_drop_on_concrete",
        setting_type = "startup",
        default_value = false,
        order = "d"
    }
})