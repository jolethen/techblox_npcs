techblox_npcs = {}
techblox_npcs.modpath = minetest.get_modpath("techblox_npcs")
techblox_npcs.data_file = minetest.get_worldpath() .. "/techblox_npcs_data.json"

-- Load modules in dependency order
dofile(techblox_npcs.modpath .. "/storage.lua")
dofile(techblox_npcs.modpath .. "/zones.lua")
dofile(techblox_npcs.modpath .. "/ai.lua")
dofile(techblox_npcs.modpath .. "/quests.lua")
dofile(techblox_npcs.modpath .. "/roles.lua")
dofile(techblox_npcs.modpath .. "/ui.lua")
dofile(techblox_npcs.modpath .. "/npc.lua")
dofile(techblox_npcs.modpath .. "/commands.lua")

minetest.log("action", "[Techblox NPCs] MMO NPC Framework loaded.")
