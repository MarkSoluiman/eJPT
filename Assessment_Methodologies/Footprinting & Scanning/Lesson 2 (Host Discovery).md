
---


## Network Mapping

Network mapping in the context of pen-testing refers to the process of discovering and identifying devices, hosts, and network infrastructure elements within a target network.

The objectives of network mapping:

- **Discover live hosts**: Identifying active devices and hosts on the network. This involves determining which IP addressees are currently in use. 
- **Identification of open ports and services**: Determining which ports are open on the discovered hosts and identifying the services running on those ports. This information helps pen-testes understand the attack surface and potential vulnerabilities.
- **Network topology mapping**: Creating a map or diagram of the network topology, including routers, switches, firewalls and other network infrastructure elements. Understanding the layout of the network assets in planning further pen-testing activities.
- **Operating system fingerprinting**: Determining the operating systems running on discovered hosts. Knowing the operating system helps pen-testes tailor their attack strategies on target vulnerabilities specific to that OS. 
- **Service version detection**: Identifying specific version of services running on open ports. This information is crucial for pinpointing vulnerabilities associated with particular service version.
- **Identifying filtering and security measures**: Discovering firewalls, intrusion prevention systems, and other security measures in place. This helps pen-testers understanding the network's defenses and plan their approach accordingly.

---

## Host Discovery Techniques


- **Ping Sweeps**: Sending ICMP Echo requests to a range of IP addresses to identify the live hosts.
 - **ARP Scanning**: Using Address Resolution Protocol requests to identify hosts on a local network. ARP scanning is **effective in discovering hosts within the same broadcast domain.
 - **TCP SYN Ping (Half-Open Scan):** Sending TCP SYN packets to a specific port **(often port 80)** to check if a host is alive. If the host is alive, it responds with a **TCP SYN-ACK**. This technique is **stealthier than ICMP ping.
 - **UDP Ping**: Sending UDP packets to a specific port to check if a host is alive. This can be effective for **hosts that don't respond to  ICMP or TCP traffic.
 - **TCP ACK Ping**: Sending TCP ACK packets to specific port to check if a host is alive. This technique **expects no response, but if a TCP RST (reset) is received, it indicates that the host is alive.
 - **SYN-ACK Ping (Sends SYN-ACK packets)**: Sending SYN-ACK packets to a specific port to check if a host is alive. If a TCP RST is received, it indicates that the host is alive. 

ICMP Ping:
- Pros: ICMP ping is a widely supported and quick method for identifying live hosts.
- Cons: Some hosts or firewalls may be configured to block ICMP traffic, limiting its effectiveness. ICMP ping can be easily detected. 

TCP SYN Ping: 
- Pros: TCP SYN ping is stealthier than ICMP and may bypass firewalls that allow outbound connections.
- Cons: Some hosts may not respond to TCP SYN requests, and the resutls can be affected by firewalls and security devices.


---

## Ping Sweeps

The **Ping** command is used to perform a Ping Sweep scan.

Ping sweeps work by sending one or more specially crafted ICMP packets (Type 8- echo request) to a host. 

If the destination host replies with an ICMP echo reply (Type 0) packet, then the host is alive.

If the host is online, the sweep would look like this:
- ICMP Echo Request:
	- Type:8
	- Code:0
- ICMP Echo Reply:
	- Type: 0
	- Code: 0

The Type field in the ICMP header **indicate the purpose or function of the ICMP message**, and the Code field **provides additional information or context related to the message type.  

In the case of the ICMP Echo Request and Echo Reply, **the Type value 8 represents Echo Request, and the Type value 0 represents Echo Reply.**

The absence of a response from a ping sweep doesn't always mean that the host is offline, it could be due to various reasons, such as a network congestion, temporary unavailable, or a firewall settings that block the ICMP.

Another tool we can use instead of ping is **fping**

---

## Host Discovery with Nmap

In this lab, we have a target that we want to know if it is online or not and what services are running on it if any. Our target is demo.ine.local.

First we start with a ping sweep scan with 5 packets sent: ``ping -c 5 demo.ine.local``


All of the packets that we sent are lost. 

We will try nmap: ``nmap demo.ine.local``

Nmap doesn't find the target alive. The target might have a firewall that prevents any ICMP packets from reaching it, so we will disable ping with nmap: ``nmap -Pn demo.ine.local``

The target is alive and it has some open ports with different services running on them. One of the ports which are open is port 80 which means that the target is running a website using HTTP.

If we want more info about this specific port, we can use nmap to do so: ``nmap -Pn -p 80 -sV demo.ine.local``

**The total opposite of the -Pn is -sn which makes nmap to only send ICMP packets to the target.** Also, -sn doesn't allow nmap to perform a port scan

We can specify for nmap to use SYN ping for host discovery by using **-PS**. This allows us to skip other default discovery probes and only send SYN packets. This is useful when ICMP is blocked, but some TCP ports are open.

**When performing host discovery on multiple IPs/subnet, it is a good practice to tell nmap to not do the port scanning part of its scan by adding -sn flag**. However, when we do a scan on a single IP address, we should remove the -sn scan and replace it with port discovery flags like -PS with a list of ports that might have a service running on it like 80, 3389



