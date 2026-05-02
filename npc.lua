minetest.register_entity("techblox_npcs:npc", {
    initial_properties = {
        physical = true,
        collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
        visual = "mesh",
        mesh = "character.b3d", -- Use your game's default mesh
        textures = {"character.png"},
        makes_footstep_sound = true,
    },
    
    -- Internal Data
    npc_id = "",
    npc_name = "Villager",
    role = "roamer",
    state = "idle",
    zones = {roam = nil, work = nil, sleep = nil},
    
    on_activate = function(self, staticdata)
        if staticdata ~= "" then
            local data = minetest.deserialize(staticdata)
            if data then
                self.npc_id = data.id
                self.npc_name = data.name
                self.role = data.role
                self.zones = data.zones
            end
        end
        self.object:set_armor_groups({immortal = 1})
        self.tick_timer = math.random(0, 10) / 10 -- Stagger start times
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
        -- Gravity
        local vel = self.object:get_velocity()
        vel.y = vel.y - (9.81 * dtime)
        self.object:set_velocity(vel)

        -- CPU Optimization: Only run AI logic every ~1.5 seconds
        self.tick_timer = self.tick_timer + dtime
        if self.tick_timer < 1.5 then return end
        self.tick_timer = 0
        
        techblox_npcs.ai.tick(self)
    end,

    on_rightclick = function(self, clicker)
        if not clicker or not clicker:is_player() then return end
        self.state = "interacting"
        self.interact_timer = 5 -- Stays still for 5 ai ticks
        self.object:set_yaw(minetest.dir_to_yaw(vector.direction(self.object:get_pos(), clicker:get_pos())))
        techblox_npcs.ui.show_dialogue(clicker:get_player_name(), self)
    end
})
