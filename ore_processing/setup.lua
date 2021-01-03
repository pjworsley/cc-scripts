if not fs.exists("/startup") then
    fs.mkdir("/startup")
end

updater_script = [[
scripts = {
    "/chestmap.lua",
    "/oremap.lua",
    "/orecontroller.lua",
    "/storagehelper.lua"
}

baseurl = "https://raw.githubusercontent.com/pjworsley/cc-scripts/master/ore_processing"

for _, filename in ipairs(scripts) do
    print("Updating", filename, "...")
    request = http.get(baseurl .. filename)
    file = fs.open(filename, "w")
    file.write(request.readAll())
    file.close()
    request.close()
end
]]

update_script_path = "/startup/_update.lua"
if fs.exists(update_script_path) then
    fs.delete(update_script_path)
end
file = fs.open(update_script_path, "w")
file.write(updater_script)
file.close()
print("Setup complete. Rebooting in 3 seconds.")
sleep(3)
os.reboot()