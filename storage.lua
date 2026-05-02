techblox_npcs.storage = minetest.get_mod_storage()
techblox_npcs.spawned_npcs = {}

function techblox_npcs.load_npc_data()
    local file = io.open(techblox_npcs.data_file, "r")
    if file then
        local content = file:read("*a")
        if content and content ~= "" then
            techblox_npcs.spawned_npcs = minetest.parse_json(content) or {}
        end
        file:close()
    end
end

function techblox_npcs.save_npc_data()
    local file = io.open(techblox_npcs.data_file, "w")
    if file then
        file:write(minetest.write_json(techblox_npcs.spawned_npcs))
        file:close()
    end
end

techblox_npcs.load_npc_data()
