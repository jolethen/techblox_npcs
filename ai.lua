techblox_npcs.ai = {}

-- FSM States
local states = {
    idle = function(self)
        self.object:set_velocity({x=0, y=0, z=0})
        if math.random(1, 5) == 1 then
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
        if dist < 1.5 then
            self.state = "idle"
            self.target_pos = nil
        end
    end,

    interacting = function(self)
        self.object:set_velocity({x=0, y=0, z=0})
        -- Will return to idle after UI closes via timer
        self.interact_timer = (self.interact_timer or 0) - 1
        if self.interact_timer <= 0 then
            self.state = "idle"
        end
    end
}

function techblox_npcs.ai.move_towards(self, target)
    local pos = self.object:get_pos()
    
    -- CPU Saver: Use line-of-sight vector movement instead of find_path when possible
    if minetest.line_of_sight(pos, target) then
        local dir = vector.direction(pos, target)
        local speed = 2
        local vel = vector.multiply(dir, speed)
        vel.y = self.object:get_velocity().y -- keep gravity
        self.object:set_velocity(vel)
        self.object:set_yaw(minetest.dir_to_yaw(dir))
    else
        -- Fallback to A* only when obstructed
        local path = minetest.find_path(pos, target, 16, 1, 1, "A*_noprefetch")
        if path and #path > 1 then
            local next_step = path[2]
            local dir = vector.direction(pos, next_step)
            local vel = vector.multiply(dir, 2)
            self.object:set_velocity(vel)
            self.object:set_yaw(minetest.dir_to_yaw(dir))
        else
            -- Path failed, reset
            self.state = "idle"
            self.target_pos = nil
        end
    end
end

function techblox_npcs.ai.tick(self)
    -- Schedule Check
    local time = minetest.get_timeofday()
    if time > 0.2 and time < 0.8 then
        self.current_schedule = "work"
    else
        self.current_schedule = "sleep"
    end

    -- Execute Role overrides, else default FSM
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
