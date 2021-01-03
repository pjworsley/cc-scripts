local storagehelper = {}

function storagehelper.build_map(storage_type)
    inventories = {peripheral.find(storage_type)}
    map = {}
    for _, inv in ipairs(inventories) do
        for slot, item in ipairs(inv.list()) do
            item_name = item["name"]
            -- populate table
            entry_info = {
                inv_name = peripheral.getName(inv),
                slot = slot,
                count = item["count"]
            }
            -- add table to map
            if map[item_name] == nil then
                map[item_name] = {entry_info}
            else
                map[item_name][#map[item_name] + 1] = entry_info
            end
        end
    end
    return map
end

function storagehelper.count(item_map, item_name)
    total = 0
    if item_map[item_name] then
        for _, item in ipairs(item_map[item_name]) do
            total = total + item["count"]
        end
    end
    return total
end

function storagehelper.move_item(storage_type, item_name, amount, to_name)
    item_map = storagehelper.build_map(storage_type)
    -- count up what we have in the system
    total = storagehelper.count(item_map, item_name)
    -- attempt to move items to destination
    if total == 0 then
        print("No items matching", item_name)
        return false
    end
    if total < amount then
        print("Only", total, "items in system, taking no action")
        return false
    end

    remaining = amount
    for _, entry in ipairs(item_map[item_name]) do
        inv = peripheral.wrap(entry["inv_name"])
        -- attempt to all the items we need
        inv.pushItems(to_name, entry["slot"], remaining)
        -- break if we just pushed all we need
        remaining = remaining - entry["count"]
        if remaining <= 0 then
            break
        end
        -- otherwise continue looping
    end
    print("Moved", amount, "items to", to_name)
    return true
end

return storagehelper