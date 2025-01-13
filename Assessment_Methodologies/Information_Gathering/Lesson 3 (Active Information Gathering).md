
---

## #DNS Zone Transfers


There are multiple info we can get from the DNS:

| Record    | Description                                                                                   |
|:--------- |:--------------------------------------------------------------------------------------------- |
| **AAAA**  | The record that contains the IPv6 address for a domain                                        |
| **A**     | The record that holds the IP address of a domain                                              |
| **CNAME** | Forwards one domain or subdomain to another domain, does NOT provide an IP address            |
| **MX**    | Directs mail to an email server                                                               |
| **TXT**   | Lets an admin store text notes in the record. These records are often used for email security |
| **NS**    | Stores the name server for a DNS entry                                                        |
| **SOA**   | Stores admin information about a domain                                                       |
| **SRV**   | Specifies a port for specific services                                                        |
| **PTR**   | Provides a domain name in reverse-lookups                                                     |

## DNS Interrogation

- DNS interrogation is the process of enumerating DNS records for a specific domain.
- The objective of DNS interrogation is to probe a DNS server to provide us with DNS records for a specific domain.
- This process can provide with important information like the IP address of a domain subdomains, mail server addresses etc.

## DNS Zone Transfer

- In certain cases, DNS server admins may want to copy or transfer zone files from one DNS server to another. This process is known as a zone transfer.
- If misconfigured and left unsecured, this functionality can be abused by attackers to copy the zone file from the primary DNS server to another DNS server.
- A DNS zone transfer can provide pen-testers with a holistic view of an organization's network layout.
- Furthermore, in certain cases, internal network addresses may be found on an organization's DNS servers.

We can use ==dnsenum== for active DNS enumeration.

We can also perform zone transfer with ==dig==.

<u>Usage example</u>:

dig [@global-server] [domain] [q-type] [q-class] {q-opt} {global-d-opt} host [@local-server] {local-d-opt}[ host [@local-server] {local-d-opt} [...]]

<u>where:</u> 
- q-class  is one of (in,hs,ch,...) [default: in]
- q-type   is one of (a,any,mx,ns,soa,hinfo,axfr,txt,...) [default:a]
- q-opt    is one of:
 -4                  (use IPv4 query transport only)
 -6                  (use IPv6 query transport only)

There are more options than that in the help page of the tool.

<u> Example usage</u>:

dig axfr @nsztm2.digi.ninja zonetransfer.me


Another tool we can use is called ==fierce==.

Fierce is **a semi-lightweight scanner that helps locate non-contiguous IP space and hostnames against specified domains**. It's really meant as a pre-cursor to nmap, unicornscan, nessus, nikto, etc, since all of those require that you already know what IP space you are looking for

---

## Host Discovery with Nmap

<u>Useful cheat sheet:</u> https://cdn.comparitech.com/wp-content/uploads/2019/06/Nmap-Cheat-Sheet.pdf

For host discovery: nmap -sn {target IP}/subnet 

The result will give us the IPs of devices connected to the same network. **The next step is to do port scan on each of these IPs**.

Another tool we can use is ==netdiscover.== 

#### Useful flags:

| Flags | Description                                                                |
| ----- |:-------------------------------------------------------------------------- |
| -i    | interface                                                                  |
| -r    | range: scan a given range instead of auto scan. 192.168.6.0/24,/16,/8 |
| -p    | passive mode: do not send anything, only sniff                             |

---

## Port Scanning with #Nmap


**For Windows host machines, a default nmap scan would not work because they typically block any ICMP traffic coming to their network which is what nmap uses to ping the machine to check if the machine is up or not**. To bypass that, we can us the **-Pn** flag which will deactivate the ping or in other words, not use the ICMP protocol.

#### Useful flags:

| flags   | Description                                                                                                                 |
| ------- | --------------------------------------------------------------------------------------------------------------------------- |
| -Pn     | disable Ping scan                                                                                                           |
| -F      | Fast scan (first 100 ports only)                                                                                            |
| -sV     | service version                                                                                                             |
| -p-     | range of ports (-p-: all of the 65,536 ports, -p80-10000:from port 80 to 10000 )                                            |
| -sU     | UDP scan                                                                                                                    |
| -O      | Operating system scan                                                                                                       |
| -sC     | Default nmap script scan                                                                                                    |
| -A      | Aggressive scan  (combines the operating system, service system and the default script scan)                                |
| -T0,-T5 | Timing template, the higher the number, the faster the scan is. However, the slower the scan is the more silent the scan is |
| -oN,-oX | Output results in normal format, xml format                                                                                 |                                                                                                                       |


