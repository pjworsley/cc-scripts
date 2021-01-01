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

function check_arguments()
    if #arg == 0 then
        print("Usage: send recipient")
        list_recipients()
        exit()
    end
    -- check name exists in addressbook
    if addressbook[arg[1]] == nil then
        print("Recipient not in address book!")
        list_recipients()
        exit()
    end
end

function wait_for_empty(chest)
    while #chest.list() > 0 do
        print(
            "Waiting for chest to empty,",
            #chest.list(),
            "stack(s) remain."
        )
        sleep(1)
    end
end

function main()
    -- check user supplied args
    check_arguments()
    -- wait for send chest to empty
    wait_for_empty(send_chest)
    -- open modem
    rednet.open(modem_name)
    -- check connection to controller
    rednet.send(
        addressbook["controller"]["computer"],
        "ping",
        protocol)
    response = rednet.receive(protocol, 5)
    if response == nil then
        -- controller is offline
        print("Controller is offline! Unable to do anything.")
    else
        -- send to controller, message payload is id of recipient computer
        rednet.send(
            addressbook["controller"]["computer"],
            addressbook[arg[1]]["computer"],
            protocol)
        print("Sent to", arg[1])
    end
end

main()