local storage = require("storage")

destination = "right"

item_name = arg[1]
amount = tonumber(arg[2]) or 64

success = storage.move_item(item_name, amount, destination)
print(success)