minetest.register_node("tigris_underworld:mushroom_green", {
    description = "Green Mushroom",
    tiles = {"tigris_underworld_mushroom_green.png"},
    drawtype = "plantlike",
    paramtype = "light",
    light_source = 5,
    sunlight_propagates = true,
    buildable_to = true,
    walkable = false,
    groups = {snappy = 3, attached_node = 1, flammable = 1, tigris_underworld_mushroom = 1},
    sounds = default.node_sound_leaves_defaults(),
    on_use = minetest.item_eat(1),
    selection_box = {
        type = "fixed",
        fixed = {-4 / 16, -8 / 16, -4 / 16, 4 / 16, 6 / 16, 4 / 16},
    }
})

minetest.register_node("tigris_underworld:mushroom_blue", {
    description = "Blue Mushroom",
    tiles = {"tigris_underworld_mushroom_blue.png"},
    drawtype = "plantlike",
    paramtype = "light",
    light_source = 6,
    sunlight_propagates = true,
    buildable_to = true,
    walkable = false,
    groups = {snappy = 3, attached_node = 1, flammable = 1, tigris_underworld_mushroom = 1},
    sounds = default.node_sound_leaves_defaults(),
    on_use = minetest.item_eat(1),
    selection_box = {
        type = "fixed",
        fixed = {-4 / 16, -8 / 16, -4 / 16, 4 / 16, 3 / 16, 4 / 16},
    }
})

minetest.register_node("tigris_underworld:mushroom_pink", {
    description = "Pink Mushroom",
    tiles = {"tigris_underworld_mushroom_pink.png"},
    drawtype = "plantlike",
    paramtype = "light",
    light_source = 7,
    sunlight_propagates = true,
    buildable_to = true,
    walkable = false,
    groups = {snappy = 3, attached_node = 1, flammable = 1, tigris_underworld_mushroom = 1},
    sounds = default.node_sound_leaves_defaults(),
    on_use = minetest.item_eat(2),
    selection_box = {
        type = "fixed",
        fixed = {-4 / 16, -8 / 16, -4 / 16, 4 / 16, 7 / 16, 4 / 16},
    }
})

minetest.register_abm{
    label = "Underworld Mushroom Activity",
    nodenames = {"group:tigris_underworld_mushroom"},
    interval = 12,
    chance = 100,
    action = function(pos, node)
        local sr = vector.new(3, 2, 3)
        if #minetest.find_nodes_in_area_under_air(vector.subtract(pos, sr), vector.add(pos, sr), {"group:tigris_underworld_mushroom"}) > 5 then
            return
        end

        local r = vector.new(1, 2, 1)
        local poses = minetest.find_nodes_in_area_under_air(vector.subtract(pos, r), vector.add(pos, r), {"default:stone", "group:tree", "group:soil"})
        if #poses > 0 then
            minetest.set_node(vector.add(poses[math.random(#poses)], vector.new(0, 1, 0)), {name = node.name})
        end
    end,
}

local d = {"tigris_underworld:mushroom_green", "tigris_underworld:mushroom_blue", "tigris_underworld:mushroom_pink"}

minetest.register_on_generated(function(minp, maxp)
    local iron = minetest.find_nodes_in_area_under_air(minp, maxp, {"default:stone_with_iron"})
    for _,pos in ipairs(iron) do
        if math.random() < 0.25 then
            minetest.set_node(vector.add(pos, vector.new(0, 1, 0)), {name = d[math.random(#d)]})
        end
    end
end)
