local storage = require("storage")

if #arg == 0 then
    print("Usage: get item_name")
    return
end

print(storage.count(arg[1]))