minetest.register_node("tigris_underworld:trap_empty", {
    description = "Insect Trap",
    drawtype = "plantlike",
    tiles = {"tigris_underworld_trap_empty.png"},
    paramtype = "light",
    sunlight_propagates = true,
    light_source = 4,
    sounds = default.node_sound_wood_defaults(),
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-1 / 16, -8 / 16, -1 / 16, 1 / 16, 7 / 16, 1 / 16}
    },
    groups = {snappy = 3, attached_node = 1, flammable = 2},
    on_timer = function(pos)
        local r = vector.new(3, 2, 3)
        if #minetest.find_nodes_in_area_under_air(vector.subtract(pos, r), vector.add(pos, r), {"group:tigris_underworld_mushroom"}) >= 1 then
            minetest.swap_node(pos, {name = "tigris_underworld:trap_full"})
            return false
        end
        return true
    end,
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(8 * 60, 20 * 60))
    end,
})

minetest.register_node("tigris_underworld:trap_full", {
    description = "Full Insect Trap",
    drawtype = "plantlike",
    tiles = {"tigris_underworld_trap_full.png"},
    paramtype = "light",
    sunlight_propagates = true,
    sounds = default.node_sound_wood_defaults(),
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-1 / 16, -8 / 16, -4 / 16, 1 / 16, 7 / 16, 1 / 16}
    },
    groups = {snappy = 3, attached_node = 1, flammable = 2},
})

minetest.register_craftitem("tigris_underworld:cooked_insects", {
    description = "Cooked Insects on a Stick",
    inventory_image = "tigris_underworld_cooked_insects.png",
    on_use = minetest.item_eat(4),
})

minetest.register_craft{
    output = "tigris_underworld:trap_empty",
    recipe = {
        {"group:stick"},
        {"tigris_underworld:lightwood_sapling"},
        {"group:stick"},
    },
}

minetest.register_craft{
    type = "cooking",
    output = "tigris_underworld:cooked_insects",
    recipe = "tigris_underworld:trap_full",
    cooktime = 5,
}
