scripts = {
    "send.lua",
    "addressbook.lua",
    "controller.lua"
}

baseurl = "https://raw.githubusercontent.com/pjworsley/cc-scripts/master/"

for _, filename in ipairs(scripts) do
    print("Updating", filename, "...")
    request = http.get(baseurl .. filename)
    file = fs.open("/" .. filename, "w")
    file.write(request.readAll())
    file.close()
    request.close()
end

if os.getComputerID() == 10 then
    if fs.exists("/startup/controller.lua") then
        fs.delete("/startup/controller.lua")
    end
    fs.move("/controller.lua", "/startup/controller.lua")
end