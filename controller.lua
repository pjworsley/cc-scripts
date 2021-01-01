local addressbook = require("addressbook")

protocol = "postal"

function move_all_items(from_id, to_id)
    from_inv = peripheral.wrap("minecraft:chest_" .. from_id)
    to_name = "minecraft:chest_" .. to_id

    for slot, _ in ipairs(from_inv.list()) do
        from_inv.pushItems(to_name, slot)
    end
end

function get_sender_chest_name(sender_computer_id)
    for key, val in pairs(addressbook) do
        if val["computer"] == sender_computer_id then
            return "minecraft:chest_" .. val["from_chest"]
        end
    end
end

function handle_message(sender, message)
    sender_chest_name = get_sender_chest_name(sender)
    recipient_chest_name = "minecraft:chest_" .. addressbook[message]["to_chest"]
    print("Moving items from", sender_chest_name, "to", recipient_chest_name)
    move_all_items(sender_chest_name, recipient_chest_name)
end

function start(modem_name)
    print("Setting up...")
    rednet.open(modem_name)
    while true do
        print("Waiting for messages...")
        sender, message, _ = rednet.receive(protocol)
        handle_message(sender, message)
    end
end

start("right")