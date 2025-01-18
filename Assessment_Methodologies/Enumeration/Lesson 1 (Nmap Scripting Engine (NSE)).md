
---

## Importing Nmap Scan Results into MSF


For us to be able to import our Nmap scan results into Metasploit framework (MSF), we first need to store our scan results into XML format. Then, we need to start Postgresql service on our machine by: `service postgresql start`. 

Then, we start MSF by: `msfconsole`. This will start Metasploit.

We can check the status of the database being used by MSF by: `db_status`

To create a workspace to work at, we do:`workspace -a (name of workspace)`

To import our scan results into the workspace:`db_import (Path/to/results file name)`

To check if our results were imported successfully: `hosts`

We can do Nmap scan within the MSF by:`db_nmap` . **The results are automatically, saved into Metasploit**.

To list vulnerabilities discovered: `vulns`

---


## Port Scanning with Auxiliary Modules

###   T1046 : Network Service Scanning (Lab)
Auxiliary modules are used to perform functionality like scanning, discovery and fuzzing.

We can use Auxiliary modules to perform both TCP and UDP port scanning as well as enumerating information from services like FTP, SSH, HTTP etc. 

We can also use Auxiliary modules to discover hosts and perform port scanning on a different network subnet after we have obtained initial access on a target system.


We can use Auxiliary modules to scan internal servers and hosts.

We can start exploring the Auxiliary module in MSF by:`search portscan`

We will get multiple modules that match our search.

We will use "auxiliary/scanner/portscan/tcp" . To use a module:`use (name of module)`

Then, we can see what configurations are required and we can set for our module. To check the configurations of a module:`options`. We notice that some options are required and some are not.

For example, the module that we chose, the option RHOSTS is requried which si the the IP address of the Remote Host/s (host target). To set this option:`set (name of option) (value of option)` . For this particular option: `set Rhosts (target IP)`

Now, we found a 80 port open which means that there is a website running on the target machine. If we visited this website, we will find a login page with 'XODA' on the page.

If we searched this name using Metasploit, we will find one vulnerability related to XODA that involved file upload exploit. We will use that module.

In that module options, we need to set the RHOST, the TARGETURI (The path to the website index page), and LHOST (which is our IP address).

TARGETURI in this case is '/'

After setting the required options, we run the exploit.

After a while, we will notice that we gained a reverse shell to the target host and we can access the files within it.

Our task now is to scan the private network that this machine is connected to to discover other machines which are connected to the same network.

Since we don't have access to Nmap, we will need to write a bash script that will do the scanning for us.  First, we need to start a shell session, so we can have full control of the shell within our target host. 

**To start a shell session instead of the Meterpreter session within MSF:`shell`**

Now, we need to know the different IP addresses related to our target host:'ifconfig'

**AHA**, We see a different IP address on the eth1 network interface. This must be the private network. 
Now, we terminate our shell session, then in the Meterpreter session, we need to set the autoroute option with the IP address that we got earlier. 

<u>What is autoroute option?</u>

In Metasploit, the `autoroute` module is used to add and manage routes to networks that are reachable through a compromised target (pivoting). This functionality is crucial for performing lateral movement and attacking systems in networks that are not directly accessible from the attacker's machine.

We do that by: `autoroute -s (private IP network)`

Now, we can put this session in the background by: `background`, and we can view it along with any other active sessions by: `sessions`

We will use the TCP module scan we used before but for our new obtained IP. However, we need to change the last number of the IP address instead of 2 to 3.

We find 3 services running on the second target machine









