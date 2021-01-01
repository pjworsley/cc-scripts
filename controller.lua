local addressbook = require("addressbook")

protocol = "postal"

function move_all_items(from_name, to_name)
    from_inv = peripheral.wrap(from_name)
    for slot, _ in ipairs(from_inv.list()) do
        from_inv.pushItems(to_name, slot)
    end
end

function get_info(computer_id)
    for key, val in pairs(addressbook) do
        if val["computer"] == computer_id then
            return key, val
        end
    end
end

function generate_chest_name(chest_id)
    return "minecraft:chest_" .. chest_id
end

function handle_message(sender_id, recipient_id)
    sender_name, sender_info = get_info(sender_id)
    recipient_name, recipient_info = get_info(recipient_id)
    print(
        "Moving items from",
        sender_name,
        "(chest_" .. sender_info["from_chest"] .. ") to",
        recipient_name,
        "(chest_" .. recipient_name["to_chest"] .. ")."
    )
    -- move items between the chests
    move_all_items(
        generate_chest_name(sender_info["from_chest"]),
        generate_chest_name(recipient_info["to_chest"])
    )
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

start("right")