techblox_npcs.quests = {
    ["q1_welcome"] = {
        title = "The MMO Journey",
        description = "Collect 10 wood to help build the guild hall.",
        objective_type = "collect",
        item = "default:wood",
        amount = 10,
        rewards = {xp = 50, item = "default:apple 5"}
    }
}

function techblox_npcs.get_player_quest_data(player_name)
    local data = techblox_npcs.storage:get_string(player_name .. "_quests")
    if data == "" then return {active = {}, completed = {}} end
    return minetest.deserialize(data)
end

function techblox_npcs.save_player_quest_data(player_name, data)
    techblox_npcs.storage:set_string(player_name .. "_quests", minetest.serialize(data))
end

function techblox_npcs.check_quest_completion(player, quest_id)
    local inv = player:get_inventory()
    local quest = techblox_npcs.quests[quest_id]
    
    if quest.objective_type == "collect" then
        if inv:contains_item("main", quest.item .. " " .. quest.amount) then
            inv:remove_item("main", quest.item .. " " .. quest.amount)
            return true
        end
    end
    return false
end
