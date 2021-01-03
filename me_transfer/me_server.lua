local storagehelper = require("storagehelper")

PROTOCOL = "IDIOTN"
MODEM = peripheral.wrap("top")
INGOT_STORE_TYPE = "appliedenergistics2:interface"
OUTPUT_CHEST = peripheral.wrap("minecraft:chest_30")

function mysplit (inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

function parse_request(message)
    t = mysplit(message)
    return t[1], tonumber(t[2])
end

function handle_ingot_request(sender, message)
    item_name, amount = parse_request(message)
    print("Request for", amount, item_name)
    success = storagehelper.move_item(
        INGOT_STORE_TYPE,
        item_name,
        amount,
        peripheral.getName(OUTPUT_CHEST))
    rednet.send(sender, success, PROTOCOL)
    print("Delivered items:", success)
end

function handle_ping(sender)
    print("Responding to ping from", sender)
    rednet.send(sender, "pong", PROTOCOL)
end

function handle_message(sender, message)
    if message == "ping" then
        handle_ping(sender)
    else
        handle_ingot_request(sender, message)
    end
end

function start(modem)
    print("Setting up rednet...")
    rednet.open(peripheral.getName(modem))
    print("Ready.")
    while true do
        print("Waiting for messages...")
        sender, message, _ = rednet.receive(PROTOCOL)
        handle_message(sender, message)
    end
end

start(MODEM)