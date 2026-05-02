techblox_npcs.zones = {}

function techblox_npcs.zones.is_in_zone(pos, zone)
    if not zone or not zone.pos1 or not zone.pos2 then return true end
    local minp = {
        x = math.min(zone.pos1.x, zone.pos2.x),
        y = math.min(zone.pos1.y, zone.pos2.y),
        z = math.min(zone.pos1.z, zone.pos2.z)
    }
    local maxp = {
        x = math.max(zone.pos1.x, zone.pos2.x),
        y = math.max(zone.pos1.y, zone.pos2.y),
        z = math.max(zone.pos1.z, zone.pos2.z)
    }
    return pos.x >= minp.x and pos.x <= maxp.x and
           pos.y >= minp.y and pos.y <= maxp.y and
           pos.z >= minp.z and pos.z <= maxp.z
end

function techblox_npcs.zones.get_random_pos_in_zone(zone)
    if not zone or not zone.pos1 or not zone.pos2 then return nil end
    
    -- CRITICAL FIX: math.floor ensures we pass integers to math.random
    local min_x = math.floor(math.min(zone.pos1.x, zone.pos2.x))
    local max_x = math.floor(math.max(zone.pos1.x, zone.pos2.x))
    local min_z = math.floor(math.min(zone.pos1.z, zone.pos2.z))
    local max_z = math.floor(math.max(zone.pos1.z, zone.pos2.z))
    local y_level = math.floor(math.max(zone.pos1.y, zone.pos2.y))

    return {
        x = math.random(min_x, max_x),
        y = y_level,
        z = math.random(min_z, max_z)
    }
end
