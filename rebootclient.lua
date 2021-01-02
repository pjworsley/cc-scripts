protocol = "remotereboot"
modem_name = "top"

program = [[
rednet.open(modem_name)
rednet.receive(protocol)
print("Going to reboot in 5s")
sleep(5)
os.reboot()]]

function write_file(filepath, content)
    file = fs.open("/" .. filename, "w")
    file.write(request.readAll())
    file.close()
end

function main()
    shell.run("rebootclient")
end

main()