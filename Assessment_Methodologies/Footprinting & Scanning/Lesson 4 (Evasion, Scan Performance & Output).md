
---

## Evasion, Scan Performance & Output

**We can use the -sA (ACK) scan in Nmap which will show us what ports are protected with firewalls and what ports are not.**

==If ports which are not protected by firewalls (unfiltered) are scanned using ACK scan, the will send back a RST response. If Nmap received ICMP error or no response at all, then the ports are protected (filtered).==

**<u>Note: For more accureate results, we need to specify the ports</u>**

**We can make it harder for IDS or firewalls to detect our scan by using -f (fragmentation)** which divides our packets to fragments. W**e can also set the maximum size of our packets using --mtu**

We can use -S (Spoof) to spoof our IP address, making firewalls and IDS think that the scan is coming from somewhere else other than our real IP. However, we need to specify an IP address that is related to our network. For example, if our IP was 10.10.14.7, we can specify the spoofed IP address to be of our gateway, which is always the first IP address in our subnet, in this case: 10.10.14.1.

We can also specify a Decoy IP address using the -D flag. This will add another IP address as the source of our scan, so instead of replacing our real IP address with another one, we will add another IP address so the scan will appear as if it was coming from multiple sources.


---


## Optimizing Nmap Scans


**We can limit the time Nmap is waiting for a response for from the target by --host-timeout**.  This can reduce the time of our scan when dealing with unresponsive hosts or ports.

**We can also specify a delay between the packets that Nmap sends using --scan-delay or --max-scan-delay**

---

## Nmap Output Formats

We can identify the output file format of our scan results using -oN/-oX/-oS/-oG
 for different kinds of file formats.
