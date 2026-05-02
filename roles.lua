techblox_npcs.roles = {}

techblox_npcs.roles["farmer"] = function(self)
    if self.current_schedule == "work" then
        if self.state ~= "working" then
            self.state = "working"
            self.target_pos = techblox_npcs.zones.get_random_pos_in_zone(self.zones.work)
        end
        -- Move in work zone, pause occasionally to 'farm'
        techblox_npcs.ai.move_towards(self, self.target_pos)
        if vector.distance(self.object:get_pos(), self.target_pos) < 1.5 then
            self.target_pos = techblox_npcs.zones.get_random_pos_in_zone(self.zones.work)
        end
    else
        -- Default to roaming/sleeping
        self.state = "idle" 
    end
end

techblox_npcs.roles["guard"] = function(self)
    -- Guards patrol their roam zone continuously
    if not self.target_pos then
        self.target_pos = techblox_npcs.zones.get_random_pos_in_zone(self.zones.roam)
    end
    techblox_npcs.ai.move_towards(self, self.target_pos)
    if vector.distance(self.object:get_pos(), self.target_pos) < 2.0 then
        self.target_pos = techblox_npcs.zones.get_random_pos_in_zone(self.zones.roam)
    end
end
