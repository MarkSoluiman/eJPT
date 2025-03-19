
---


# Lab Environment

In this lab environment, you will be provided with GUI access to a Kali Linux machine. The target website is accessible at **http://target.ine.local**.

**Objective**: Identify web application vulnerabilities in the target website and capture all the flags hidden within the environment.

**Useful wordlists:**

```
/usr/share/wordlists/dirb/common.txt 
/usr/share/seclists/Usernames/top-usernames-shortlist.txt 
/root/Desktop/wordlists/100-common-passwords.txt
```

**Flags to Capture:**

- **Flag 1:** Sometimes, important files are hidden in plain sight. Check the root ('/') directory for a file named 'flag.txt' that might hold the key to the first flag.
- **Flag 2:** Explore the structure of the server's directories. Enumeration might reveal hidden treasures.
- **Flag 3:** The login form seems a bit weak. Trying out different combinations might just reveal the next flag.
- **Flag 4:** The login form behaves oddly with unexpected inputs. Think of injection techniques to access the 'admin' account and find the flag.

# Tools

The best tools for this lab are:

- Nmap
- Gobuster
- Hydra

---

We will start with our Nmap scan in MSF console: `db_nmap -Pn -A -v target.ine.local`

We will only get one open port: http/80.

We will visit the website.

We will notice that 4 files we can view on this url: "http://target.ine.local/view_file?file=file1.txt"

To get the first flag, we will need to perform local file inclusion which allows us to view files that we should not be able to see within the system directory that is hosting the file.

To get the first flag, we will go to: "http://target.ine.local/view_file?file=/../flag.txt"


**First flag:** 7317f792456946dbaf5d84d1ec30388b

---

To get the second flag, we will use dirb tool on Kali or we will use wmap plugin in MSF console: `dirb http://target.ine.local/`

We will find a directory called: "secured"

If we go to this directory, we will find the second flag file: "flag.txt"

We will go to: "http://target.ine.local/secured/flag.txt" to view the second flag.

**Second flag:** 2c198b13c53d492ca698f7ab3fb8412e

---

To get the third flag, we will perform brute force to try to login using the login page.

However, we first need to gather some information on what message we get if we try to login using invalid credentials. The page shows us this message when we try invalid credentials: "Invalid username or password". We will use this message to tell Hydra that this message appears when the credentials are invalid: `hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt -P /root/Desktop/wordlists/100-common-passwords.txt target.ine.local http-post-form "/login:username=^USER^&password=^PASS^:Invalid username or password"`

In some cases, websites don't show us any message when we try to login. In this case, we can use another filter in Hydra to tell Hydra that the HTTP response code the it will get means that the credentials are valid: `hydra -l admin -P passwords.txt target.com http-post-form "/login.php:username=^USER^&password=^PASS^:S=302"` This will tell Hydra that HTTP response code of 302 points to valid credentials.

Our credentials that we can use to login are: "guest:butterfly1"

**Third flag:** 50020081848846dfb1f8a02ee3be24b8

---

To get the forth flag, we will use SQL Injection to login to admin user account.

We will use BurpSuite along with this list of Auth pass SQLi sheet from GitHub: https://github.com/payloadbox/sql-injection-payload-list

We will capture a login POST request and send it to Intruder in BurpSuite.

Using Sniper attack type, we will add a payload marker on the username value we put.

In Payloads tab, we will paste the list we copied from the GitHub repository. Then we start the attack.

In the response length, we will notice three lengths: 438,618, and 3818.

 If we go to a payload that has a 438 length response, we will find a 500 Internal Server Error response from the website, means that our input is not accepted from the webserver and it couldn't handle it.

If we got to a payload that has a 618, we will a 302 Found response. That means we managed to log in with this payload. We will try any of the payloads that gave us this result. For example: "admin' --"

We can login using this payload as our username and any password.

**Forth flag:** 2f7c75352b85412e8a17f873bff92e31

