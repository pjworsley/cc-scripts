local addressbook = require("addressbook")
local ore_map = require("oremap")
local storagehelper = require("storagehelper")

protocol = "oreprocessing"
ingot_store_type = "appliedenergistics2:interface"
ore_store = peripheral.wrap("left")
multiplier = 4

function get_info(computer_id)
    for key, val in pairs(addressbook) do
        if val["computer"] == computer_id then
            return key, val
        end
    end
end

function ingot_in_stock(ore_name, ore_num)
    ingot_name = ore_map[ore_name]
    item_map = storagehelper.build_map(ingot_store_type)
    ingots_available = storagehelper.count(item_map, ingot_name)
    return ingots_available >= ore_num * multiplier
end

function handle_process_ore_request(sender_id)
    client_name, client_info = get_info(sender_id)
    ingot_chest_name = "minecraft:chest_" .. client_info["ingot_chest"]
    -- loop through input chest contents
    input_chest = peripheral.wrap("minecraft:chest_" .. client_info["ore_chest"])
    for slot, stack in ipairs(input_chest.list()) do
        -- check ore is supported
        if ore_map[stack["name"]] ~= nil then
            -- do trade 1 ore at a time, slow, but careful
            for i=1, stack["count"] do
                -- attempt to push 4 ingots
                print("Attempting to send 4", ore_map[stack["name"]], "to", client_name)
                success = storagehelper.move_item(
                    ingot_store_type,
                    ore_map[stack["name"]],
                    multiplier,
                    ingot_chest_name)

                if success then
                    print("Taking 1 ore from", client_name, "as payment")
                    -- push 1 ore into ore store
                    input_chest.pushItems(
                        peripheral.getName(ore_store),
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
    -- any ore that is left in the chest at this point cannot be processed
    -- and so should be returned to owner
    if #input_chest.list() > 0 then
        print("Returning", #input_chest.list(), "to", client_name)
        for slot, _ in ipairs(input_chest.list()) do
            input_chest.pushItems(ingot_chest_name, slot)
        end
    end
end

function handle_ping(sender_id)
    print("Responding to ping from", sender_id)
    rednet.send(sender_id, "pong", protocol)
end

function handle_message(sender_id, message)
    if message == "ping" then
        handle_ping(sender_id)
    else
        handle_process_ore_request(sender_id)
    end
end

function start(modem_name)
    print("Setting up rednet...")
    rednet.open(modem_name)
    print("Ready.")
    while true do
        print("Waiting for messages...")
        sender, message, _ = rednet.receive(protocol)
        handle_message(sender, message)
    end
end

start("back")