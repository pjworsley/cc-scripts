local chest_map = require("chestmap")
local ore_map = require("oremap")
local me_client = require("me_client")
local storagehelper = require("storagehelper")

INGOT_STORE_TYPE = "minecraft:trapped_chest"
ORE_STORE = peripheral.wrap("minecraft:chest_35")
MULTIPLIER = 4

function perform_transaction(input_chest, output_chest)
    -- loop through input chest contents
    for slot, stack in ipairs(input_chest.list()) do
        -- check ore is supported
        if ore_map[stack["name"]] ~= nil then
            -- do trade 1 ore at a time. This is slow, but careful.
            for i=1, stack["count"] do
                -- request ingots from ME computer
                me_success = me_client.request(
                    ore_map[stack["name"]],
                    MULTIPLIER)
                if not me_success then
                    print("me item request failed!")
                    break
                end

                -- move 4 ingots to output chest
                success = storagehelper.move_item(
                    INGOT_STORE_TYPE,
                    ore_map[stack["name"]],
                    MULTIPLIER,
                    peripheral.getName(output_chest))

                if success then
                    -- take payment of 1 ore
                    input_chest.pushItems(
                        peripheral.getName(ORE_STORE),
                        slot,
                        1)
                else
                    -- break the loop over the stack of ore, as the remainder
                    -- wont work either
                    print("No stock for transaction.")
                    break
                end
            end
        end
    end
    unprocessed_ore = 0
    -- any ore that is left in the chest at this point cannot be processed
    -- and so should be returned to owner
    if #input_chest.list() > 0 then
        for slot, stack in ipairs(input_chest.list()) do
            input_chest.pushItems(peripheral.getName(output_chest), slot)
            unprocessed_ore = unprocessed_ore + stack["count"]
        end
    end
    return unprocessed_ore
end

function get_chest(chest_id)
    return peripheral.wrap("minecraft:chest_" .. chest_id)
end

function check_input_chests()
    -- loop through each input chest and process the contents
    for name, info in pairs(chest_map) do
        input_chest = get_chest(info["ore_chest"])
        num_ore_pending = #input_chest.list()
        if num_ore_pending > 0 then
            print(name, "is waiting for ingots")
            num_unprocessed = perform_transaction(
                input_chest,
                get_chest(info["ingot_chest"])
            )
            stat = num_ore_pending - num_unprocessed .. "/" .. num_ore_pending
            print("Processed", stat "for", name)
        end
    end
end

function system_check()
    -- loop through all the chests in map and try to access each of them
    for name, info in pairs(chest_map) do
        get_chest(info["ore_chest"])
        get_chest(info["ingot_chest"])
    end
end

function start()
    print("Ready. Hold ctrl-t to interrupt.")
    while true do
        check_input_chests()
        sleep(5)
    end
end

start()