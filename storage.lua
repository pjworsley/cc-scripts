local storage = {}

storage_type = "rftoolsstorage:modular_storage"

function storage.build_map()
    inventories = {peripheral.find(storage_type)};
    map = {};
    for _, inv in ipairs(inventories) do
        for slot, item in ipairs(inv.list()) do
            item_name = item["name"];
            -- populate table
            entry_info = {
                inv_name = peripheral.getName(inv)
                slot = slot
                count = item["count"]
            };
            -- add table to map
            if map[item_name] == nil then
                map[item_name] = {entry_info};
            else
                map[item_name][#map[item_name] + 1] = entry_info;
            end
        end
    end
    return map;
end

function storage.count(item_name, item_map)
    item_map = item_map or storage.build_map();
    total = 0;
    if not item_map[item_name] == nil then
        total = #item_map[item_name];
    end
    return total;
end

function storage.move_item(item_name, amount, to_name)
    item_map = storage.build_map();
    -- count up what we have in the system
    total = storage.count(item_name, item_map)
    -- attempt to move items to destination
    if total == 0 then
        print("No items matching", item_name);
    else if total < amount then
        print("Only", total, "items in system, taking no action")
    else
        remaining = amount;

        for _, entry in ipairs(item_map[item_name]) do
            inv = peripheral.wrap(entry["inv_name"]);
            -- attempt to all the items we need
            inv.pushItems(to_name, entry["slot"], remaining);
            -- break if we just pushed all we need
            remaining = remaining - entry["count"];
            if remaining <= 0 then
                print("Moved", amount, "items to", to_name)
                break;
            end
            -- otherwise continue looping
        end
    end
end

return storage