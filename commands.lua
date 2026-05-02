minetest.register_chatcommand("spawn_npc", {
    params = "<name> <role>",
    description = "Spawn an NPC at your position",
    privs = {server = true},
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        if not player then return false, "Player not found." end
        
        local args = string.split(param, " ")
        local npc_name = args[1] or "Villager"
        local role = args[2] or "roamer"
        
        local pos = player:get_pos()
        -- Ensure starting position is clean for the entity
        pos.y = pos.y + 0.5 
        
        local npc = minetest.add_entity(pos, "techblox_npcs:npc")
        if npc then
            local ent = npc:get_luaentity()
            ent.npc_id = tostring(math.random(10000, 99999))
            ent.npc_name = npc_name
            ent.role = role
            
            -- Round off bounds immediately for safety
            ent.zones.roam = {
                pos1 = vector.add(pos, {x=10, y=5, z=10}),
                pos2 = vector.subtract(pos, {x=10, y=5, z=10})
            }
            
            table.insert(techblox_npcs.spawned_npcs, {id = ent.npc_id, pos = pos})
            techblox_npcs.save_npc_data()
            return true, "Spawned " .. npc_name .. " as " .. role
        else
            return false, "Failed to spawn entity."
        end
    end
})
