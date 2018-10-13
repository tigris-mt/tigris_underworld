local function grow(pos, check)
    local to = table.copy(pos)
    local ht = math.random(1, 3)
    local hs = 1
    local h = ht + hs
    if check then
        if not ({
            ["default:stone_with_coal"] = true,
            ["default:coalblock"] = true,
        })[minetest.get_node(to).name] then
            return false
        end
        for i=2,h do
            if minetest.get_node(vector.add(to, vector.new(0, i, 0))).name ~= "air" then
                return false
            end
        end
        minetest.log("action", "A lightwood sapling grows with height " .. h .. " at " .. minetest.pos_to_string(vector.add(pos, vector.new(0, 1, 0))))
    end
    for _=1,ht do
        to.y = to.y + 1
        minetest.swap_node(to, {name = "tigris_underworld:lightwood_trunk"})
    end
    to.y = to.y + 1
    minetest.swap_node(to, {name = "tigris_underworld:lightwood_pod"})
    return true
end

minetest.register_node("tigris_underworld:lightwood_trunk", {
    description = "Lightwood Trunk",
    tiles = {"tigris_underworld_lightwood_trunk_top.png", "tigris_underworld_lightwood_trunk_top.png", "tigris_underworld_lightwood_trunk.png"},
    paramtype2 = "facedir",
    groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
    is_ground_content = false,
    light_source = 8,
    sounds = default.node_sound_wood_defaults(),
    on_place = minetest.rotate_node,
})

minetest.register_node("tigris_underworld:lightwood", {
    description = "Lightwood Planks",
    tiles = {"tigris_underworld_lightwood.png"},
    is_ground_content = false,
    groups = {wood = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
    light_source = 9,
    sounds = default.node_sound_wood_defaults(),
})

local d = minetest.registered_nodes["tigris_underworld:lightwood"]
if minetest.global_exists("stairs") then
    stairs.register_stair_and_slab(
        "lightwood",
        "tigris_underworld:lightwood",
        d.groups,
        d.tiles,
        "Lightwood Stair",
        "Lightwood Slab",
        d.sounds,
        false
    )
end

if minetest.global_exists("stairsplus") then
    stairsplus:register_all("tigris_underworld", "lightwood", "tigris_underworld:lightwood", {
        description = d.description,
        groups = table.copy(d.groups),
        tiles = d.tiles,
        light_source = d.light_source,
        sounds = d.sounds,
    })
end

minetest.register_node("tigris_underworld:lightwood_sapling", {
    description = "Lightwood Sapling",
    drawtype = "plantlike",
    tiles = {"tigris_underworld_lightwood_sapling.png"},
    paramtype = "light",
    sunlight_propagates = true,
    light_source = 5,
    sounds = default.node_sound_leaves_defaults(),
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-4 / 16, -8 / 16, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
    },
    groups = {snappy = 2, dig_immediate = 3, attached_node = 1, sapling = 1, flammable = 2},
    on_timer = function(pos)
        return not grow(vector.add(pos, vector.new(0, -1, 0)), true)
    end,
    on_construct = function(pos)
        minetest.get_node_timer(pos):start(math.random(120, 600))
    end,
})

minetest.register_node("tigris_underworld:lightwood_pod", {
    description = "Lightwood Pod",
    drawtype = "nodebox",
    tiles = {"tigris_underworld_lightwood_pod.png"},
    paramtype = "light",
    sunlight_propagates = true,
    light_source = 5,
    sounds = default.node_sound_wood_defaults(),
    groups = {snappy = 2, dig_immediate = 3, flammable = 2},
    node_box = {
        type = "fixed",
        fixed = {
            {-0.2, -0.5, -0.2, 0.2, -0.1, 0.2},
        },
    },
    drop = {
        max_items = 3,
        items = {
            {items = {"tigris_underworld:lightwood_sapling"}, rarity = 1},
            {items = {"tigris_underworld:lightwood_sapling"}, rarity = 2},
            {items = {"tigris_underworld:lightwood_sapling"}, rarity = 2},
        },
    },
})

minetest.register_on_generated(function(minp, maxp)
    local coal = minetest.find_nodes_in_area_under_air(minp, maxp, {"default:stone_with_coal"})
    for _,pos in ipairs(coal) do
        if math.random() < 0.2 then
            grow(pos, false)
        end
    end
end)

minetest.register_craft{
    output = "tigris_underworld:lightwood 4",
    recipe = {
        {"tigris_underworld:lightwood_trunk"},
    },
}
