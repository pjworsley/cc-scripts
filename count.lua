local storage = require("storage")

if not arg then
    print("Usage: get item_name")
    return
end

print(storage.count(arg[1]))