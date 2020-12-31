local storage = require("storage")

if #arg == 0 then
    print("Usage: get item_name [amount]")
    return false
end

destination = "minecraft:chest_0"

item_name = arg[1]
amount = tonumber(arg[2]) or 64

return storage.move_item(item_name, amount, destination)