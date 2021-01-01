local addressbook = require("addressbook")

protocol = "postal"
modem_name = "top"
send_chest = peripheral.wrap("right")

function list_recipients()
    print("Recipient list:")
    for key, _ in pairs(addressbook) do
        if key ~= "controller" then
            print(" -", key)
        end
    end
end

if #arg == 0 then
    print("Usage: send recipient")
    list_recipients()
    return
end

-- check name exists in addressbook
if addressbook[arg[1]] == nil then
    print("Recipient not in address book!")
    list_recipients()
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
-- send to controller, message payload is id of recipient computers
rednet.send(
    addressbook["controller"]["computer"],
    addressbook[arg[1]]["computer"],
    protocol)
print("Sent to", arg[1])