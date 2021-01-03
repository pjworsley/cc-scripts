local meclient = {}

PROTOCOL = "IDIOTN"
SERVER = 15
MODEM = peripheral.wrap("left")

function ping_server()
    rednet.send(SERVER, "ping", PROTOCOL)
    response = rednet.receive(PROTOCOL, 5)
    return response ~= nil
end

function meclient.request(item_name, amount)
    rednet.open(peripheral.getName(MODEM))
    online = ping_server()
    if not online then
        print("Controller is offline!")
        return false
    end
    rednet.send(SERVER, item_name .. " " .. amount, PROTOCOL)
    sender, success, _ = rednet.receive(PROTOCOL, 5)
    return success
end

return meclient