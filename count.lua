local storage = require("storage")

if not args then
    print("Usage: get item_name")
    return
end

print(storage.count(args[1]))