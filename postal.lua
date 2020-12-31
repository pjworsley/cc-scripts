printer = peripheral.wrap("printer_0")
input_chest = peripheral.wrap("minecraft:chest_1")

function create_ticket(send_to)
    if printer.getInkLevel() == 0 then
        print("Out of ink!")
        return
    end

    if printer.getInkLevel() == 0 then
        print("Out of Paper!")
        return
    end

    input_chest_list = input_chest.list()
    if #input_chest_list == 0 then
        print("No items in input chest")
        return
    end

    lines = {[1] = send_to}
    for _, item in ipairs(input_chest_list) do
        lines[#lines + 1] = item["name"] .. " " .. item["count"]
    end

    printer.newPage()
    for _, line in ipairs(lines) do
        printer.write(line)
        _, row = printer.getCursorPos()
        printer.setCursorPos(1, row + 1)
    end
    printer.endPage()
end

create_ticket("connor")
