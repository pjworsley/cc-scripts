local storage = {}

storage_type = "rftoolsstorage:modular_storage"

function storage.query(item_name)
    inventories = {peripheral.find(storage_type)};
    entries = {};
    for _, inv in ipairs(inventories) do
        for _, item in ipairs(inv.list()) do
            if item["name"] == item_name then
                -- append entry to thej entries array
                entries[#entries + 1] = item;
            end
        end
    end
    return entries;
end

function storage.total_items(items)
    total = 0;
    for _ , stack in ipairs(items) do
        total = total + items[i]["count"];
    end
    return total;
end