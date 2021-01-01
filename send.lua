local addressbook = require("addressbook")

protocol = "postal"
modem_name = "left"
send_chest = peripheral.wrap("right")

if #arg == 0 then
    print("Usage: send recipient")
    return
end

-- check name exists in addressbook
if addressbook[arg[1]] == nil then
    print("Recipient not in address book. Valid options are:")
    for key, _ in pairs(addressbook) do
        print(" -", key)
    end
    return
end

-- wait for send chest to empty
while #send_chest.list() > 0 do
    print(
        "Waiting for chest to empty,",
        #send_chest.list(),
        "stack(s) remain."
    )
    sleep(1)
end

-- send the message
rednet.open(modem_name)
rednet.send(addressbook["controller"]["computer"], arg[1], protocol)
print("Sent to", arg[1])