- Make sure Docker is running on the host.
- Setting up docker host remote access:
  - Right click on the docker icon in the task bar
  - General > check 'Expose daemon on tcp://localhost:2375' without TLS
  - Run Powershell as admin and execute 'netsh interface portproxy add v4tov4 listenaddress=10.0.75.1 listenport=2375 connectaddress=127.0.0.1 connectport=2375'
  - In WindowsFirewall open port 2375 for local requests.




############## Using Shell #########################

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name DockerMsftProvider -Force
Install-Package -Name docker -ProviderName DockerMsftProvider -Force
Restart-Computer -Force

# Docker Engine is now running as a Windows service, listening on the default Docker named pipe. For development VMs running (for example) in a Hyper-V VM on Windows 10, it might be advantageous to make the Docker Engine running in the Windows Server 2016 VM available to the Windows 10 host:

# Open firewall port 2375
netsh advfirewall firewall add rule name="docker engine" dir=in action=allow protocol=TCP localport=2375

# Configure Docker daemon to listen on both pipe and TCP (replaces docker --register-service invocation above)
Stop-Service docker
dockerd --unregister-service
dockerd -H npipe:// -H 0.0.0.0:2375 --register-service
Start-Service docker

The Windows Server 2016 Docker engine can now be used from the VM host by setting DOCKER_HOST:
$env:DOCKER_HOST = "<ip-address-of-vm>:2375"