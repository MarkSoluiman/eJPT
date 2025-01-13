---

---
---


In order to find the IP address of a a website, we can use the ```host``` command in Kali.

===If we see a website that has two IP addresses linked to it, we know that we are dealing with some type of proxy===.

Another tool that we can use that comes pre-installed on Kali is ```whatweb``` 

```whatweb``` helps us to know what technologies a website is using


---

One of the ways we can use to gather info about a website is to look for the robot.txt file of a website or its sitemap.xml file.

#### What is robot.txt file?

It is a plain text file that instructs web crawlers on which pages they can access on a website

#### What is sitemap.xml file?

A text file that lists a website's pages and other information to help search engines crawl and index the site. 
The purpose of it is to help search engines understand a website's structure, including its pages, sections, hierarchy, and links. 


---

Another useful tool we can use to inspect the entire source code of a website page is ==HTTrack== which is a tool we can install on our Kali machines by: ```sudo apt-get install webhttrack -y```

---
## Whois Enumeration

Another way to gather info about a website is to use whois tool that will allow us to know when the website was registered, who owns it, what subdomains are associated with it, etc. This tool is pre-installed on Kali. It can be used by the command: ```whois``` The tool is also available online on multiple websites.

---

## Netcraft Enumeration

Another useful tool that will provide us with more info about a targeted website is Netcraft.  It uses data mining to track and report on internet trends and it can help us find a vulnerability in one of the certificates used in a website. It also provides us with the technologies that a website is using.

---

## DNS Recon

DNSRecon is a command-line tool primarily used for DNS reconnaissance, allowing users to ==gather information about a target domain by performing various DNS record lookups, including subdomain discovery, IP address retrieval, and checking for specific DNS record types like A, AAAA, CNAME, and SRV records==, essentially providing detailed insights about a domain's DNS configuration and potential vulnerabilities.

We can use dnsrecon to target a domain:```dnsrecon -d {targeted domain}```

There is an online tool that acts line dnsrecon, called dnsdumpster. 

This website shows the info in a much more easier way to understand and to visualize.

---


## WAF Detection with wafw00f

#### What is WAF?

WAF is ==web application firewall==. 

wafw00f tool will help us to detect firewalls that might be protecting our targets, and this is how it works:
- Sends a _normal_ HTTP request and analyses the response; this identifies a number of WAF solutions.
- If that is not successful, it sends a number of (potentially malicious) HTTP requests and uses simple logic to deduce which WAF it is.
- If that is also not successful, it analyses the responses previously returned and uses another simple algorithm to guess if a WAF or security solution is actively responding to our attacks.


<u>wafw00f comes pre-installed on Kali</u>.

#### Useful flags:

- `-a, --findall ` Find all WAFs which match the signatures, do not stop testing on the first one
-  `-i INPUT, --input-file=INPUT `Read targets from a file. Input format can be csv, json or text. For csv and json, a `url` column name or element is required.
- 


---

## Subdomain Enumeration using Sublist3r



Sublist3r is a python tool designed to enumerate subdomains of websites using OSINT. It helps penetration testers and bug hunters collect and gather subdomains for the domain they are targeting. Sublist3r enumerates subdomains using many search engines such as Google, Yahoo, Bing, Baidu and Ask. Sublist3r also enumerates subdomains using Netcraft, Virustotal, ThreatCrowd, DNSdumpster and ReverseDNS


#### Useful flags

| Short Form | Long Form    | Description                                             |
| ---------- | ------------ | ------------------------------------------------------- |
| -d         | --domain     | Domain name to enumerate subdomains of                  |
| -b         | --bruteforce | Enable the subbrute bruteforce module                   |
| -p         | --ports      | Scan the found subdomains against specific tcp ports    |
| -v         | --verbose    | Enable the verbose mode and display results in realtime |
| -t         | --threads    | Number of threads to use for subbrute bruteforce        |
| -e         | --engines    | Specify a comma-separated list of search engines        |
| -o         | --output     | Save the results to text file                           |
| -h         | --help       | show the help message and exit                          |

---

## Google Dorks

- Site: this operator limits all the search results to a site. Example, site:ine.com
- inurl: this operator will show the results that its url matches the url that we provided.
-  * This wild card can be used to get the subdomains of a website. Example: site:* .ine.com
-  intitle: this operator will show search results that has the words in their titles
- filetype: this operator will show search results that contains specific types of files.

Some websites might have directory listing enabled. We can use this mis-configuration  for our advantage. ==We can use the intitle operator with index of as input.==

#### Other useful Google Dorking queries:

- inurl:auth_user_file.txt
- inurl:passwd.txt

The google hacking database in Exploit-db can be useful as well: https://www.exploit-db.com/google-hacking-database

---

## Email Harvesting With theHarvester

theHarvester is a simple to use, yet powerful tool designed to be used during the reconnaissance stage of a red  
team assessment or penetration test. It performs open source intelligence (OSINT) gathering to help determine  
a domain's external threat landscape. The tool gathers names, emails, IPs, subdomains, and URLs by using  
multiple public resources.

#### Useful tags:
| tags | description                     |
| ---- | ------------------------------- |
| -d   | define the domain or the target |
| -b   | define the source of the search |

---

## Leaked Password Databases

Once we have an email of an employer for example, we can check if their email was included in any data breaches using this website: https://haveibeenpwned.com/