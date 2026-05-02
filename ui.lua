techblox_npcs.ui = {}

function techblox_npcs.ui.show_dialogue(player_name, npc_self)
    local p_quests = techblox_npcs.get_player_quest_data(player_name)
    local formspec = "size[8,6]" ..
        "label[0.5,0.5;" .. minetest.formspec_escape(npc_self.npc_name .. " (" .. npc_self.role .. ")") .. "]" ..
        "textarea[0.5,1.5;7.5,2;;;Greetings, traveler. How can I assist you today?]"
        
    -- Example hardcoded quest offer for trader role
    if npc_self.role == "trader" and not p_quests.completed["q1_welcome"] then
        if not p_quests.active["q1_welcome"] then
            formspec = formspec .. "button[0.5,4;7,1;accept_q1;Accept Quest: The MMO Journey]"
        else
            formspec = formspec .. "button[0.5,4;7,1;complete_q1;Complete Quest: The MMO Journey]"
        end
    end
    
    formspec = formspec .. "button_exit[3,5;2,1;close;Goodbye]"
    minetest.show_formspec(player_name, "techblox_npcs:dialogue_"..npc_self.npc_id, formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if string.sub(formname, 1, 23) == "techblox_npcs:dialogue_" then
        local player_name = player:get_player_name()
        local p_quests = techblox_npcs.get_player_quest_data(player_name)

        if fields.accept_q1 then
            p_quests.active["q1_welcome"] = true
            techblox_npcs.save_player_quest_data(player_name, p_quests)
            minetest.chat_send_player(player_name, "Quest Accepted: The MMO Journey")
        elseif fields.complete_q1 then
            if techblox_npcs.check_quest_completion(player, "q1_welcome") then
                p_quests.active["q1_welcome"] = nil
                p_quests.completed["q1_welcome"] = true
                techblox_npcs.save_player_quest_data(player_name, p_quests)
                
                -- Give reward
                player:get_inventory():add_item("main", "default:apple 5")
                minetest.chat_send_player(player_name, "Quest Completed! You received 5 Apples.")
            else
                minetest.chat_send_player(player_name, "You don't have the required items yet.")
            end
        end
    end
end)
