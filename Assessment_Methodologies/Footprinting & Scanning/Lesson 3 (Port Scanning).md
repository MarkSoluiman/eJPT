---

---

---

## Port scanning with Nmap

We can use the **-p** to specify port/ports that we want to scan.

**If we are dealing with Windows Firewall and it is protecting port/ports that we scanned, nmap will say that it is filtered.** 

We can use **-sS for port scanning**.

-sS is Stealth scan. Nmap sends a SYN packet to a port to check for its state.
Then, it waits for the port response. SYN-ACK if open, RST if closed.
If nmap does't receive a response or it indicated that the port is filtered, then there might be a firewall on that port. This scan requires root privileges.

**-sS differs from -PS scan. -PS is used for host discovery while -sS is used for port analyses.**

Stealth scan is fast as it doesn't complete the three-way handshake. Once the target response with SYN-ACK, nmap sends RST back. 
![[Pasted image 20250114171558.png]]


**A much more reliable scan but much louder is TCP connect scan -sT**. Instead of aborting the three-way handshake with RST flag as the Stealth scan does, TCP connect scan completes the three-way handshake with its own ACK packet.

![[Pasted image 20250114172439.png]]

This scan might be a better option than Stealth scan in some cases:
- **No need for root privileges**: -sT doesn't require root privileges to be performed by nmap.
- **Compatibility with Firewalls and IDS**: -sT performs a full three-way handshake, which some firewalls and intrusion Detection Systems might allow as normal traffic.
- **Transparency in Results**:Since it completes the handshake, it is clear that the connection attempt was fully successful or not. This might make results more explicit.

---

## Service Version & OS Detection


We can tell nmap to perform an **Operating system scan by -O**. Sometimes, nmap is not able to find out what the OS is running on the target host. In this case, we can tell nmap to perform another OS scan but to be aggressive this time by: **``-O --osscan-guess``** . **The result will include the percentage of how sure nmap is of the operating system** . We can do the same thing for version scan by: **-sV --version-intensity (number)** . **The number can be from 1 to 9**, the higher the number, the more accurate the guess of nmap is .

---

## Nmap Scripting Engine (NSE)


**We can find the scripts library that we can use in nmap under /usr/share/nmap/scripts**

We can list them using ls -la and then filter what scripts we need to use by using the grep command. For example, after scanning the ports for a target host, we found a mongodb service running on one of the hosts. In order to find scripts related to mongodb, we can run: `ls -la /usr/share/nmap/scripts | grep "mongodb"`. This will list all of the scripts that we can use which are related to mongodb.

There are multiple categories that these scripts fall under: **auth, broadcast, brute, default, discovery, dos , exploit, external, fuzzer,  , intrusive, malware, safe, version, and vuln. 

**We can specify the script category by: --script=(category name)**

**In order to use the default script by -sC**. If we want to know about a particular script, we can do so by: **--script-help=(name of script)** 

We can run particular scripts **by removing the -sC flag and instead we do: --script=(name of script)**

**If we want to run multiple scripts which are related to a specific service, for example ftp,we can do: --script=ftp-* .**

**Instead of specifying OS detection scan, version scan, script scan. We can simply use -A which is called Aggressive scan.**






