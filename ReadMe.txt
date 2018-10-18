- Make sure Docker is running on the host.
- Setting up docker host remote access:
  - Right click on the docker icon in the task bar
  - General > check 'Expose daemon on tcp://localhost:2375' without TLS
  - Run Powershell as admin and execute 'netsh interface portproxy add v4tov4 listenaddress=10.0.75.1 listenport=2375 connectaddress=127.0.0.1 connectport=2375'
  - In WindowsFirewall open port 2375 for local requests.

