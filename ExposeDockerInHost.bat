netsh advfirewall firewall add rule name="docker engine" dir=in action=allow protocol=TCP localport=2375
netsh interface portproxy add v4tov4 listenaddress=$((Test-Connection -ComputerName $env:computername -count 1).IPV4Address.ipaddressTOstring) listenport=2375 connectaddress=127.0.0.1 connectport=2375
Stop-Service docker
dockerd --unregister-service
dockerd -H npipe:// -H 0.0.0.0:2375 --register-service
Start-Service docker