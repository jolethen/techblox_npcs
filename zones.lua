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
    if not zone then return nil end
    return {
        x = math.random(math.min(zone.pos1.x, zone.pos2.x), math.max(zone.pos1.x, zone.pos2.x)),
        y = math.max(zone.pos1.y, zone.pos2.y), -- Simplified: assume surface level
        z = math.random(math.min(zone.pos1.z, zone.pos2.z), math.max(zone.pos1.z, zone.pos2.z))
    }
end
