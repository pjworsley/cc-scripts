function write_file(path, content)
    file = fs.open(path, "w")
    file.write(content)
    file.close()
end

if not fs.exists("/startup") then
    fs.mkdir("/startup")
end

updater_script = [[
scripts = {}
scripts["/chestmap.lua"] = "ore_processing/chestmap.lua"
scripts["/oremap.lua"] = "ore_processing/oremap.lua"
scripts["/orecontroller.lua"] = "ore_processing/orecontroller.lua"
scripts["/storagehelper.lua"] = "shared/storagehelper.lua"

baseurl = "https://raw.githubusercontent.com/pjworsley/cc-scripts/master/"

for local_path, remote_path in pairs(scripts) do
    print("Updating", local_path, "...")
    request = http.get(baseurl .. remote_path)
    file = fs.open(local_path, "w")
    file.write(request.readAll())
    file.close()
    request.close()
end
]]

write_file("/startup/_update.lua", updater_script)

print("Setup complete. Rebooting in 3 seconds.")
sleep(3)
os.reboot()