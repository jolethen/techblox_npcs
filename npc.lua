minetest.register_entity("techblox_npcs:npc", {
    initial_properties = {
        physical = true,
        collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
        visual = "mesh",
        mesh = "character.b3d", 
        textures = {"character.png"},
        makes_footstep_sound = true,
    },
    
    on_activate = function(self, staticdata)
        -- CRITICAL FIX: Initialize tables here so they aren't shared between all NPCs!
        self.zones = {roam = nil, work = nil, sleep = nil}
        self.role = "roamer"
        self.npc_name = "Villager"
        self.npc_id = tostring(math.random(10000, 99999))
        self.state = "idle"
        self.tick_timer = math.random(0, 10) / 10 

        if staticdata ~= "" then
            local data = minetest.deserialize(staticdata)
            if data then
                self.npc_id = data.id or self.npc_id
                self.npc_name = data.name or self.npc_name
                self.role = data.role or self.role
                self.zones = data.zones or self.zones
            end
        end
        self.object:set_armor_groups({immortal = 1})
    end,

    get_staticdata = function(self)
        return minetest.serialize({
            id = self.npc_id,
            name = self.npc_name,
            role = self.role,
            zones = self.zones
        })
    end,

    on_step = function(self, dtime)
        -- CRITICAL FIX: Removed manual gravity calculation. 
        -- `physical = true` entities naturally fall. Manual gravity was destroying engine physics.

        self.tick_timer = self.tick_timer + dtime
        if self.tick_timer < 1.5 then return end
        self.tick_timer = 0
        
        techblox_npcs.ai.tick(self)
    end,

    on_rightclick = function(self, clicker)
        if not clicker or not clicker:is_player() then return end
        self.state = "interacting"
        self.interact_timer = 5 
        
        local dir = vector.direction(self.object:get_pos(), clicker:get_pos())
        if math.abs(dir.x) > 0.001 or math.abs(dir.z) > 0.001 then
            self.object:set_yaw(minetest.dir_to_yaw(dir))
        end
        
        techblox_npcs.ui.show_dialogue(clicker:get_player_name(), self)
    end
})
