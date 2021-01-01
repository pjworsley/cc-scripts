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