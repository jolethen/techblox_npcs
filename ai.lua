techblox_npcs.ai = {}

local states = {
    idle = function(self)
        self.object:set_velocity({x=0, y=self.object:get_velocity().y, z=0})
        if math.random(1, 4) == 1 then
            self.state = "roaming"
            self.target_pos = techblox_npcs.zones.get_random_pos_in_zone(self.zones.roam)
        end
    end,
    
    roaming = function(self)
        if not self.target_pos then 
            self.state = "idle"
            return 
        end
        techblox_npcs.ai.move_towards(self, self.target_pos)
        
        local dist = vector.distance(self.object:get_pos(), self.target_pos)
        if dist < 2.0 then
            self.state = "idle"
            self.target_pos = nil
        end
    end,

    interacting = function(self)
        self.object:set_velocity({x=0, y=self.object:get_velocity().y, z=0})
        self.interact_timer = (self.interact_timer or 0) - 1
        if self.interact_timer <= 0 then
            self.state = "idle"
        end
    end
}

function techblox_npcs.ai.move_towards(self, target)
    local pos = self.object:get_pos()
    if not pos or not target then return end
    
    if minetest.line_of_sight(pos, target) then
        local dir = vector.direction(pos, target)
        local vel = vector.multiply(dir, 2)
        vel.y = self.object:get_velocity().y -- Engine handles gravity
        
        self.object:set_velocity(vel)
        
        -- CRITICAL FIX: Prevent yaw calculation crash if x and z are 0
        if math.abs(dir.x) > 0.001 or math.abs(dir.z) > 0.001 then
            self.object:set_yaw(minetest.dir_to_yaw(dir))
        end
    else
        local path = minetest.find_path(pos, target, 16, 1, 1, "A*_noprefetch")
        if path and #path > 1 then
            local next_step = path[2]
            local dir = vector.direction(pos, next_step)
            local vel = vector.multiply(dir, 2)
            vel.y = self.object:get_velocity().y
            self.object:set_velocity(vel)
            
            if math.abs(dir.x) > 0.001 or math.abs(dir.z) > 0.001 then
                self.object:set_yaw(minetest.dir_to_yaw(dir))
            end
        else
            self.state = "idle"
            self.target_pos = nil
        end
    end
end

function techblox_npcs.ai.tick(self)
    local time = minetest.get_timeofday()
    self.current_schedule = (time > 0.2 and time < 0.8) and "work" or "sleep"

    if self.role and techblox_npcs.roles[self.role] then
        techblox_npcs.roles[self.role](self)
    else
        if states[self.state] then
            states[self.state](self)
        else
            self.state = "idle"
        end
    end
end
