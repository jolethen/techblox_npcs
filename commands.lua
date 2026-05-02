minetest.register_chatcommand("spawn_npc", {
    params = "<name> <role>",
    description = "Spawn an NPC at your position",
    privs = {server = true},
    func = function(name, param)
        local player = minetest.get_player_by_name(name)
        local args = param:split(" ")
        if #args < 2 then return false, "Usage: /spawn_npc <name> <role>" end
        
        local pos = player:get_pos()
        local npc = minetest.add_entity(pos, "techblox_npcs:npc")
        if npc then
            local ent = npc:get_luaentity()
            ent.npc_id = tostring(math.random(10000, 99999))
            ent.npc_name = args[1]
            ent.role = args[2]
            
            -- Set a default 20x20 roam zone around spawn
            ent.zones.roam = {
                pos1 = vector.add(pos, {x=10, y=10, z=10}),
                pos2 = vector.subtract(pos, {x=10, y=10, z=10})
            }
            
            table.insert(techblox_npcs.spawned_npcs, {id = ent.npc_id, pos = pos})
            techblox_npcs.save_npc_data()
            return true, "Spawned " .. args[1] .. " as " .. args[2]
        end
    end
})
